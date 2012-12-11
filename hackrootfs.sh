#!/bin/sh

DVSDK=${HOME}/ti-dvsdk_dm368-evm_4_02_00_06
ROOTFS=${DVSDK}/filesystem/dvsdk-dm368-evm-rootfs.tar.gz

sudo rm -rf tmp
mkdir tmp
(cd tmp; sudo tar xfz $ROOTFS)

DVSDK=${DVSDK} make helloworld
cp helloworld tmp/home/root

cat > tmp/home/root/helloworld.sh <<EOF
#!/bin/sh
echo "Hello world!"
EOF

chmod +x tmp/home/root/helloworld.sh
(cd tmp; sudo tar cfz ../rootfs.tgz *)

sudo ./mksdboot.sh --device /dev/mmcblk0 --sdk ${DVSDK} --rootfs rootfs.tgz 

DVSDK=${DVSDK} make clean
sudo rm -rf tmp rootfs.tgz
