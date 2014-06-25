import subprocess, sys
import httplib
import httplib2
from urlparse import urlparse
import urllib2
from xml.dom.minidom import parseString
import re
import time
import os

if(len(sys.argv)<6):
	print("ERROR:Wrong number of argument.")
	print("Usage: client_upload [path/]filename [url]server #frame_per_segment resolution_width resolution_height")
	quit()


bitstreamName = sys.argv[1]
httpServer = sys.argv[2]
framePerSegment= sys.argv[3]
resWidth = sys.argv[4]
resHeight =sys.argv[5]


#demux function
def demuxVideo(bitstreamName,framePerSegment):
	command = ["python", "svc_demux.py"]
	command.append(bitstreamName)
	command.append(framePerSegment)
	command.append(resWidth)
	command.append(resHeight)
	subprocess.call(command)
	print command
	mpdName = bitstreamName+'.mpd'
	return mpdName


#create DOM file function
def getMPD(mpdName):
	tmp = open(mpdName)
	mpd = tmp.read()
	tmp.close()
	return mpd


mpdName = demuxVideo(bitstreamName,framePerSegment)
print "Bitstream demuxed correctly"
mpd= getMPD(mpdName)
mpdLenght = os.path.getsize(mpdName)
dom = parseString(mpd)
print "read and parse information in mpd file "
layerID = []
layerList = ""
layRepresentTag = dom.getElementsByTagName('Representation')
for i in layRepresentTag:
		tmp = str(i.attributes['id'].value)
		layerID.append(tmp)
		layerList = layerList + i.attributes['id'].value + " "
layersNum=len(layerID)

url = httpServer+'/'+mpdName
response = urllib2.urlopen(url, mpd)


for layerDom in range(0,layersNum):
	print "uploading layer:"+ str(layerDom)
	segListTag = dom.getElementsByTagName("SegmentList")[layerDom]
	numberofSeg = segListTag.getElementsByTagName("SegmentURL")
	for k in numberofSeg:
		segName = str(k.attributes['media'].value)
		url = httpServer+'/'+ segName
		tmp = open(segName)
		segment = tmp.read()
		tmp.close()
		response = urllib2.urlopen(url, segment)
	print response.read()














