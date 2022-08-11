#!/bin/bash

# START COMMAND
# curl https://raw.githubusercontent.com/ricardoreis/andronode/main/installandronode.sh | bash



TARGET_DIR=$HOME/andronode

ANDRONODE_VERSION="v.0.1"

BLUE='\033[94m'
GREEN='\033[32;1m'
YELLOW='\033[33;1m'
RED='\033[91;1m'
RESET='\033[0m'

print_info() {
    printf "$BLUE$1$RESET\n"
}
print_success() {
    printf "$GREEN$1$RESET\n"
    sleep 1
}
print_warning() {
    printf "$YELLOW$1$RESET\n"
}
print_error() {
    printf "$RED$1$RESET\n"
    sleep 1
}

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
sshd
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
    curl https://raw.githubusercontent.com/ricardoreis/andronode/main/start.sh  -o $HOME/andronode/start.sh && chmod +x $HOME/andronode/start.sh
    curl https://raw.githubusercontent.com/ricardoreis/andronode/main/stop.sh  -o $HOME/andronode/stop.sh && chmod +x $HOME/andronode/stop.sh
}

start_bitcoin(){
    print_warning "\nANDRONODE $ANDRONODE_VERSION STARTING...\n"
    $HOME/andronode/start.sh
}


install_andronode(){
    print_warning "\nINSTALLING ANDRONODE $ANDRONODE_VERSION \n"
    create_target_dir && create_config && create_ssh_setup && create_ssh_command && download_files
    print_success "\nSUCCESS, ANDRONODE INSTALLED.\n" 
}

install_andronode && start_bitcoin
# Create config.json
