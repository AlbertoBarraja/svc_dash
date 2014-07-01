import subprocess, sys
import httplib
import urllib2
import time
import os
from urlparse import urlparse
from xml.dom.minidom import parseString

if(len(sys.argv)<6):
	print("ERROR:Wrong number of argument.")
	print("Usage: client_upload [path/]filename [url]server #frame_per_segment resolution_width resolution_height")
	quit()


bitstreamName = sys.argv[1]
httpServer = sys.argv[2]
framePerSegment= sys.argv[3]
resWidth = sys.argv[4]
resHeight =sys.argv[5]

#-------------------------------- FUNCTIONS -------------------------------------#

#demux function
def demuxVideo(bitstreamName,framePerSegment):
	command = ["python", "svc_demux.py"]
	command.append(bitstreamName)
	command.append(framePerSegment)
	command.append(resWidth)
	command.append(resHeight)
	subprocess.call(command)
	mpdName = bitstreamName+'.mpd'
	return mpdName


#create DOM file function
def getMPD(mpdName):
	tmp = open(mpdName)
	mpd = tmp.read()
	tmp.close()
	return mpd

#retrive number of layers 
def getNumberLayers(layerID, layerBW , layerList):
	layRepresentTag = dom.getElementsByTagName('Representation')
	for i in layRepresentTag:
		tmpID = str(i.attributes['id'].value)
		layerID.append(tmpID)
		tempBW = float(i.attributes['bandwidth'].value)
		layerBW.append(tempBW)
		layerList = layerList + i.attributes['id'].value + " "
	return	len(layerID)


#upload segment calculate Bandwith function
def getBandWith(segName, httpServer):
	segLenght = os.path.getsize(segName)
	url = httpServer+'/'+ segName
	tmp = open(segName)
	segment = tmp.read()
	tmp.close()
	t1 = time.time()
	request = urllib2.urlopen(url, segment)
	print request.getcode()
	t2 = time.time()
	timeInterval = float(t2-t1)
	currentBandwith = float(segLenght*8/(t2-t1))
	return currentBandwith

#--------------------------------- MAIN ----------------------------------------------#
#--- Bitstream demuxed and .mpd and .dom file generation  ---#
mpdName = demuxVideo(bitstreamName,framePerSegment)
mpd= getMPD(mpdName)
mpdLenght = os.path.getsize(mpdName)
dom = parseString(mpd)

#--- upload .mpd file ---#
url = httpServer+'/'+mpdName
request = urllib2.urlopen(url, mpd)
#print request.getcode()

#--- selective upload ---#
layerID = []
layerBW = []
layerList = ""
layersNum = int(getNumberLayers(layerID, layerBW ,layerList))

#--- taking layers' segments iformation ---#
for d1 in range(0,layersNum):
	segList = dom.getElementsByTagName("SegmentList")[d1]
	segUrl = segList.getElementsByTagName("SegmentURL")
	numSeg = int(len(segUrl))
	if d1==0:
		segTable = [ [ 0 for i in range(numSeg) ] for j in range(layersNum) ]
	d2 = int(0)	
	for k in segUrl:
		segName = str(k.attributes['media'].value)
		segTable[d1][d2]= segName
		d2 = int(d2+1)

#--- selective upload ---#
for i in range(0,numSeg):
	if i==0:
		segName = segTable[1][0]
	currBW = getBandWith(segName, httpServer)
	threshold = 0
	for j in range(0,layersNum):
		threshold = threshold + layerBW[j]
		if(currBW>=threshold):
			selectedLayer=j
		else:
			break
	for k in range(0,selectedLayer+1):
		segName = segTable[k][i]
		currBW = getBandWith(segName, httpServer)

