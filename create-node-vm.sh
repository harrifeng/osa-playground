#!/bin/bash
# DEFAULTS
DISK_SIZE="10"
MEMORY="2048"
OS_TYPE="Ubuntu"
STORAGE="50"
ISO="/home/$USER/ISOs/ubuntu-14.04.2-server-amd64.iso"
NETWORK="vboxnet0"

for i in "$@"
do
case $i in
    -n=*|--name=*)
    NAME="${i#*=}"
    HOME_DIR="/home/${USER}/VirtualBox\ VMs/${NAME}"
    shift # past argument=value
    ;;
    -d=*|--disk=*)
    DISK_SIZE="${i#*=}"
    shift # past argument=value
    ;;
    -m=*|--memory=*)
    MEMORY="${i#*=}"
    shift # past argument=value
    ;;
    -o=*|--os=*)
    OS_TYPE="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--storage=*)
    STORAGE="${i#*=}"
    shift # past argument=value
    ;;
    -n=*|--network=*)
    NETWORK="${i#*=}"
    shift # past argument=value
    ;;
    -i=*|--iso=*)
    ISO="${i#*=}"
    shift # past argument=value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
            # unknown option
    ;;
esac
done
if [[ ! -z "$NAME" ]]
then
    echo "VM name = ${NAME}"
    echo "VM disk size = ${DISK_SIZE} GB"
    echo "VM storage disk size = ${STORAGE} GB"
    echo "VM memory = ${MEMORY} MB"
    echo "VM Host Only Network = ${NETWORK}"
    echo "VM location = ${HOME_DIR}/${NAME}.vbox"
    VBoxManage createvm --name ${NAME} --register
    VBoxManage createhd --filename "${HOME_DIR}/${NAME}.vdi" --size $(( DISK_SIZE * 1024 ))
    VBoxManage createhd --filename "${HOME_DIR}/${NAME}_data.vdi" --size $(( STORAGE * 1024 ))
    VBoxManage modifyvm ${NAME} --ostype ${OS_TYPE}
    VBoxManage modifyvm ${NAME} --memory ${MEMORY} --vram 128
    VBoxManage storagectl ${NAME} --name "SATA Controller" --add sata --controller IntelAHCI
    VBoxManage storageattach ${NAME} --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${HOME_DIR}/${NAME}.vdi"
    VBoxManage storageattach ${NAME} --storagectl "SATA Controller" --port 1 --device 0 --type hdd --medium "${HOME_DIR}/${NAME}_data.vdi"
    VBoxManage storagectl ${NAME} --name "IDE Controller" --add ide
    VBoxManage storageattach ${NAME} --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium ${ISO}
    VBoxManage modifyvm ${NAME} --boot1 disk --boot2 dvd --boot3 none --boot4 none
    VBoxManage modifyvm ${NAME} --nic1 nat --nictype1 82545EM --cableconnected1 on
    VBoxManage modifyvm ${NAME} --nic2 hostonly --nictype2 82545EM --hostonlyadapter2 ${NETWORK} --cableconnected2 on
else
    echo "--name parameter is required."
fi
