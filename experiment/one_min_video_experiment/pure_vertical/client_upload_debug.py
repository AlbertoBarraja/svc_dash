#!/usr/bin/python

import subprocess, sys
import httplib
import urllib2
import datetime
import time
import os.path
from urlparse import urlparse
from xml.dom.minidom import parseString
from time import sleep
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
segment_indexes = []
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

#retrive number of layers, then fill layerBW and segment_indexes arrays acoordingly
def getNumberLayers(layerID, layerBW , layerList):
	layRepresentTag = dom.getElementsByTagName('Representation')
	for i in layRepresentTag:
		tmpID = str(i.attributes['id'].value)
		layerID.append(tmpID)
		tempBW = float(i.attributes['bandwidth'].value)
		layerBW.append(tempBW)
		segment_indexes.append(0)
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
	response.read()
	t2 = time.time()
	time_response = datetime.datetime.now().time()
	timeInterval = float(t2-t1)
	currentBandwith = float(segLenght*8/timeInterval)
	return (currentBandwith,timeInterval,time_response,segLenght)

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
response.read()

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

#------------------------------------------ WORKING POINT -------------------------------------------------#

"""
# HORIZONTAL APPROACH
def getNextSize(layer, segment):	
	current_segment= int(segment +1)
	next_layer=layer 
	next_segment=segment_indexes[next_layer]	

	while(next_segment==current_segment):
		next_layer = next_layer +1
		next_segment = segment_indexes[next_layer]
		
	segName = segTable[next_layer][next_segment]
	length = os.path.getsize(segName)
	return (length,segName,next_layer)


# VERTICAL APPROACH
def getNextSize(layer,segment):	
	current_segment= segment_indexes[layer]
	next_layer = layer+1
	#print " layer is"+ str(next_layer)										#DEBUG
	next_segment = segment_indexes[next_layer]
	#print " segment "+ str(next_layer)+" next_segment "+ str(next_segment)	#DEBUG

	while(next_segment==current_segment):
		next_layer = next_layer +1
		#print " layer is"+ str(next_layer)										#DEBUG
		next_segment = segment_indexes[next_layer]
		#print " segment "+ str(next_layer)+" next_segment "+ str(next_segment)	#DEBUG
		
	segName = segTable[next_layer][next_segment]
	length = os.path.getsize(segName)
	return (length,segName,next_layer)
"""

# PURE VERTICAL
def getNextSize(layer,segment):	
	next_layer = layer+1
	segName = segTable[next_layer][segment]
	length = os.path.getsize(segName)
	return (length,segName,next_layer,segment)


#--- diagonal upload ---#
time_start = time.time();
session_deadline = 2 	# 2 sec session deadline
session_protection_time = 0.1;
deadline = float(session_deadline - session_protection_time)
current_layer = 0
segment_num = 0
total_sleep_time = 0


print numSeg
print layersNum

while(segment_num<numSeg):
	session_time = 0
	session_segment_time = 0
	layer_num = 0
	print "---------------------------------------- "


	while(layer_num< (layersNum ) ):
		next_name = segTable[layer_num][segment_num]
		#print next_name		  	# DEBUG
		#rint " "				# DEBUG
		currBW, chunk_time_delta, chunk_response_time, chunk_size  = getBandWith(next_name, httpServer)
		print str(chunk_response_time) +"[ " + str(segment_num) + ","+str(layer_num) + "] | est BW: [" + str (float(currBW/1024.0) ) + " Kb/s] | T seg: ["+str (float((int(chunk_time_delta*10000+0.5) )/10000.0))+" s] | T sec: ["+str (float((int( session_time*10000+0.5) )/10000.0))+" s]]" 
		session_time = float(session_time + chunk_time_delta)

		layer_num = layer_num +1	

	time_end=time.time()
	delta =float(time_end-time_start)
	low_limit=float(segment_num*2)
	up_limit=float((segment_num+1)*2)
	if( (low_limit<delta<uplimit) and (session_time<session_deadline):
		leftover= float (session_deadline-session_time)
		print"		wait "+ str(leftover)
		sleep(leftover)
		total_sleep_time = float(total_sleep_time + leftover)

	segment_num = segment_num +1 

print " "
time_end=time.time()
delta =float(time_end-time_start)
print "total time: "+str(delta)+" s"
print "total wait time " + str(total_sleep_time)+" s"
print segment_indexes
print "--- END --- "