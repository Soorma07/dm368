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
 # apt-get install clojure jetty groovy fakeroot
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

 $ export ${HOME}/ti-dvsdk_dm368-evm_4_02_00_06
 $ echo "export ${HOME}/ti-dvsdk_dm368-evm_4_02_00_06" >> ~/.bashrc

And build the code and write the SD card::

 $ cd ${DVSDK}
 $ ./setup.sh
 Accept all defaults except the last one, do not go into minicom.
 $ make clean components
 $ sudo ${DVSDK}/bin/mksdboot.sh --device /dev/sdX --sdk ${DVSDK}

where /dev/sdX is the SD card. You should be able to use the SD card now to
boot the board, and any changes like the helloworld.c example should
theoretically work.

Making a custom SD card
-----------------------

So I did all that and made an SD card and it booted. But it used a standard
disk image, and I need to figure out how I'm going to add something to that
disk image. That is the purpose of the hackrootfs.sh script, which populates
/home/root with a shell script and a compiled C program. Both work fine. You
need to telnet into the EVM over the local subnet and login as root.
