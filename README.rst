Working with the DM368 DVSDK
============================

These are the files I used, with their md5sums::

 3392125b749eed6f794dcd0ee2e1afe2  TMS320DM368_EVM_Quick_Start_Guide.pdf
 dc59348a3d961d1afe3ebc94863ba382  TMS320DM368_Software_Developers_Guide.pdf
 7609667a522edf8e01c0e197f9cceffa  dvsdk_dm368-evm_4_02_00_06_setuplinux.bin
 557231ce93ae8e98e214424cb02f8761  ubuntu-10.04.4-desktop-i386.iso
 c8833da1cde15cb77e76635139256fb2  arm-2009q1-203-arm-none-linux-gnueabi.bin

Finally got the laptop set up to build the stupid DVSDK. Here is the process.
First install the 32-bit (NOT the 64-bit version) of Ubuntu 10.04. Do not get
any software updates::

 $ sudo su -
 # apt-get update
 # apt-get install openjdk-6-jdk fakeroot git-core gitk
 # cd /bin
 # rm sh
 # ln -s bash sh
 # exit
 $ cd ~

Next install the cross-compile toolchain and the DVSDK::

 $ cp ....../arm-2009q1-203-arm-none-linux-gnueabi.bin .
 $ cp ....../dvsdk_dm368-evm_4_02_00_06_setuplinux.bin .
 $ chmod +x *.bin
 $ ./arm-2009q1-203-arm-none-linux-gnueabi.bin
 $ ./dvsdk_dm368-evm_4_02_00_06_setuplinux.bin
 Accept all defaults.
 $ rm *.bin

Finally set up the environment::

 $ export DVSDK=${HOME}/ti-dvsdk_dm368-evm_4_02_00_06
 $ echo "export DVSDK=${HOME}/ti-dvsdk_dm368-evm_4_02_00_06" >> ~/.bashrc

And build the code and write the SD card::

 $ cd ${DVSDK}
 $ ./setup.sh
 Accept all defaults except the last one, do not go into minicom. That question
 asks "Would you like to run the setup script now (y/n)?"
 $ make clean components
 $ sudo ${DVSDK}/bin/mksdboot.sh --device /dev/sdX --sdk ${DVSDK}

where /dev/sdX is the SD card. You should be able to use the SD card now to
boot the board, and any changes like the helloworld.c example should
theoretically work.

Finding the Video Rosetta Stone
-------------------------------

Look at dvsdk-demos_4_02_00_01/dm365/encode/capture.c, line 369, where frames are
captured. Then look at line 353 where the CapBuf_blackFill function is called, and
around line 76 where it's defined. Note the use of the yPtr variable in this
function. Notice that this function knows how to handle different kinds of video
buffers with different encoding schemes. I believe THIS is the Rosetta stone that
is going to unlock the magic of video XY coordinates and video bit stuffing. BTW,
"CapBuf" means "capture buffer".

Mounting the DVSDK disk at bootup
---------------------------------

Cultural Learnings of http://www.tldp.org/HOWTO/HighQuality-Apps-HOWTO/boot.html
for Make Benefit Glorious Nation of DVSDK disk automounter. I wrote this file as
/etc/init.d/mountdvsdk, and then created a link to it at /etc/rc2.d/S32mountdvsdk.
The only magic there is that "32" is shortly after "30", where the vboxsf system
is enabled for runlevel 2.

::

 #!/bin/sh
 
 start() {
 	echo "Mounting DVSDK at /opt/DVSDK"
 	(cd /opt; mount -t vboxsf DVSDK DVSDK)
 	RETVAL=$?
 }
 
 stop() {
 	echo "Unmounting DVSDK"
 	(cd /opt; umount DVSDK)
 	RETVAL=$?
 }
 
 RETVAL=0
 case "$1" in
 	start)
 		start
 		;;
 	stop)
 		stop
 		;;
 	restart)
 		stop
 		start
 		;;
 	*)
 		echo Usage: $0 {start|stop}
 		RETVAL=1
 		;;
 esac
 exit $RETVAL

Making a custom SD card
-----------------------

So I did all that and made an SD card and it booted. But it used a standard
disk image, and I need to figure out how I'm going to add something to that
disk image. That is the purpose of the hackrootfs.sh script, which populates
/home/root with a shell script and a compiled C program. Both work fine. You
need to telnet into the EVM over the local subnet and login as root.
