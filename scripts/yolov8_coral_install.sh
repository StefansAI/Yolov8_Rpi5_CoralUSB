#!/bin/bash
HL='\033[0;93m\033[44m' 
NC='\033[0m'

echo -e "${HL}================ preparing yolo installation ================${NC}"
# https://docs.ultralytics.com/guides/raspberry-pi/
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y

sudo apt-get install -y libhdf5-dev

#https://github.com/JungLearnBot/RPi5_yolov8/blob/main/Readme.RPi5.coral_tpu.picam.qt.md
sudo apt-get install -y cmake 

echo -e "${HL}================ create virtual environment and install ultralytics ================${NC}"
python3 -m venv yolo_env
source yolo_env/bin/activate
echo 'source yolo_env/bin/activate' >> ~/.bashrc 
pip install h5py
pip install ultralytics==8.0.221

echo -e "${HL}================ install tensorflow, tflite, onnx ================${NC}"
pip install tensorflow==2.13.1
pip install onnx==1.15.0 onnxruntime==1.16.3 onnxsim==0.4.33
pip install -U --force-reinstall flatbuffers==23.5.26
pip install tflite-runtime==2.14.0

echo -e "${HL}================ install pycoral ================${NC}"
# https://github.com/JungLearnBot/RPi5_yolov8/blob/main/Readme.RPi5.coral_tpu.picam.qt.md
wget https://github.com/oberluz/pycoral/releases/download/2.13.0/pycoral-2.13.0-cp311-cp311-linux_aarch64.whl
pip install pycoral-2.13.0-cp311-cp311-linux_aarch64.whl --no-deps
rm pycoral-2.13.0-cp311-cp311-linux_aarch64.whl

echo -e "${HL}================ test yolo prediction on bus image (4 persons, 1 bus, 1 stop sign) ================${NC}"
# Test run to check correct detection of 4 persons, 1 bus, 1 stop sign on this image
yolo predict model=yolov8n.pt source='https://ultralytics.com/images/bus.jpg'

echo -e "${HL}================ install libedgetpu1-std ================${NC}"
# https://docs.ultralytics.com/guides/coral-edge-tpu-on-raspberry-pi/
wget https://github.com/feranick/libedgetpu/releases/download/16.0TF2.16.1-1/libedgetpu1-std_16.0tf2.16.1-1.bookworm_arm64.deb
sudo dpkg -i libedgetpu1-std_16.0tf2.16.1-1.bookworm_arm64.deb
rm libedgetpu1-std_16.0tf2.16.1-1.bookworm_arm64.deb

echo -e "${HL}================ install libedgetpu-dev ================${NC}"
wget https://github.com/feranick/libedgetpu/releases/download/16.0TF2.16.1-1/libedgetpu-dev_16.0tf2.16.1-1.bookworm_arm64.deb
sudo dpkg -i libedgetpu-dev_16.0tf2.16.1-1.bookworm_arm64.deb
rm libedgetpu-dev_16.0tf2.16.1-1.bookworm_arm64.deb

echo -e "${HL}================ exporting yolov8n model to edge tpu ================${NC}"
# export *.pt to different *.tflite, the export here fails at the end with, but true continues script
#yolo export model=yolov8n.pt format=edgetpu || true
cd yolov8n_saved_model/
echo -e "${HL}================ downloading yolov8n_full_integer_quant_edgetpu ================${NC}"
#wget https://github.com/StefansAI/Yolov8_Rpi5_CoralUSB/raw/main/edgetpu/yolov8n_full_integer_quant_edgetpu.tflite
cd $HOME

