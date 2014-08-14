#Downloading client
========
The client downloads the whole video segment by segment according to the available bandwidth and selecting the most suitable representation (layer) for the segment that has to be dowloaded, then muxes the layers of the segment together and finally decodes and plays it using a specific video player meanwhile the next segment is downloaded.

The client has two options:
With "-detail" the client shows the detail about the video that we want to download, as shown in the example below: 

	python client.py http://130.233.193.139/video_folder/video_test/video_test.264.mpd -detail


With "-play" the client starts thestreaming of the selected video, as shown in the example below:

	python client.py http://130.233.193.139/video_folder/video_test/video_test.264.mpd -play
