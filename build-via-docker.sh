#!/bin/bash

VM=default
DOCKER_MACHINE=/usr/local/bin/docker-machine
VBOXMANAGE=/Applications/VirtualBox.app/Contents/MacOS/VBoxManage

unset DYLD_LIBRARY_PATH
unset LD_LIBRARY_PATH

clear

if [ ! -f $DOCKER_MACHINE ] || [ ! -f $VBOXMANAGE ]; then
  echo "Either VirtualBox or Docker Machine are not installed. Please re-run the Toolbox Installer and try again."
  exit 1
fi

$VBOXMANAGE showvminfo $VM &> /dev/null
VM_EXISTS_CODE=$?

if [ $VM_EXISTS_CODE -eq 1 ]; then
  echo "Creating Machine $VM..."
  $DOCKER_MACHINE rm -f $VM &> /dev/null
  rm -rf ~/.docker/machine/machines/$VM
  $DOCKER_MACHINE create -d virtualbox --virtualbox-memory 2048 $VM
else
  echo "Machine $VM already exists in VirtualBox."
fi

echo "Starting machine $VM..."
$DOCKER_MACHINE start $VM

echo "Setting environment variables for machine $VM..."
clear

cat << EOF


                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______/


EOF
echo -e "docker is configured to use the $VM machine with IP $($DOCKER_MACHINE ip $VM)"
echo "For help getting started, check out the docs at https://docs.docker.com"
echo

eval $($DOCKER_MACHINE env $VM --shell=bash)

USER_SHELL=$(dscl /Search -read /Users/$USER UserShell | awk '{print $2}')
if [ "$USER_SHELL" = "/bin/bash" ] || [ "$USER_SHELL" = "/bin/zsh" ] || [ "$USER_SHELL" = "/bin/sh" ]; then
  $USER_SHELL --login
else
  $USER_SHELL
fi

mv module.modulemap module.modulemap1
docker run --rm=true -v ${PWD}:${PWD} saltzmanjoelh/swiftubuntu /bin/bash -c "cd ${PWD} && swift build -Xcc -fblocks"
mv module.modulemap1 module.modulemap