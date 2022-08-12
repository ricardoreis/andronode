#!/bin/bash

# START COMMAND
# curl https://raw.githubusercontent.com/ricardoreis/andronode/main/installandronode.sh | bash

TARGET_DIR=$HOME/andronode

ANDRONODE_VERSION="v.0.2"

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

upgrade_termux(){
    print_warning "\nUPDATING TERMUX PACKAGES \n"
    termux-setup-storage
    yes | pkg upgrade
    # Instal Termux Packages 
    #pkg install termux-services -y
    yes | pkg install bitcoin
    yes | pkg install nodejs
    yes | pkg install git
}

create_blockchain_folder() {
    mkdir -p $TARGET_DIR/blockchain
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

install_node_modules(){
    cd $TARGET_DIR/web
    npm install ip
    npm install shelljs    
}

git_clone(){
    print_warning "\nINSTALLING ANDRONODE $ANDRONODE_VERSION \n"
    cd $HOME
    rm -rf $TARGET_DIR
    if [ -d "$TARGET_DIR" ] 
    then
        print_error "\nINSTALLATION FAILED.\N"
        exit 0
    fi  
    git clone https://github.com/ricardoreis/andronode.git
    chmod +x $TARGET_DIR/*.sh
}

start_bitcoin(){
    print_warning "\nANDRONODE $ANDRONODE_VERSION STARTING...\n"
    $HOME/andronode/start.sh
}

start_webserver(){
    node $TARGET_DIR/web/webserver.js
}


install_andronode(){
    upgrade_termux
    git_clone
    create_blockchain_folder
    install_node_modules
    print_success "\nSUCCESS, ANDRONODE INSTALLED.\n" 
}

install_andronode && start_bitcoin && start_webserver
# Create config.json
