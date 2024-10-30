#!/bin/bash
set -x

echo "---------------------------------------"
echo "Starting SSH Ramdisk Tool"
echo "Kernel Version: $(uname -a)"
echo "---------------------------------------"
echo
echo "RAMDISK SETUP: STARTING" > /dev/console

echo "Cleaning up /dev"
rm /dev/pty* || true
rm /dev/tty?? || true

# remount r/w
echo "RAMDISK SETUP: REMOUNTING ROOTFS" > /dev/console
mount -o rw,union,update /


# Start SSHD
echo "RAMDISK SETUP: STARTING SSHD" > /dev/console
/sbin/sshd
/usr/local/bin/dropbear -i --shell /bin/bash -r /etc/dropbear/id_rsa

echo "RAMDISK SETUP: WAITING 5S" > /dev/console
sleep 5

# Run restored_external
echo "RAMDISK SETUP: STARTING UI" > /dev/console
sleep 1
if [ -e "/usr/local/bin/restored_update.real" ]; then
  echo "Running in Update Ramdisk!"
  exec /usr/local/bin/restored_update.real -server
else
  exec /usr/local/bin/restored_external.real -server
fi
