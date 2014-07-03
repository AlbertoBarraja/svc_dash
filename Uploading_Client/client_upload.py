import subprocess, sys
import httplib
import urllib2
import time
import os.path
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
	try: 
    		response = urllib2.urlopen(url, segment)
	except urllib2.HTTPError, e:
    		print "HTTPError = " + str(e.code)
	except urllib2.URLError, e:
    		print "URLError = " + str(e.reason)
	except httplib.HTTPException, e:
    		print"HTTPException"
	except Exception:
    		import traceback
    		print('generic exception: ' + traceback.format_exc())
	
	t2 = time.time()
	#print response.read()
	timeInterval = float(t2-t1)
	currentBandwith = float(segLenght*8/(t2-t1))
	return currentBandwith

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
mpdName = demuxVideo(bitstreamName,framePerSegment)
mpd= getMPD(mpdName)
mpdLenght = os.path.getsize(mpdName)
dom = parseString(mpd)

#--- upload .mpd file ---#
url = httpServer+'/'+mpdName
try: 
    	response = urllib2.urlopen(url, mpd)
except urllib2.HTTPError, e:
	print "HTTPError = " + str(e.code)
	quit()	
except urllib2.URLError, e:
	print "URLError = " + str(e.reason)
	quit()
except httplib.HTTPException, e:
	print"HTTPException"
	quit()
except Exception:
	import traceback
	print "generic exception"
	#print "generic exception: " + traceback.format_exc()
	quit()

#print response.read()

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
	print "=================================================="
	print "uploading segment: " + str(i)
	print "current bandwitdth: " + str(currBW/1000) + "Kb/s"
	for j in range(0,layersNum):
		threshold = threshold + layerBW[j]
		if(currBW>=threshold):
			selectedLayer=j
		elif j == 0:
			selectedLayer = j
			break 
		else:
			break
	print "selected layer: " + str(selectedLayer)
	for k in range(0,selectedLayer+1):
		segName = segTable[k][i]
		currBW = getBandWith(segName, httpServer)
	print "upload segment " + str(i) + " competed"

