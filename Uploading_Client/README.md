#Uploading client
========
Client that uploads the whole video after demuxing the bitsream into multiple chunks (one per layer) per segment and creating according to the DASH event an '.mpd' file that describe the multimeda content. To upload the vidoe the client send to the server the video segment by segment according to the available bandwidth and selecting the most suitable chunks for the segment that has to be uploaded.

The following command as to be typed in order to start the client:

	 python (path/filename) (url server) (frame per segment) (resolution width) (resolution_height) (frame rate)

As shows the example below: 

 	 python client_upload.py video_test.264 http://130.233.193.139:8888/video_folder 50 352 288 25 

