#!/bin/bash

# =======================
# Colors
# =======================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# =======================
# ASCII Logo
# =======================
print_logo() {
    echo -e "${CYAN}"
    echo " _______  _______                    _______  _        _       "
    echo "(  ___  )(  ____ \\|\\     /||\\     /|(  ___  )( (    /|| \\    /\\ "
    echo "| (   ) || (    \\/| )   ( || )   ( || (   ) ||  \\  ( ||  \\  / / "
    echo "| |   | || (_____ | (___) || |   | || (___) ||   \\ | ||  (_/ /  "
    echo "| |   | |(_____  )|  ___  |( (   ) )|  ___  || (\\ \\) ||   _ (   "
    echo "| |   | |      ) || (   ) | \\ \\_/ / | (   ) || | \\   ||  ( \\ \\  "
    echo "| (___) |/\\____) || )   ( |  \\   /  | )   ( || )  \\  ||  /  \\ \\ "
    echo "(_______)\\_______)|/     \\|   \\_/   |/     \\||/    )_)|_/    \\_\\"
    echo -e "${NC}"
    echo
    echo -e "${YELLOW}============================================================${NC}"
    echo -e "${WHITE}         LumeraNetwork Setup Script${NC}"
    echo -e "${WHITE}              Prepared by: OshVanK${NC}"
    echo -e "${WHITE}              Version: v1.9.0${NC}"
    echo -e "${YELLOW}============================================================${NC}"
    echo
}

# =======================
# Language Select
# =======================
select_language() {
    clear
    print_logo
    echo -e "${CYAN}Select Language / Dil Seçin:${NC}"
    echo -e "${WHITE}1)${NC} English"
    echo -e "${WHITE}2)${NC} Türkçe"
    echo
    read -p "$(echo -e ${YELLOW}"Enter your choice / Seçiminizi yapın [1-2]: "${NC})" lang_choice
    case $lang_choice in
        2) LANG="TR" ;;
        *) LANG="EN" ;;
    esac
}

# =======================
# Texts
# =======================
get_text() {
    case $1 in
        main_menu) [ "$LANG" = "TR" ] && echo "ANA MENÜ" || echo "MAIN MENU" ;;
        install) [ "$LANG" = "TR" ] && echo "Kurulum Yap" || echo "Install Node" ;;
        check_sync) [ "$LANG" = "TR" ] && echo "Sync Durumu" || echo "Check Sync Status" ;;
        view_logs) [ "$LANG" = "TR" ] && echo "Logları Görüntüle" || echo "View Logs" ;;
        create_wallet) [ "$LANG" = "TR" ] && echo "Cüzdan Oluştur" || echo "Create Wallet" ;;
        import_wallet) [ "$LANG" = "TR" ] && echo "Cüzdan İçe Aktar" || echo "Import Wallet" ;;
        create_validator) [ "$LANG" = "TR" ] && echo "Validator Oluştur" || echo "Create Validator" ;;
        delegate) [ "$LANG" = "TR" ] && echo "Token Delege Et" || echo "Delegate Tokens" ;;
        send_tokens) [ "$LANG" = "TR" ] && echo "Token Gönder" || echo "Send Tokens" ;;
        check_balance) [ "$LANG" = "TR" ] && echo "Bakiye Kontrol" || echo "Check Balance" ;;
        node_management) [ "$LANG" = "TR" ] && echo "Node Yönetimi" || echo "Node Management" ;;
        exit) [ "$LANG" = "TR" ] && echo "Çıkış" || echo "Exit" ;;
        press_enter) [ "$LANG" = "TR" ] && echo "Devam etmek için Enter'a basın..." || echo "Press Enter to continue..." ;;
    esac
}

# =======================
# Dependencies
# =======================
install_dependencies() {
    sudo apt update
    sudo apt install -y git curl make jq gcc snapd chrony lz4 tmux unzip bc
}

# =======================
# Go Install
# =======================
install_go() {
    GO_VERSION="1.23.5"
    if go version &>/dev/null; then
        return
    fi
    cd $HOME
    wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
    rm go${GO_VERSION}.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bash_profile
    source ~/.bash_profile
}

# =======================
# Install Node (v1.9.0)
# =======================
install_node() {
    clear
    print_logo

    read -p "Node name (moniker): " MONIKER
    read -p "Port prefix (default 10): " CUSTOM_PORT
    CUSTOM_PORT=${CUSTOM_PORT:-10}

    install_dependencies
    install_go

    echo -e "${BLUE}Downloading Lumera v1.9.0...${NC}"
    cd $HOME
    wget https://github.com/LumeraProtocol/lumera/releases/download/v1.9.0/lumera_v1.9.0_linux_amd64.tar.gz
    tar -xvf lumera_v1.9.0_linux_amd64.tar.gz
    rm lumera_v1.9.0_linux_amd64.tar.gz
    sudo mv libwasmvm.x86_64.so /usr/lib/
    chmod +x lumerad
    mv lumerad $HOME/go/bin/

    go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest

    mkdir -p ~/.lumera/cosmovisor/genesis/bin
    cp ~/go/bin/lumerad ~/.lumera/cosmovisor/genesis/bin/

    lumerad init "$MONIKER" --chain-id lumera-mainnet-1

    curl -Ls https://ss.lumera.nodestake.org/genesis.json > ~/.lumera/config/genesis.json
    curl -Ls https://ss.lumera.nodestake.org/addrbook.json > ~/.lumera/config/addrbook.json

    sudo tee /etc/systemd/system/lumerad.service >/dev/null <<EOF
[Unit]
Description=Lumera Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=always
RestartSec=3
LimitNOFILE=65535
Environment=DAEMON_NAME=lumerad
Environment=DAEMON_HOME=$HOME/.lumera
Environment=DAEMON_ALLOW_DOWNLOAD_BINARIES=false
Environment=DAEMON_RESTART_AFTER_UPGRADE=true
Environment=UNSAFE_SKIP_BACKUP=true

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable lumerad

    SNAP=$(curl -s https://ss.lumera.nodestake.org/ | grep -o "20.*\.tar.lz4" | head -n1)
    curl -L https://ss.lumera.nodestake.org/$SNAP | lz4 -dc | tar -xf - -C ~/.lumera

    sudo systemctl restart lumerad

    echo -e "${GREEN}Lumera v1.9.0 node installed successfully!${NC}"
    read -p "$(get_text press_enter)"
}

# =======================
# Main Menu
# =======================
main_menu() {
    while true; do
        clear
        print_logo
        echo "1) $(get_text install)"
        echo "0) $(get_text exit)"
        read -p "Choice: " c
        case $c in
            1) install_node ;;
            0) exit 0 ;;
        esac
    done
}

# =======================
# Start
# =======================
select_language
main_menu
