# install YOLOv8
# https://docs.ultralytics.com/guides/raspberry-pi/
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y

sudo apt-get install libhdf5-dev

#https://github.com/JungLearnBot/RPi5_yolov8/blob/main/Readme.RPi5.coral_tpu.picam.qt.md
sudo apt-get install cmake 

python3 -m venv yolo_env
source yolo_env/bin/activate
echo 'source yolo_env/bin/activate' >> ~/.bashrc 
pip install h5py
pip install ultralytics==8.0.221
pip install tensorflow==2.13.1
pip install onnx==1.15.0 onnxruntime==1.16.3 onnxsim==0.4.33
pip install -U --force-reinstall flatbuffers==23.5.26
pip install tflite-runtime==2.14.0

# https://github.com/JungLearnBot/RPi5_yolov8/blob/main/Readme.RPi5.coral_tpu.picam.qt.md
wget https://github.com/oberluz/pycoral/releases/download/2.13.0/pycoral-2.13.0-cp311-cp311-linux_aarch64.whl
pip install pycoral-2.13.0-cp311-cp311-linux_aarch64.whl --no-deps
rm pycoral-2.13.0-cp311-cp311-linux_aarch64.whl

# Test run to check correct detection of 4 persons, 1 bus, 1 stop sign on this image
yolo predict model=yolov8n.pt source='https://ultralytics.com/images/bus.jpg'

# https://docs.ultralytics.com/guides/coral-edge-tpu-on-raspberry-pi/
wget https://github.com/feranick/libedgetpu/releases/download/16.0TF2.16.1-1/libedgetpu1-std_16.0tf2.16.1-1.bookworm_arm64.deb
sudo dpkg -i libedgetpu1-std_16.0tf2.16.1-1.bookworm_arm64.deb
rm libedgetpu1-std_16.0tf2.16.1-1.bookworm_arm64.deb

wget https://github.com/feranick/libedgetpu/releases/download/16.0TF2.16.1-1/libedgetpu-dev_16.0tf2.16.1-1.bookworm_arm64.deb
sudo dpkg -i libedgetpu-dev_16.0tf2.16.1-1.bookworm_arm64.deb
rm libedgetpu-dev_16.0tf2.16.1-1.bookworm_arm64.deb

# export *.pt to different *.tflite, the export here fails at the end with, but true continues script
yolo export model=yolov8n.pt format=edgetpu || true

# the export creates tflite-files for cpu test, to run tflite on tpu the name must contain "_edgetpu.tflite"
cd yolov8n_saved_model
cp yolov8n_int8.tflite yolov8n_int8_edgetpu.tflite
cp yolov8n_integer_quant.tflite yolov8n_integer_quant_edgetpu.tflite
cp yolov8n_full_integer_quant.tflite yolov8n_full_integer_quant_edgetpu.tflite
cp yolov8n_float16.tflite yolov8n_float16_edgetpu.tflite
cp yolov8n_float32.tflite yolov8n_float32_edgetpu.tflite

# download the sample models and videos
cd $HOME
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam640.pt
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam640.mp4
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam320.pt
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam320.mp4
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam224.pt
wget https://github.com/StefansAI/Custom_Yolov8/raw/main/example/GardenCam224.mp4

# export *.pt to different *.tflite, the export here fails at the end with, but true continues script
yolo export model=GardenCam640.pt format=edgetpu imgsz=640 || true

# the export creates tflite-files for cpu test, to run tflite on tpu the name must contain "_edgetpu.tflite"
cd GardenCam640_saved_model/
cp GardenCam640_int8.tflite GardenCam640_int8_edgetpu.tflite
cp GardenCam640_integer_quant.tflite GardenCam640_integer_quant_edgetpu.tflite
cp GardenCam640_full_integer_quant.tflite GardenCam640_full_integer_quant_edgetpu.tflite
cp GardenCam640_float16.tflite GardenCam640_float16_edgetpu.tflite
cp GardenCam640_float32.tflite GardenCam640_float32_edgetpu.tflite
cd $HOME

