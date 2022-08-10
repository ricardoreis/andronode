#!/bin/bash

# START COMMAND
# curl https://raw.githubusercontent.com/ricardoreis/andronode/main/installandronode.sh | bash

# https://bitcoincore.org/bin/bitcoin-core-23.0/bitcoin-23.0-arm-linux-gnueabihf.tar.gz

TARGET_DIR=$HOME/andronode

ARCH=$(uname -m)

if [ "$ARCH" != "aarch64"  ]; then
    echo ""
    echo "INSTALLATION FAILED."
    echo "--------------------"
    echo ""
    echo "Your OS Architecture is $ARCH."
    echo ""
    echo "Unfortunately Andronode only supports aarch64 OS Architecture."
    echo ""
    echo "Soon new architectures will be supported." 
    echo ""
    echo "Wait for the release of the next version of Andronode."
    echo ""
    exit 0
fi


# Upgrade Termux Packages
termux-setup-storage
pkg upgrade -y


# Instal Termux Packages 
#pkg install termux-services -y
pkg install bitcoin -y

# Termux Setup Storage


# Create Folders
create_target_dir() {
    rm -rf $TARGET_DIR 
    mkdir $TARGET_DIR
    mkdir $TARGET_DIR/webserver
}
 
# SSH
# Create SSH files
create_ssh_setup(){
    cat > $TARGET_DIR/sshsetup.sh <<'EOF'
#!/bin/sh
pkg install openssh -y
pkg install iproute2 -y
sshd
clear
echo ""
echo "Please create ssh Password"
echo "--------------------------"
passwd
./sshcommand.sh
EOF
    chmod +x $TARGET_DIR/sshsetup.sh

    printf "\nsshsetup.sh has been created."
    
}

create_ssh_command(){
    cat > $TARGET_DIR/sshcommand.sh <<'EOF'
#!/bin/bash
USER=$(whoami)
IP=$(ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1)
echo ""
echo "COMMAND:"
echo ""
echo "     ssh -p 8022 $USER@$IP"
echo ""
echo ""
EOF
    chmod +x $TARGET_DIR/sshcommand.sh
    
    printf "\nsshcommand.sh has been created."
}


install_andronode(){
    create_target_dir
    create_ssh_setup
    create_ssh_command
    
}
install_andronode
# Create config.json
