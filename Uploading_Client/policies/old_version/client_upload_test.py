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
	
	t2 = time.time()
	#print "time_1: "+str(t1)+" time_2: "+str(t2)
	#print response.read()
	timeInterval = float(t2-t1)
	#print timeInterval
	currentBandwith = float(segLenght*8/(t2-t1))
	return (currentBandwith,timeInterval)

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

#------------------------------------------ WORKING POINT -------------------------------------------------#

def getNextSize(layer, segment):	
	current_segment= int(segment +1)
	print current_segment
	next_layer=layer 							#try
	next_segment=segment_indexes[next_layer]				#try
	#next_layer = layer+1 						#try
	#print " layer is"+ str(next_layer)										#DEBUG
	#next_segment = segment_indexes[next_layer] #try
	#print " segment "+ str(next_layer)+" next_segment "+ str(next_segment)	#DEBUG

	while(next_segment==current_segment):
		print "curr: "+str(current_segment)+"next:"+str(next_segment)+"layer: "+str(next_layer)
		next_layer = next_layer +1
		#print " layer is"+ str(next_layer)										#DEBUG
		next_segment = segment_indexes[next_layer]
		#print " segment "+ str(next_layer)+" next_segment "+ str(next_segment)	#DEBUG
		
	segName = segTable[next_layer][next_segment]
	length = os.path.getsize(segName)
	return (length,segName,next_layer)

#--- diagonal upload ---#
start_layer = 0
upload_time = 0
count = segment_indexes[start_layer]

print "------------------------ START UPLOAD -------------------------"
time_start= time.time();
deadline=int(2)

while(count<numSeg):
	print "------------------------ SEG "+str(count)+" LAY "+str(start_layer)+" -------------------------"
	next_name = segTable[start_layer][count]
	current_layer = start_layer
	session_time = 0
	tmp_forecast= 0 
	forecast_time=0

	while((session_time<deadline) or (forecast_time <deadline)):
		currBW, upload_time  = getBandWith(next_name, httpServer)

		uploaded_layer=current_layer
		time_now=datetime.datetime.now().time()
		segment_indexes[current_layer] = segment_indexes[current_layer] + 1 
		session_time = float(session_time + upload_time)
		print segment_indexes
		
		if(current_layer< (layersNum - 1) ):
			next_length,next_name,current_layer = getNextSize(current_layer, count)
			tmp_forecast= float(next_length/currBW)
			forecast_time= float (session_time+(next_length/currBW))
			message = str(time_now) + "	seg [" + str(count) +"," + str(uploaded_layer) + "] | thr: [" + str (float((int( (layerBW[start_layer]/1024.0) *10000+0.5) )/10000.0)) + "Kb/s] | est BW: [" + str (float((int( (currBW/1024.0) *10000+0.5) )/10000.0)) + " Kb/s] | T seg: ["+str (float((int( upload_time*10000+0.5) )/10000.0))+" s] | T sec: ["+str (float((int( session_time*10000+0.5) )/10000.0))+" s] | T frc seg: ["+str (float((int( tmp_forecast*10000+0.5) )/10000.0))+" s] | T frc sec: ["+str (float((int( forecast_time*10000+0.5) )/10000.0))+" s]"
			logging.info(message)
		else:
			tmp_forecast= 0
			forecast_time= 0
			message = str(time_now) + "	seg [" + str(count) +"," + str(uploaded_layer) + "] | thr: [" + str (float((int( (layerBW[start_layer]/1024.0) *10000+0.5) )/10000.0)) + "Kb/s] | est BW: [" + str (float((int( (currBW/1024.0) *10000+0.5) )/10000.0)) + " Kb/s] | T seg: ["+str (float((int( upload_time*10000+0.5) )/10000.0))+" s] | T sec: ["+str (float((int( session_time*10000+0.5) )/10000.0))+" s] | T frc seg: ["+str (float((int( tmp_forecast*10000+0.5) )/10000.0))+" s] | T frc sec: ["+str (float((int( forecast_time*10000+0.5) )/10000.0))+" s]"
			logging.info(message)
			break

	count = count + 1
	#print "session_time: "+str(session_time)+" forecast_time: "+str(forecast_time)
	#print "---------------------------------------------------------------"

	if(session_time<deadline):
		leftover= float (deadline-session_time)
		print "---------------------------------------------------------------"
		print"wait "+ str(leftover)
		print "---------------------------------------------------------------"
		sleep(leftover) # time in seconds


	while(count == numSeg ): 
		time_layer_over=time.time()
		layer_delta =float(time_layer_over-time_start)
		print layer_delta
		print "------------------------ LAYER OVER -------------------------"
		deadline=float(0.00000000000001)
		start_layer = start_layer +1
		print start_layer
		if (start_layer < layersNum):
			count = segment_indexes[start_layer]
		else:
			break
	

print " "
time_end=time.time()
delta =float(time_end-time_start)
print "total time: "+str(delta)+" s"
print segment_indexes
print "--- END --- "
