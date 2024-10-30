# This file is part of the 64-bit ramdisk tool by meowcat454
echo "Backing up activation files from device..."
echo "To use this script, the device must have the ramdisk loaded and have the data partition (/mnt2) mounted."

sleep 1


[ -d activation ] || mkdir activation

echo "Backing up IC-Info.sisv..."
scp -P 2222 root@localhost:/mnt2/mobile/Library/FairPlay/iTunes_Control/iTunes/IC-Info.sisv activation/

echo "Backing up activation_record.plist..."
scp -P 2222 root@localhost:/mnt2/containers/Data/System/*/Library/activation_records/activation_record.plist activation/

echo "Backing up data_ark.plist..."
scp -P 2222 root@localhost:/mnt2/containers/Data/System/*/Library/internal/data_ark.plist activation/

echo "Backing up com.apple.commcenter.device_specific_nobackup.plist..."
scp -P 2222 root@localhost:/mnt2/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist activation/

if [ -f "activation/IC-Info.sisv" ] && [ -f "activation/activation_record.plist" ] && [ -f "activation/data_ark.plist" ] && [ -f "activation/com.apple.commcenter.device_specific_nobackup.plist" ]; then
  echo "All files were backed up!"
else
  echo "There was an error backing up one or more files!"
fi
