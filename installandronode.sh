#!/bin/bash

# START COMMAND
# curl https://raw.githubusercontent.com/ricardoreis/andronode/main/installandronode.sh | bash

TARGET_DIR=$HOME/andronode

# Upgrade Termux Packages 
pkg upgrade -y

# Instal Termux Packages 
pkg install termux-services -y
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
EOF
    chmod +x $TARGET_DIR/sshsetup.sh

    echo "\nsshsetup.sh has been created."
    
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
    
    echo "\nsshcommand.sh has been created."
}


install_andronode(){
    create_target_dir
    create_ssh_setup
    create_ssh_command
    
}
install_andronode
# Create config.json