echo -e "${HL}================ garden camera examples ================${NC}"
read -p "Do you want to download and run the examples? (y/n):" response
echo 
if  [[ $response =~ ^[yY]$ ]];
then
	echo -e "${HL}================ downloading the examples ================${NC}"
	# download the sample models and videos
	cd $HOME
	wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam640.pt
	wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam640.mp4
	wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam320.pt
	wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam320.mp4
	wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam224.pt
	wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam224.mp4

	echo -e "${HL}================ exporting GardenCam640 model to edge tpu ================${NC}"
	# export *.pt to different *.tflite, the export here fails at the end with, but true continues script
	yolo export model=GardenCam640.pt format=edgetpu imgsz=640 || true

	echo -e "${HL}================ downloading GardenCam640_full_integer_quant_edgetpu ================${NC}"
	# the export creates tflite-files for cpu test, to run tflite on tpu get the model with "_edgetpu.tflite"
	cd GardenCam640_saved_model/
	wget https://github.com/StefansAI/Yolov8_Rpi5_CoralUSB/raw/main/edgetpu/GardenCam640_full_integer_quant_edgetpu.tflite
	cd $HOME

	echo -e "${HL}================ exporting GardenCam320 model to edge tpu ================${NC}"
	# export *.pt to different *.tflite, the export here fails at the end with, but true continues script
	yolo export model=GardenCam320.pt format=edgetpu imgsz=320 || true

	echo -e "${HL}================ downloading GardenCam320_full_integer_quant_edgetpu ================${NC}"
	# the export creates tflite-files for cpu test, to run tflite on tpu get the model with "_edgetpu.tflite"
	cd GardenCam320_saved_model/
	wget https://github.com/StefansAI/Yolov8_Rpi5_CoralUSB/raw/main/edgetpu/GardenCam320_full_integer_quant_edgetpu.tflite
	cd $HOME

	echo -e "${HL}================ exporting GardenCam224 model to edge tpu ================${NC}"
	# export *.pt to different *.tflite, the export here fails at the end with, but true continues script
	yolo export model=GardenCam224.pt format=edgetpu imgsz=224 || true

	echo -e "${HL}================ downloading GardenCam224_full_integer_quant_edgetpu ================${NC}"
	# the export creates tflite-files for cpu test, to run tflite on tpu get the model with "_edgetpu.tflite"
	cd GardenCam224_saved_model/
	wget https://github.com/StefansAI/Yolov8_Rpi5_CoralUSB/raw/main/edgetpu/GardenCam224_full_integer_quant_edgetpu.tflite
	cd $HOME

	# run all combinations
	mkdir runs
	echo -e "${HL}================ Running GardenCam640.pt predictions to collect inference times.  ================${NC}"  
	timeout 60s yolo detect predict model=GardenCam640.pt source=GardenCam640.mp4 imgsz=640 show=True > runs/run_640_pt_cpu.txt

	echo -e "${HL}================ Running GardenCam320.pt predictions to collect inference times.  ================${NC}"  
	timeout 45s yolo detect predict model=GardenCam320.pt source=GardenCam320.mp4 imgsz=320 show=True > runs/run_320_pt_cpu.txt

	echo -e "${HL}================ Running GardenCam224.pt predictions to collect inference times.  ================${NC}"  
	timeout 30s yolo detect predict model=GardenCam224.pt source=GardenCam224.mp4 imgsz=224 show=True > runs/run_224_pt_cpu.txt


	echo -e "${HL}================ Running GardenCam640_full_integer_quant.tflite predictions to collect inference times.  ================${NC}"  
	timeout 60s yolo detect predict model=GardenCam640_saved_model/GardenCam640_full_integer_quant.tflite data=GardenCam640_saved_model/metadata.yaml source=GardenCam640.mp4 imgsz=640 show=True > runs/run_640_full_integer_quant_cpu.txt

	echo -e "${HL}================ Running GardenCam640_full_integer_quant_edgetpu.tflite predictions to collect inference times.  ================${NC}"  
	timeout 60s yolo detect predict model=GardenCam640_saved_model/GardenCam640_full_integer_quant_edgetpu.tflite data=GardenCam640_saved_model/metadata.yaml source=GardenCam640.mp4 imgsz=640 show=True > runs/run_640_full_integer_quant_tpu.txt


	echo -e "${HL}================ Running GardenCam320_full_integer_quant.tflite predictions to collect inference times.  ================${NC}"  
	timeout 45s yolo detect predict model=GardenCam320_saved_model/GardenCam320_full_integer_quant.tflite data=GardenCam320_saved_model/metadata.yaml source=GardenCam320.mp4 imgsz=320 show=True > runs/run_320_full_integer_quant_cpu.txt

	echo -e "${HL}================ Running GardenCam320_full_integer_quant_edgetpu.tflite predictions to collect inference times.  ================${NC}"  
	timeout 30s yolo detect predict model=GardenCam320_saved_model/GardenCam320_full_integer_quant_edgetpu.tflite data=GardenCam320_saved_model/metadata.yaml source=GardenCam320.mp4 imgsz=320 show=True > runs/run_320_full_integer_quant_tpu.txt

	echo -e "${HL}================ Running GardenCam224_full_integer_quant.tflite predictions to collect inference times.  ================${NC}"  
	timeout 45s yolo detect predict model=GardenCam224_saved_model/GardenCam224_full_integer_quant.tflite data=GardenCam224_saved_model/metadata.yaml source=GardenCam224.mp4 imgsz=224 show=True > runs/run_224_full_integer_quant_cpu.txt

	echo -e "${HL}================ Running GardenCam224_full_integer_quant_edgetpu.tflite predictions to collect inference times.  ================${NC}"  
	timeout 30s yolo detect predict model=GardenCam224_saved_model/GardenCam224_full_integer_quant_edgetpu.tflite data=GardenCam224_saved_model/metadata.yaml source=GardenCam224.mp4 imgsz=224 show=True > runs/run_224_full_integer_quant_tpu.txt

	# download average python script run averages over the output files
	echo -e "${HL}================ averaging all runs and display times ================${NC}"
	cd runs
	wget https://github.com/StefansAI/Yolov8_Rpi5_CoralUSB/raw/main/scripts/average.py
	python average.py
	cd $HOME
fi

echo
echo -e "${HL}================ All Done ================${NC}"
echo

