#!/usr/bin/python

import subprocess, sys
import httplib
import urllib2
import datetime
import time
import os.path
from urlparse import urlparse
from xml.dom.minidom import parseString
from logger.loggerinitializer import *
from svc_demux import *

if(len(sys.argv)<7):
	print("ERROR:Wrong number of argument.")
	print("Usage: \n",sys.argv[0]," [path/filename] [url server] [frame per segment] [resolution width] [resolution_height] [frame rate]")
	quit()

initialize_logger('/home/barraja1/thesis_repository/Uploading_Client/logger')

bitstreamName = sys.argv[1]	# e.g. testVideo.264
httpServer = sys.argv[2]	# e.g. http://localhost:8888/video_folder
framePerSegment= sys.argv[3]	# e.g. 2 second fragment for 25 fps -> framesPerSegment = 50
resWidth = sys.argv[4]		# e.g. 352
resHeight = sys.argv[5]		# e.g. 288
fps = sys.argv[6]		# e.g. 25 
baseURL = './'

layerID = []
layerBW = []
layerList = ""

#-------------------------------- FUNCTIONS -------------------------------------#

#demux function
def demuxVideo(bitstreamName, framePerSegment, resWidth, resHeight, fps, baseURL ):
	getChunks(bitstreamName, framePerSegment, resWidth, resHeight, fps, baseURL )
	mpdName = bitstreamName+'.mpd'
	return mpdName


#create MPD file function
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
	try: 
    		response = urllib2.urlopen(url, segment)
	except urllib2.HTTPError, e:
		message = str(datetime.datetime.now().time()) + "	HTTPError :	" + str(e.code)
		logging.error(message)
	except urllib2.URLError, e:
		message = str(datetime.datetime.now().time()) + "	URLError :	" + str(e.reason)
		logging.error(message)
	except httplib.HTTPException, e:
		message = str(datetime.datetime.now().time()) + "	HTTPException"
		logging.error(message)   		
	except Exception:
    		import traceback
		message = str(datetime.datetime.now().time()) + "	generic exception:	 "
    		#message = str(datetime.datetime.now().time()) + "	generic exception:	 " + traceback.format_exc())
		logging.error(message)
	
	t2 = time.time()
	#print response.read()
	timeInterval = float(t2-t1)
	currentBandwith = float(segLenght*8/(t2-t1))
	return currentBandwith

#select appropriate to upload function
def getSegment(i, layersNum, segTable, currBW):	
	if i==0:
		segName = segTable[1][0]
		currBW = getBandWith(segName, httpServer)
		message = str(datetime.datetime.now().time()) + "	uploading segment [" + str(i) + "] | layer [0] completed | current bandwitdth: [" + str((currBW/8)/1024) + "KB/s]"
		logging.info(message)

	threshold = 0
	for j in range(0,layersNum):
		if (i==0) and (j==0):
			continue
		else:
			threshold = layerBW[j]
			if(currBW>=threshold) or (j==0):			
				selectedLayer=j
				preBW = currBW 
				segName = segTable[j][i]
				currBW = getBandWith(segName, httpServer)
				message = str(datetime.datetime.now().time()) + "	uploading segment [" + str(i) + "] | layer [" + str(j) + "] completed | previous bandwitdth: [" + str((preBW/8)/1024) + "KB/s] | threshold layer [" + str(j) + "] : [ " + str((threshold/8)/1024) + "KB/s] | current bandwitdth: [" + str((currBW/8)/1024) + "KB/s]" 
				logging.info(message)
				continue		
			else:			
				break
	print "layer [" + str(selectedLayer) + "] selected"
	return (selectedLayer, currBW)

#--------------------------------- MAIN ----------------------------------------------#
#--- check if the file exists  ---#
if not os.path.exists(bitstreamName):
	print "ERROR: "+bitstreamName+" does not exist."	
	quit()

#--- check if the file extension is correct  ---#
fileExtension = bitstreamName.split('.')[1]
if (fileExtension != "264"):
	print "ERROR: extension of the file "+bitstreamName+" is not supported."	
	quit()

#--- Bitstream demuxed and .mpd and .dom file generation  ---#
mpdName = demuxVideo(bitstreamName, framePerSegment, resWidth, resHeight, fps, baseURL)
mpd= getMPD(mpdName)
mpdLenght = os.path.getsize(mpdName)
dom = parseString(mpd)

#--- upload .mpd file ---#
url = httpServer+'/'+mpdName
try: 
    	response = urllib2.urlopen(url, mpd)
	message = str(datetime.datetime.now().time()) + "	.mpd file sent successfully"
	logging.info(message)
except urllib2.HTTPError, e:
	message = str(datetime.datetime.now().time()) + "	HTTPError :	" + str(e.code)
	logging.error(message)
	quit()	
except urllib2.URLError, e:
	message = str(datetime.datetime.now().time()) + "	URLError :	" + str(e.reason)
	logging.error(message)
	quit()
except httplib.HTTPException, e:
	message = str(datetime.datetime.now().time()) + "	HTTPException"
	logging.error(message)
	quit()
except Exception:
	import traceback
	message = str(datetime.datetime.now().time()) + "	generic exception:	 "
    	#message = str(datetime.datetime.now().time()) + "	generic exception:	 " + traceback.format_exc())
	logging.error(message)
	quit()
#print response.read()

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

#--- create table storing not uploaded chunks ---#
notUploadedTable = [ [ 0 for i in range(numSeg) ] for j in range(layersNum) ]
missing = 0
#--- selective upload ---#
for i in range(0,numSeg):
	if i == 0:
		currBW = 0
	selectedLayer, currBW = getSegment(i, layersNum, segTable, currBW)

	#--- saving chunk names not selected ---#		
	if(selectedLayer <(layersNum-1)):
		missing = 1
		selectedLayer = selectedLayer +1;	
		for x in range(selectedLayer,layersNum):
			tempName = segTable[x][i]			
			notUploadedTable[x][i]=tempName
	print "===================================================================================================================================================================================="

#--- upload remaining segments---#
for j in range(1,layersNum):
	print "layer [" + str(j) + "]"
	for i in range(0,numSeg):	
		if (notUploadedTable[j][i]==0):
			continue
		else:
			print "segment [" + str(i) + "]"
			threshold = layerBW[j]
			#if(currBW>=threshold):
			preBW = currBW 
			segName = segTable[j][i]
			currBW = getBandWith(segName, httpServer)
			message = str(datetime.datetime.now().time()) + "	uploading segment [" + str(i) + "] | layer [" + str(j) + "] completed | previous bandwitdth: [" + str((preBW/8)/1024) + "KB/s] | threshold layer [" + str(j) + "] : [ " + str((threshold/8)/1024) + "KB/s] | current bandwitdth: [" + str((currBW/8)/1024) + "KB/s]" 
			logging.info(message)
	print "===================================================================================================================================================================================="	
print " "
print notUploadedTable
print " "
print "--- END --- "