# export *.pt to different *.tflite, the export here fails at the end with, but true continues script
yolo export model=GardenCam320.pt format=edgetpu imgsz=320 || true

# the export creates tflite-files for cpu test, to run tflite on tpu the name must contain "_edgetpu.tflite"
cd GardenCam320_saved_model/
cp GardenCam320_int8.tflite GardenCam320_int8_edgetpu.tflite
cp GardenCam320_integer_quant.tflite GardenCam320_integer_quant_edgetpu.tflite
cp GardenCam320_full_integer_quant.tflite GardenCam320_full_integer_quant_edgetpu.tflite
cp GardenCam320_float16.tflite GardenCam320_float16_edgetpu.tflite
cp GardenCam320_float32.tflite GardenCam320_float32_edgetpu.tflite
cd $HOME

# export *.pt to different *.tflite, the export here fails at the end with, but true continues script
yolo export model=GardenCam224.pt format=edgetpu imgsz=224 || true

# the export creates tflite-files for cpu test, to run tflite on tpu the name must contain "_edgetpu.tflite"
cd GardenCam224_saved_model/
cp GardenCam224_int8.tflite GardenCam224_int8_edgetpu.tflite
cp GardenCam224_integer_quant.tflite GardenCam224_integer_quant_edgetpu.tflite
cp GardenCam224_full_integer_quant.tflite GardenCam224_full_integer_quant_edgetpu.tflite
cp GardenCam224_float16.tflite GardenCam224_float16_edgetpu.tflite
cp GardenCam224_float32.tflite GardenCam224_float32_edgetpu.tflite
cd $HOME

# run all combinations
timeout 60s yolo detect predict model=GardenCam640.pt source=GardenCam640.mp4 imgsz=640 show=True > run_640_pt_cpu.txt
timeout 45s yolo detect predict model=GardenCam320.pt source=GardenCam320.mp4 imgsz=320 show=True > run_320_pt_cpu.txt
timeout 30s yolo detect predict model=GardenCam224.pt source=GardenCam224.mp4 imgsz=224 show=True > run_224_pt_cpu.txt

timeout 60s yolo detect predict model=GardenCam640_saved_model/GardenCam640_int8.tflite data=GardenCam640_saved_model/metadata.yaml source=GardenCam640.mp4 imgsz=640 show=True > run_640_int8_cpu.txt
timeout 60s yolo detect predict model=GardenCam640_saved_model/GardenCam640_int8_edgetpu.tflite data=GardenCam640_saved_model/metadata.yaml source=GardenCam640.mp4 imgsz=640 show=True > run_640_int8_tpu.txt

timeout 45s yolo detect predict model=GardenCam320_saved_model/GardenCam320_int8.tflite data=GardenCam320_saved_model/metadata.yaml source=GardenCam320.mp4 imgsz=320 show=True > run_320_int8_cpu.txt
timeout 30s yolo detect predict model=GardenCam320_saved_model/GardenCam320_int8_edgetpu.tflite data=GardenCam320_saved_model/metadata.yaml source=GardenCam320.mp4 imgsz=320 show=True > run_320_int8_tpu.txt

timeout 45s yolo detect predict model=GardenCam224_saved_model/GardenCam224_int8.tflite data=GardenCam224_saved_model/metadata.yaml source=GardenCam224.mp4 imgsz=224 show=True > run_224_int8_cpu.txt
timeout 30s yolo detect predict model=GardenCam224_saved_model/GardenCam224_int8_edgetpu.tflite data=GardenCam224_saved_model/metadata.yaml source=GardenCam224.mp4 imgsz=224 show=True > run_224_int8_tpu.txt

# download average python script run averages over the output files
wget https://github.com/StefansAI/Yolov8_Rpi5_CoralUSB/raw/main/scripts/average.py
python average.py


