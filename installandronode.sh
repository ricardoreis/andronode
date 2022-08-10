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
yes | pkg upgrade


# Instal Termux Packages 
#pkg install termux-services -y
yes | pkg install bitcoin

# Termux Setup Storage


# Create Folders
create_target_dir() {
    rm -rf $TARGET_DIR 
    mkdir $TARGET_DIR
    mkdir $TARGET_DIR/web
    mkdir $TARGET_DIR/blockchain
}
 
# SSH
# Create SSH files
create_ssh_setup(){
    cat > $TARGET_DIR/sshsetup.sh <<'EOF'
#!/bin/sh
yes | pkg install openssh
yes | pkg install iproute2
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


create_config(){
    cat > $TARGET_DIR/config.json <<EOF
{
    "datadir": "$TARGET_DIR/blockchain",
    "conf": "$TARGET_DIR/blockchain/bitcoin.conf"
}
EOF
    
    printf "\nconfig.json has been created."
}



download_files(){
    curl https://raw.githubusercontent.com/ricardoreis/andronode/main/start.sh  -o $HOME/andronode/start.sh
    chmod +x $HOME/andronode/start.sh
}

start_bitcoin(){
    $HOME/andronode/start.sh
}


install_andronode(){
    create_target_dir && create_config && create_ssh_setup && create_ssh_command && download_files 
}

install_andronode && start_bitcoin
# Create config.json
