# Yolov8_Rpi5_CoralUSB
Install and Test of Yolov8 on Raspberry Pi5 with USB Coral TPU

<br>
<div style="text-align: center;">
  <img src="images/Pi5.jpg" />
</div>
<br>

<br>
To just install yolov8 on Raspberry Pi5 simply type:

```shell
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y
python3 -m venv yolo_env
source yolo_env/bin/activate
pip3 install ultralytics
```
<br>
============================================================================
<br>

<br>
<div style="text-align: center;">
  <img src="images/Pi5_Coral_tpu.jpg" />
</div>
<br>

<br>
To install yolov8 plus USB Coral TPU, download an run the script:

```shell
wget https://raw.githubusercontent.com/StefansAI/Yolov8_Rpi5_CoralUSB/main/scripts/yolov8_coral_install.sh
chmod +x yolov8_coral_install.sh
./yolov8_coral_install.sh
```

<br>
Note:<br>
The script contains the line for yolo export, which fails here for some reason. This export function however works in Colab and the export results from Colab are made available in the "tflite" folder of the repository. Those exports are made for 640x480. The script downloads these and make them available on the RPi.

<br>
<br>
At the end of the script, the GardenCam video and the GardenCam model is downloaded to demo the installation.

<br>
<div style="text-align: center;">
  <img src="images/crows_and_squirrel.jpg" />
</div>
<br>
