#install YOLOv8
#https://docs.ultralytics.com/guides/raspberry-pi/
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y
python3 -m venv yolo_env
source yolo_env/bin/activate
pip3 install ultralytics

#https://docs.ultralytics.com/guides/coral-edge-tpu-on-raspberry-pi/
wget https://github.com/feranick/libedgetpu/releases/download/16.0TF2.16.1-1/libedgetpu1-std_16.0tf2.16.1-1.bookworm_arm64.deb
sudo dpkg -i libedgetpu1-std_16.0tf2.16.1-1.bookworm_arm64.deb
rm libedgetpu1-std_16.0tf2.16.1-1.bookworm_arm64.deb

wget https://github.com/feranick/libedgetpu/releases/download/16.0TF2.16.1-1/libedgetpu-dev_16.0tf2.16.1-1.bookworm_arm64.deb
sudo dpkg -i libedgetpu-dev_16.0tf2.16.1-1.bookworm_arm64.deb
rm libedgetpu-dev_16.0tf2.16.1-1.bookworm_arm64.deb

#the export here fails, but installs many additional packages
yolo export model=yolov8n.pt format=edgetpu || true

#since the exports failed, get the exports from github
cd $HOME
mkdir yolov8s_saved_model
cd yolov8s_saved_model
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/yolov8s_saved_model/metadata.yaml
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/yolov8s_saved_model/yolov8s_full_integer_quant.tflite
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/yolov8s_saved_model/yolov8s_int8.tflite
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/yolov8s_saved_model/yolov8s_integer_quant.tflite

cd $HOME
mkdir yolov8n_saved_model
cd yolov8n_saved_model
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/yolov8n_saved_model/metadata.yaml
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/yolov8n_saved_model/yolov8n_full_integer_quant.tflite
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/yolov8n_saved_model/yolov8n_int8.tflite
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/yolov8n_saved_model/yolov8n_integer_quant.tflite

# Test on a 
cd $HOME
yolo detect predict model=yolov8n_saved_model/yolov8n_full_integer_quant.tflite data=yolov8n_saved_model/metadata.yaml source=0 show=True

#Test on GardenCam video clip
mkdir GardenCam-best-n_saved_model
cd GardenCam-best-n_saved_model
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/GardenCam-best-n_saved_model/metadata.yaml
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/GardenCam-best-n_saved_model/GardenCam-best-n_full_integer_quant.tflite
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/GardenCam-best-n_saved_model/GardenCam-best-n_int8.tflite
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/tflite/GardenCam-best-n_saved_model/GardenCam-best-n_integer_quant.tflite

cd $HOME
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam-best-n.pt
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam.mp4

yolo detect predict model=GardenCam-best-n_saved_model/GardenCam-best-n_integer_quant.tflite data=GardenCam-best-n_saved_model/metadata.yaml source=GardenCam.mp4 show=True

