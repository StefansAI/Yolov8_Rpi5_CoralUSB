#install YOLOv8
#https://docs.ultralytics.com/guides/raspberry-pi/
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y
python3 -m venv yolo_env
source yolo_env/bin/activate
pip3 install ultralytics


#Test on GardenCam video clip
cd $HOME
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam640.pt
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam640.mp4
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam320.pt
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam320.mp4
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam224.pt
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam224.mp4

timeout 60s yolo detect predict model=GardenCam640.pt source=GardenCam640.mp4 imgsz=640 show=True
timeout 45s yolo detect predict model=GardenCam320.pt source=GardenCam320.mp4 imgsz=320 show=True
timeout 30s yolo detect predict model=GardenCam224.pt source=GardenCam224.mp4 imgsz=224 show=True

