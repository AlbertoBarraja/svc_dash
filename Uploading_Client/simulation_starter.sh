sudo rm *.svc
sudo rm output_2.txt
sudo ~/thesis_repository/Bandwidth_shaper/netem.sh eth0 init
python client_upload_debug.py sequence.264 http://130.233.193.136:8888/video_folder 60 352 288 30 & ~/thesis_repository/Bandwidth_shaper/netem.sh eth0 tc ~/thesis_repository/Bandwidth_shaper/config.txt 2 && fg