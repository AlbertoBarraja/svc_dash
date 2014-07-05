#!/usr/bin/python

# Demultiplexer for SVC-DASH. Splits the SVC bitstream into chunks, one per layer. 
# Supports segmentation. Generates MPD.
#
# Note: SVC bitstreams must have constant IDR rate.
# Note: MPD generation only supports quality scalability, i.e., spatial layers are currently not represented correctly in the MPD.
# 
# (1:stream, [2:framesPerSegment=0], [3:width=352], [4:height=288], [5:frameRate=25], [6:baseURL='.'])

import sys, struct, os;

def getChunks(bitstreamName, framePerSegment, resWidth, resHeight, fps, baseURL):

	configSelfContainedSegments = False  # If set, each segment gets its own init NALUs (type SPS, PPS, SSPS, SPSE). InitSegment will be empty. Allowed values: True, False, "Both"
	configSvcExtension = ".svc"
	configNamespace = "urn:mpeg:DASH:schema:MPD:2011" 
	configInitSegFilenameTemplate = "{base}.init{svcExtension}"
	configChunkFilenameTemplate = "{base}.seg{seg}-L{layerId}{svcExtension}"
	configDefaultBufferTime = 1.0
	
	base = os.path.basename(bitstreamName)
	dir = os.path.dirname(bitstreamName)
	framesPerSeg = int(framePerSegment)
	width = int(resWidth)
	height = int(resHeight)
	frameRate = int(fps) 
	representations = {}
	bitrates = {}
	initSeg = []

	sep = struct.pack("BBBB", 0, 0, 0, 1)
	with open(bitstreamName, 'rb') as fpIn:
	    nalus = fpIn.read().split(sep)[1:]

	frm, last, init, justChanged = 0, 0, True, True
	for n in nalus: # Skip first empty element
	    layerId = 0
	    naluType = struct.unpack_from("B", n)[0] & 0x1f

	    if not naluType in [7, 8, 13, 15]: # SPS, PPS, SPSE, SSPS
		init = False
	    
	    if init:
		initSeg.append(n)
		continue
	    
	    if (len(n) >= 4):
		hdr = struct.unpack_from("BBBB", n)
		
		if (naluType in [14, 20]):
		    did = ( hdr[2] >> 4 ) & 0x7
		    qid = hdr[2] & 0xF
		    layerId = 16*did + qid
		
	    if (naluType in [10, 11]): # End of sequence
		layerId = last  # Write EOS NALU to same layer as previous NALU
	    
	    if (last and not layerId):
		oldSeg = int(frm / framesPerSeg) if framesPerSeg else 0
		frm+=1  # If last layer was > 0 and current layer is 0, this is a new frame.
		newSeg = int(frm / framesPerSeg) if framesPerSeg else 0
		justChanged = (oldSeg != newSeg)
	    
	    seg = int(frm / framesPerSeg) if framesPerSeg else 0
	    isNewLayer = not layerId in bitrates
	    isNewSeg = justChanged

	    filename = configChunkFilenameTemplate.format(base=base, seg=seg, layerId = layerId, svcExtension=configSvcExtension)
	    mode = None
	    segmentURL = '                    <SegmentURL media="{filename}"/>'.format(filename=filename)
	    length = len(sep+n) + (len(sep + sep.join(initSeg)) if configSelfContainedSegments and isNewSeg else 0)
	    
	    if isNewLayer:
	       representations[layerId] = {seg: segmentURL}
	       bitrates[layerId] = {seg: length}
	       mode = 'wb'
	    else:
		rep = representations[layerId]
		br = bitrates[layerId]
		if seg in br:
		    br[seg] += length
		    # Don't update rep[seg]
		    mode = 'ab'
		else:
		    br[seg] = length
		    rep[seg] = segmentURL
		    mode = 'wb'
	    
	    
	    with open(os.path.join(dir,filename), mode) as fpOut:
		if configSelfContainedSegments and isNewSeg:
		    fpOut.write(sep + sep.join(initSeg))
		
		fpOut.write(sep+n)

	    justChanged = False
	    last = layerId

	# write InitSegment
	initFilename = configInitSegFilenameTemplate.format(base=base, svcExtension=configSvcExtension)

	with open(os.path.join(dir,initFilename), 'wb') as fpOut:
	    if (not configSelfContainedSegments) or (configSelfContainedSegments is "Both"):
		fpOut.write(sep + sep.join(initSeg))


	# generate MPD:
	framesCount= frm + 1
	duration=float(framesCount/frameRate)
	minBufferTime=float(framesPerSeg/frameRate) or configDefaultBufferTime # In case framesPerSeg is 0

	mpdStartTpl = """<?xml version="1.0" encoding="UTF-8"?>
	<MPD xmlns="{namespace}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" type="static" profiles="urn:mpeg:dash:profile:isoff-main:2011" mediaPresentationDuration="PT{duration:.3f}S" minBufferTime="PT{minBufferTime:.3f}S">
	    <BaseURL>{baseURL}</BaseURL>
	    <Period start="PT0S">
		<AdaptationSet bitstreamSwitching="true">
	"""

	mpd = mpdStartTpl.format(namespace=configNamespace, duration=duration, minBufferTime=minBufferTime, baseURL=baseURL)



	last, bandwidth = None, 0
	for layerId in representations:
	    avg = sum(bitrates[layerId].values()) / len(bitrates[layerId].values())
	    bandwidth+= int(avg * 8 * frameRate / (framesPerSeg or framesCount))  # framesPerSeg might be 0.
	    dependencyId = 'dependencyId="{last}"'.format(last=last) if layerId else ''
	    repStartTpl = """            <Representation id="{layerId}" {dependencyId} codecs="svc" mimeType="video/H264-SVC" width="{width}" height="{height}" frameRate="{frameRate}" startWithSAP="1" bandwidth="{bandwidth}">
		        <SegmentBase>
		            <Initialization sourceURL="{initFilename}"/>
		        </SegmentBase>
		        <SegmentList duration="{framesPerSeg}" timescale="{frameRate}">
	"""
	    
	    mpd+= repStartTpl.format(layerId = layerId, dependencyId=dependencyId, width=width, height=height, frameRate=frameRate, bandwidth=bandwidth, initFilename=initFilename, framesPerSeg=framesPerSeg)
	    mpd+= "\n".join(representations[layerId].values())
	    mpd+= """
		        </SegmentList>
		    </Representation>
	"""
	    last = layerId

	mpd+= """        </AdaptationSet>
	    </Period>
	</MPD>
	"""


	with open(sys.argv[1] + '.mpd', 'w') as fpOut:
	    fpOut.write(mpd)
