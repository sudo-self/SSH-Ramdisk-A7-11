#!/bin/bash
set -e

echo "64-bit Ramdisk Loader (fsboot) v0.18 by meowcat454"
echo "--------------------------------------------------"

usage() {
echo "Usage: fsboot.sh [devicetype]"
echo "  devicetype: specify device model"
echo "Examples: "
echo "'bash fsboot.sh iPhone9,2'"
}

if [ -z "$1" ]; then
  usage
  exit
fi

device=$1
dirprefix=bootchain

if ! [ -d "$dirprefix-$device" ]; then
echo "Bootchain folder not found, run 'create.sh [devicetype] [version] -b' to create one."
exit 1
fi

cd $dirprefix-$device

if ! [ -e iBoot.img4 ]; then
  if ! [ -f iBSS.img4 ]; then echo "ERROR: iBSS not found!"; exit 1; fi
  if ! [ -f iBEC.img4 ]; then echo "ERROR: iBEC not found!"; exit 1; fi
fi
if ! [ -f bootlogo.img4 ]; then echo "ERROR: Boot logo not found!"; exit 1; fi

if [ -e iBoot.img4 ]; then # A10/A11 device
  echo "Sending iBoot..."
  ../resources/bin/irecovery -f iBoot.img4
  sleep 2
  ../resources/bin/irecovery -f iBoot.img4
else
  echo "Sending iBSS..."
  ../resources/bin/irecovery -f iBSS.img4
  sleep 2
  ../resources/bin/irecovery -f iBSS.img4

  sleep 2
  echo "Sending iBEC..."
  ../resources/bin/irecovery -f iBEC.img4
fi

sleep 3
../resources/bin/irecovery -c "bgcolor 11 45 113"
echo "Sending logo..."
../resources/bin/irecovery -f bootlogo.img4
../resources/bin/irecovery -c "setpicture 5"

echo "Booting device now..."
../resources/bin/irecovery -c fsboot

echo "Finished! If all the progress bars are 100%, you should see a verbose boot then the apple logo."

cd ..
