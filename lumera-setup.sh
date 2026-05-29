#!/bin/bash

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ASCII Art
print_logo() {
    echo -e "${CYAN}"
    echo " _______  _______                    _______  _        _        "
    echo "(  ___  )(  ____ \|\     /||\     /|(  ___  )( (    /|| \    /\ "
    echo "| (   ) || (    \/| )   ( || )   ( || (   ) ||  \  ( ||  \  / / "
    echo "| |   | || (_____ | (___) || |   | || (___) ||   \ | ||   (_/ /  "
    echo "| |   | |(_____  )|  ___  |( (   ) )|  ___  || (\ \) ||   _ (   "
    echo "| |   | |      ) || (   ) | \ \_/ / | (   ) || | \   ||  ( \ \  "
    echo "| (___) |/\____) || )   ( |  \   /  | )   ( || )  \  ||  /  \ \ "
    echo "(_______)\_______)|/     \|   \_/   |/     \||/    )_)|_/    \_\\"
    echo -e "${NC}"
    echo
    echo -e "${YELLOW}============================================================${NC}"
    echo -e "${WHITE}         LumeraNetwork Setup Script${NC}"
    echo -e "${WHITE}             Prepared by: OshVanK${NC}"
    echo -e "${YELLOW}============================================================${NC}"
    echo
}

# Dil seçimi
select_language() {
    clear
    print_logo
    echo -e "${CYAN}Select Language / Dil Seçin:${NC}"
    echo -e "${WHITE}1)${NC} English"
    echo -e "${WHITE}2)${NC} Türkçe"
    echo
    read -p "$(echo -e ${YELLOW}"Enter your choice / Seçiminizi yapın [1-2]: "${NC})" lang_choice
    
    case $lang_choice in
        1) LANG="EN" ;;
        2) LANG="TR" ;;
        *) LANG="EN" ;;
    esac
}

# Metin çevirileri
get_text() {
    case $1 in
        "main_menu")
            [ "$LANG" = "TR" ] && echo "ANA MENÜ" || echo "MAIN MENU"
            ;;
        "install")
            [ "$LANG" = "TR" ] && echo "Kurulum Yap" || echo "Install Node"
            ;;
        "check_sync")
            [ "$LANG" = "TR" ] && echo "Sync Durumu Kontrol Et" || echo "Check Sync Status"
            ;;
        "view_logs")
            [ "$LANG" = "TR" ] && echo "Logları Görüntüle" || echo "View Logs"
            ;;
        "create_wallet")
            [ "$LANG" = "TR" ] && echo "Cüzdan Oluştur" || echo "Create Wallet"
            ;;
        "import_wallet")
            [ "$LANG" = "TR" ] && echo "Cüzdan İçe Aktar" || echo "Import Wallet"
            ;;
        "create_validator")
            [ "$LANG" = "TR" ] && echo "Validator Oluştur" || echo "Create Validator"
            ;;
        "delegate")
            [ "$LANG" = "TR" ] && echo "Token Delege Et" || echo "Delegate Tokens"
            ;;
        "send_tokens")
            [ "$LANG" = "TR" ] && echo "Token Gönder" || echo "Send Tokens"
            ;;
        "check_balance")
            [ "$LANG" = "TR" ] && echo "Bakiye Kontrol Et" || echo "Check Balance"
            ;;
        "node_management")
            [ "$LANG" = "TR" ] && echo "Node Yönetimi" || echo "Node Management"
            ;;
        "restart_node")
            [ "$LANG" = "TR" ] && echo "Node'u Yeniden Başlat" || echo "Restart Node"
            ;;
        "stop_node")
            [ "$LANG" = "TR" ] && echo "Node'u Durdur" || echo "Stop Node"
            ;;
        "start_node")
            [ "$LANG" = "TR" ] && echo "Node'u Başlat" || echo "Start Node"
            ;;
        "node_status")
            [ "$LANG" = "TR" ] && echo "Node Durumu" || echo "Node Status"
            ;;
        "delete_node")
            [ "$LANG" = "TR" ] && echo "Node'u Sil" || echo "Delete Node"
            ;;
        "back")
            [ "$LANG" = "TR" ] && echo "Geri" || echo "Back"
            ;;
        "exit")
            [ "$LANG" = "TR" ] && echo "Çıkış" || echo "Exit"
            ;;
        "press_enter")
            [ "$LANG" = "TR" ] && echo "Devam etmek için Enter'a basın..." || echo "Press Enter to continue..."
            ;;
        "enter_moniker")
            [ "$LANG" = "TR" ] && echo "Node isminizi girin" || echo "Enter your node name (moniker)"
            ;;
        "enter_wallet")
            [ "$LANG" = "TR" ] && echo "Cüzdan isminizi girin" || echo "Enter your wallet name"
            ;;
        "enter_port")
            [ "$LANG" = "TR" ] && echo "Port prefix girin (örn: 10, 45)" || echo "Enter port prefix (e.g: 10, 45)"
            ;;
        "installation_complete")
            [ "$LANG" = "TR" ] && echo "Kurulum tamamlandı!" || echo "Installation completed!"
            ;;
        "go_version_check")
            [ "$LANG" = "TR" ] && echo "Go versiyonu kontrol ediliyor..." || echo "Checking Go version..."
            ;;
    esac
}

# Go versiyon kontrolü ve kurulumu
install_go() {
    echo -e "${BLUE}$(get_text go_version_check)${NC}"
    
    REQUIRED_GO_VERSION="1.23.5"
    
    if command -v go &> /dev/null; then
        CURRENT_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
        echo -e "${YELLOW}Mevcut Go versiyonu: $CURRENT_VERSION${NC}"
        
        if [ "$(printf '%s\n' "$REQUIRED_GO_VERSION" "$CURRENT_VERSION" | sort -V | head -n1)" = "$REQUIRED_GO_VERSION" ]; then
            echo -e "${GREEN}Go versiyonu uygun. Kurulum atlanıyor.${NC}"
            return
        fi
    fi
    
    echo -e "${YELLOW}Go $REQUIRED_GO_VERSION kuruluyor...${NC}"
    
    rm -rf $HOME/go
    sudo rm -rf /usr/local/go
    cd $HOME
    curl https://dl.google.com/go/go${REQUIRED_GO_VERSION}.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -
    
    cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
    
    source $HOME/.profile
    echo -e "${GREEN}Go $(go version) kuruldu.${NC}"
}

# Bağımlılıkları yükle
install_dependencies() {
    echo -e "${BLUE}Sistem bağımlılıkları yükleniyor...${NC}"
    sudo apt update
    sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
    echo -e "${GREEN}Bağımlılıklar yüklendi.${NC}"
}

# Node kurulumu
install_node() {
    clear
    print_logo
    
    read -p "$(echo -e ${YELLOW}$(get_text enter_moniker)": "${NC})" MONIKER
    
    if [ -z "$MONIKER" ]; then
        echo -e "${RED}Node ismi boş olamaz!${NC}"
        sleep 2
        return
    fi
    
    # Port seçimi
    echo
    read -p "$(echo -e ${YELLOW}$(get_text enter_port)" [varsayılan: 10]: "${NC})" CUSTOM_PORT
    
    # Eğer port girilmemişse varsayılan 10 kullan
    if [ -z "$CUSTOM_PORT" ]; then
        CUSTOM_PORT="10"
    fi
    
    # Port validasyonu (sadece rakam kontrolü)
    if ! [[ "$CUSTOM_PORT" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Geçersiz port! Sadece rakam girebilirsiniz. Varsayılan port (10) kullanılacak.${NC}"
        CUSTOM_PORT="10"
        sleep 2
    fi
    
    echo -e "${GREEN}Seçilen port prefix: $CUSTOM_PORT${NC}"
    echo -e "${YELLOW}Portlar: ${CUSTOM_PORT}317, ${CUSTOM_PORT}657, ${CUSTOM_PORT}656, vb.${NC}"
    sleep 2
    
    echo -e "${BLUE}Kurulum başlıyor...${NC}"
    
    # Bağımlılıkları yükle
    install_dependencies
    
    # Go yükle
    install_go
    
    # ============================================================
    # FIX: Lumera binary indir ve doğru konuma yerleştir (v1.12.0)
    # ============================================================
    echo -e "${BLUE}Lumera v1.12.0 binary indiriliyor...${NC}"
    
    # Geçici çalışma dizini oluştur
    WORK_DIR=$(mktemp -d)
    cd "$WORK_DIR"
    
    wget https://github.com/LumeraProtocol/lumera/releases/download/v1.12.0/lumera_v1.12.0_linux_amd64.tar.gz
    
    if [ ! -f "lumera_v1.12.0_linux_amd64.tar.gz" ]; then
        echo -e "${RED}Binary indirilemedi! İnternet bağlantınızı kontrol edin.${NC}"
        cd $HOME
        rm -rf "$WORK_DIR"
        sleep 3
        return
    fi
    
    # Tarball içeriğini listele (debug için)
    echo -e "${YELLOW}Tarball içeriği:${NC}"
    tar -tzf lumera_v1.12.0_linux_amd64.tar.gz
    
    # Tarball'ı çıkar
    tar -xvf lumera_v1.12.0_linux_amd64.tar.gz
    rm lumera_v1.12.0_linux_amd64.tar.gz
    
    # libwasmvm'i sistem kütüphanesine taşı (varsa)
    if find "$WORK_DIR" -name "libwasmvm*.so" 2>/dev/null | grep -q .; then
        find "$WORK_DIR" -name "libwasmvm*.so" -exec sudo mv {} /usr/lib/ \;
        echo -e "${GREEN}libwasmvm kütüphanesi kuruldu.${NC}"
    fi
    
    # FIX: lumerad binary'sini bul (tarball içinde farklı dizinde olabilir)
    LUMERAD_BIN=$(find "$WORK_DIR" -name "lumerad" -type f 2>/dev/null | head -1)
    
    if [ -z "$LUMERAD_BIN" ]; then
        echo -e "${RED}HATA: lumerad binary bulunamadı! Tarball içeriğini kontrol edin.${NC}"
        ls -la "$WORK_DIR"
        cd $HOME
        rm -rf "$WORK_DIR"
        sleep 3
        return
    fi
    
    echo -e "${GREEN}lumerad binary bulundu: $LUMERAD_BIN${NC}"
    
    # Binary'yi çalıştırılabilir yap ve go/bin'e taşı
    chmod +x "$LUMERAD_BIN"
    mkdir -p $HOME/go/bin
    cp "$LUMERAD_BIN" $HOME/go/bin/lumerad
    
    # install.sh varsa sil
    rm -f "$WORK_DIR/install.sh"
    
    # Geçici dizini temizle
    cd $HOME
    rm -rf "$WORK_DIR"
    
    # PATH'e go/bin ekle (henüz aktif değilse)
    export PATH=$PATH:$HOME/go/bin:/usr/local/go/bin
    
    # Binary'nin çalışıp çalışmadığını doğrula
    if ! command -v lumerad &> /dev/null; then
        # PATH'ten bulamazsa tam yoldan dene
        if [ ! -f "$HOME/go/bin/lumerad" ]; then
            echo -e "${RED}HATA: lumerad binary go/bin klasörüne yerleştirilemedi!${NC}"
            sleep 3
            return
        fi
        # Symlink oluştur
        sudo ln -sf $HOME/go/bin/lumerad /usr/local/bin/lumerad
    fi
    
    echo -e "${GREEN}lumerad versiyonu: $($HOME/go/bin/lumerad version 2>/dev/null || echo 'versiyon okunamadı')${NC}"
    
    # Cosmovisor kur
    echo -e "${BLUE}Cosmovisor kuruluyor...${NC}"
    go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest
    
    # Cosmovisor dizin yapısını oluştur
    echo -e "${BLUE}Cosmovisor dizin yapısı oluşturuluyor...${NC}"
    mkdir -p $HOME/.lumera/cosmovisor/genesis/bin
    mkdir -p $HOME/.lumera/cosmovisor/upgrades
    
    # FIX: Binary'yi cosmovisor genesis bin'e kopyala (tam yol kullan)
    cp $HOME/go/bin/lumerad $HOME/.lumera/cosmovisor/genesis/bin/lumerad
    
    # Doğrulama: cosmovisor genesis bin'de binary var mı?
    if [ ! -f "$HOME/.lumera/cosmovisor/genesis/bin/lumerad" ]; then
        echo -e "${RED}HATA: Cosmovisor genesis binary kopyalanamadı!${NC}"
        echo -e "${RED}Kaynak: $HOME/go/bin/lumerad${NC}"
        echo -e "${RED}Hedef: $HOME/.lumera/cosmovisor/genesis/bin/lumerad${NC}"
        sleep 3
        return
    fi
    
    echo -e "${GREEN}Cosmovisor genesis binary doğrulandı: $(ls -lh $HOME/.lumera/cosmovisor/genesis/bin/lumerad)${NC}"
    
    # Node initialize
    echo -e "${BLUE}Node başlatılıyor...${NC}"
    $HOME/go/bin/lumerad init $MONIKER --chain-id=lumera-mainnet-1
    
    # Genesis ve addrbook indir
    echo -e "${BLUE}Genesis ve addrbook indiriliyor...${NC}"
    curl -Ls https://ss.lumera.nodestake.org/genesis.json > $HOME/.lumera/config/genesis.json
    curl -Ls https://ss.lumera.nodestake.org/addrbook.json > $HOME/.lumera/config/addrbook.json
    
    # Konfigürasyonları ayarla
    echo -e "${BLUE}Konfigürasyonlar ayarlanıyor...${NC}"
    
    # Environment değişkenlerini ayarla
    export WALLET="wallet"
    export LUMERA_CHAIN_ID="lumera-mainnet-1"
    export LUMERA_PORT="$CUSTOM_PORT"
    
    # Profil dosyasına ekle (önce eski ayarları temizle)
    sed -i '/LUMERA_PORT/d' $HOME/.bash_profile 2>/dev/null
    sed -i '/MONIKER/d' $HOME/.bash_profile 2>/dev/null
    sed -i '/WALLET/d' $HOME/.bash_profile 2>/dev/null
    sed -i '/LUMERA_CHAIN_ID/d' $HOME/.bash_profile 2>/dev/null
    
    cat <<EOF >> $HOME/.bash_profile
export WALLET="wallet"
export MONIKER="$MONIKER"
export LUMERA_CHAIN_ID="lumera-mainnet-1"
export LUMERA_PORT="$CUSTOM_PORT"
EOF
    
    source $HOME/.bash_profile
    
    # Port ayarları
    sed -i.bak -e "s%:1317%:${LUMERA_PORT}317%g;
s%:8080%:${LUMERA_PORT}080%g;
s%:9090%:${LUMERA_PORT}090%g;
s%:9091%:${LUMERA_PORT}091%g;
s%:8545%:${LUMERA_PORT}545%g;
s%:8546%:${LUMERA_PORT}546%g;
s%:6065%:${LUMERA_PORT}065%g" $HOME/.lumera/config/app.toml
    
    sed -i.bak -e "s%:26658%:${LUMERA_PORT}658%g;
s%:26657%:${LUMERA_PORT}657%g;
s%:6060%:${LUMERA_PORT}060%g;
s%:26656%:${LUMERA_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${LUMERA_PORT}656\"%;
s%:26660%:${LUMERA_PORT}660%g" $HOME/.lumera/config/config.toml
    
    # Pruning ayarları
    sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.lumera/config/app.toml
    sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.lumera/config/app.toml
    sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"19\"/" $HOME/.lumera/config/app.toml
    
    # Diğer ayarlar
    sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.025ulume"|g' $HOME/.lumera/config/app.toml
    sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.lumera/config/config.toml
    sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.lumera/config/config.toml
    
    # Cosmovisor servisi oluştur
    echo -e "${BLUE}Cosmovisor servisi oluşturuluyor...${NC}"
    sudo tee /etc/systemd/system/lumerad.service > /dev/null <<EOF
[Unit]
Description=Lumera Node with Cosmovisor
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=always
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_NAME=lumerad"
Environment="DAEMON_HOME=$HOME/.lumera"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
    
    sudo systemctl daemon-reload
    sudo systemctl enable lumerad
    
    # Snapshot indir
    echo -e "${BLUE}Snapshot indiriliyor... Bu işlem uzun sürebilir.${NC}"
    SNAP_NAME=$(curl -s https://ss.lumera.nodestake.org/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
    curl -o - -L https://ss.lumera.nodestake.org/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.lumera
    
    # Servisi başlat
    echo -e "${BLUE}Node başlatılıyor...${NC}"
    sudo systemctl restart lumerad
    
    echo -e "${GREEN}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}$(get_text installation_complete)${NC}"
    echo -e "${GREEN}═══════════════════════════════════════${NC}"
    echo -e "${CYAN}Node Bilgileri:${NC}"
    echo -e "${YELLOW}Moniker: ${WHITE}$MONIKER${NC}"
    echo -e "${YELLOW}Versiyon: ${WHITE}v1.12.0${NC}"
    echo -e "${YELLOW}Port Prefix: ${WHITE}$CUSTOM_PORT${NC}"
    echo -e "${YELLOW}Chain ID: ${WHITE}lumera-mainnet-1${NC}"
    echo
    echo -e "${CYAN}Kullanılan Portlar:${NC}"
    echo -e "${YELLOW}API: ${WHITE}${CUSTOM_PORT}317${NC}"
    echo -e "${YELLOW}RPC: ${WHITE}${CUSTOM_PORT}657${NC}"
    echo -e "${YELLOW}P2P: ${WHITE}${CUSTOM_PORT}656${NC}"
    echo -e "${YELLOW}gRPC: ${WHITE}${CUSTOM_PORT}090${NC}"
    echo -e "${YELLOW}Prometheus: ${WHITE}${CUSTOM_PORT}660${NC}"
    echo
    echo -e "${CYAN}Yararlı Komutlar:${NC}"
    echo -e "${YELLOW}Servis Durumu: ${WHITE}sudo systemctl status lumerad${NC}"
    echo -e "${YELLOW}Logları Görüntüle: ${WHITE}sudo journalctl -u lumerad -f${NC}"
    echo -e "${YELLOW}Sync Durumu: ${WHITE}lumerad status 2>&1 | jq .SyncInfo${NC}"
    echo -e "${GREEN}═══════════════════════════════════════${NC}"
    
    read -p "$(echo -e ${CYAN}$(get_text press_enter)${NC})"
}

# Sync durumu kontrolü
check_sync_status() {
    clear
    print_logo
    echo -e "${BLUE}Sync Durumu:${NC}"
    echo
    lumerad status 2>&1 | jq .SyncInfo
    echo
    echo -e "${YELLOW}Catching Up: false ise sync tamamlanmıştır${NC}"
    read -p "$(echo -e ${CYAN}$(get_text press_enter)${NC})"
}

# Logları görüntüle
view_logs() {
    clear
    print_logo
    echo -e "${BLUE}Logları görüntülemek için CTRL+C ile çıkabilirsiniz${NC}"
    sleep 2
    sudo journalctl -u lumerad -f --no-hostname -o cat
}

# Cüzdan oluştur
create_wallet() {
    clear
    print_logo
    read -p "$(echo -e ${YELLOW}$(get_text enter_wallet)": "${NC})" WALLET_NAME
    
    if [ -z "$WALLET_NAME" ]; then
        echo -e "${RED}Cüzdan ismi boş olamaz!${NC}"
        sleep 2
        return
    fi
    
    lumerad keys add $WALLET_NAME
    echo
    echo -e "${GREEN}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}Cüzdan oluşturuldu!${NC}"
    echo -e "${RED}⚠ UYARI: Mnemonic kelimelerinizi güvenli bir yere kaydedin!${NC}"
    echo -e "${RED}Bu kelimeleri kaybederseniz cüzdanınıza erişimi kaybedersiniz!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════${NC}"
    read -p "$(echo -e ${CYAN}$(get_text press_enter)${NC})"
}

# Cüzdan içe aktar
import_wallet() {
    clear
    print_logo
    read -p "$(echo -e ${YELLOW}$(get_text enter_wallet)": "${NC})" WALLET_NAME
    
    if [ -z "$WALLET_NAME" ]; then
        echo -e "${RED}Cüzdan ismi boş olamaz!${NC}"
        sleep 2
        return
    fi
    
    lumerad keys add $WALLET_NAME --recover
    echo
    echo -e "${GREEN}Cüzdan içe aktarıldı!${NC}"
    read -p "$(echo -e ${CYAN}$(get_text press_enter)${NC})"
}

# Validator oluştur
create_validator() {
    clear
    print_logo
    
    echo -e "${YELLOW}Validator Detayları:${NC}"
    echo
    read -p "Cüzdan ismi: " WALLET_NAME
    read -p "Validator ismi (moniker): " MONIKER
    read -p "Identity (opsiyonel, Keybase ID): " IDENTITY
    read -p "Website (opsiyonel): " WEBSITE
    read -p "Security Contact (email): " SECURITY
    read -p "Details (açıklama): " DETAILS
    read -p "Commission rate (örn: 0.05): " RATE
    read -p "Commission max rate (örn: 0.20): " MAX_RATE
    read -p "Commission max change rate (örn: 0.01): " MAX_CHANGE_RATE
    read -p "Minimum self delegation (örn: 1): " MIN_SELF_DELEGATION
    read -p "Stake miktarı (örn: 1000000ulume): " AMOUNT
    
    lumerad tx staking create-validator \
        --amount=$AMOUNT \
        --pubkey=$(lumerad tendermint show-validator) \
        --moniker="$MONIKER" \
        --identity="$IDENTITY" \
        --website="$WEBSITE" \
        --security-contact="$SECURITY" \
        --details="$DETAILS" \
        --chain-id=lumera-mainnet-1 \
        --commission-rate="$RATE" \
        --commission-max-rate="$MAX_RATE" \
        --commission-max-change-rate="$MAX_CHANGE_RATE" \
        --min-self-delegation="$MIN_SELF_DELEGATION" \
        --from=$WALLET_NAME \
        --gas=auto \
        --gas-adjustment=1.4 \
        --fees=500ulume \
        -y
    
    echo
    echo -e "${GREEN}Validator oluşturma işlemi gönderildi!${NC}"
    echo -e "${YELLOW}Explorer'dan validator'ınızı kontrol edebilirsiniz.${NC}"
    read -p "$(echo -e ${CYAN}$(get_text press_enter)${NC})"
}

# Token delege et
delegate_tokens() {
    clear
    print_logo
    
    read -p "Cüzdan ismi: " WALLET_NAME
    read -p "Validator adresi: " VALIDATOR_ADDR
    read -p "Miktar (örn: 1000000ulume): " AMOUNT
    
    lumerad tx staking delegate $VALIDATOR_ADDR $AMOUNT \
        --from=$WALLET_NAME \
        --chain-id=lumera-mainnet-1 \
        --gas=auto \
        --gas-adjustment=1.4 \
        --fees=500ulume \
        -y
    
    echo
    echo -e "${GREEN}Delegasyon işlemi gönderildi!${NC}"
    read -p "$(echo -e ${CYAN}$(get_text press_enter)${NC})"
}

# Token gönder
send_tokens() {
    clear
    print_logo
    
    read -p "Gönderen cüzdan ismi: " WALLET_NAME
    read -p "Alıcı adres: " TO_ADDRESS
    read -p "Miktar (örn: 1000000ulume): " AMOUNT
    
    lumerad tx bank send $WALLET_NAME $TO_ADDRESS $AMOUNT \
        --chain-id=lumera-mainnet-1 \
        --gas=auto \
        --gas-adjustment=1.4 \
        --fees=500ulume \
        -y
    
    echo
    echo -e "${GREEN}Transfer işlemi gönderildi!${NC}"
    read -p "$(echo -e ${CYAN}$(get_text press_enter)${NC})"
}

# Bakiye kontrol et
check_balance() {
    clear
    print_logo
    
    read -p "Cüzdan ismi veya adres: " WALLET
    
    echo -e "${BLUE}Bakiye sorgulanıyor...${NC}"
    lumerad query bank balances $WALLET
    
    echo
    read -p "$(echo -e ${CYAN}$(get_text press_enter)${NC})"
}

# Node yönetimi menüsü
node_management_menu() {
    while true; do
        clear
        print_logo
        echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${NC}     $(get_text node_management)           ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
        echo
        echo -e "${WHITE}1)${NC}  $(get_text node_status)"
        echo -e "${WHITE}2)${NC}  $(get_text restart_node)"
        echo -e "${WHITE}3)${NC}  $(get_text stop_node)"
        echo -e "${WHITE}4)${NC}  $(get_text start_node)"
        echo -e "${WHITE}5)${NC}  $(get_text delete_node)"
        echo -e "${WHITE}0)${NC}  $(get_text back)"
        echo
        read -p "$(echo -e ${YELLOW}"Seçiminiz / Your choice: "${NC})" choice
        
        case $choice in
            1)
                clear
                print_logo
                sudo systemctl status lumerad
                echo
                read -p "$(echo -e ${CYAN}$(get_text press_enter)${NC})"
                ;;
            2)
                echo -e "${BLUE}Node yeniden başlatılıyor...${NC}"
                sudo systemctl restart lumerad
                echo -e "${GREEN}Node yeniden başlatıldı!${NC}"
                sleep 2
                ;;
            3)
                echo -e "${BLUE}Node durduruluyor...${NC}"
                sudo systemctl stop lumerad
                echo -e "${GREEN}Node durduruldu!${NC}"
                sleep 2
                ;;
            4)
                echo -e "${BLUE}Node başlatılıyor...${NC}"
                sudo systemctl start lumerad
                echo -e "${GREEN}Node başlatıldı!${NC}"
                sleep 2
                ;;
            5)
                clear
                print_logo
                echo -e "${RED}⚠ UYARI: Bu işlem node'unuzu tamamen silecektir!${NC}"
                echo -e "${RED}Cüzdan bilgilerinizi yedeklediğinizden emin olun!${NC}"
                echo
                read -p "$(echo -e ${YELLOW}"Devam etmek istiyor musunuz? (y/n): "${NC})" confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    echo -e "${BLUE}Node siliniyor...${NC}"
                    sudo systemctl stop lumerad
                    sudo systemctl disable lumerad
                    sudo rm /etc/systemd/system/lumerad.service
                    sudo systemctl daemon-reload
                    rm -rf $HOME/.lumera
                    rm -rf $HOME/go/bin/lumerad
                    sudo rm -f /usr/local/bin/lumerad
                    sed -i '/LUMERA/d' $HOME/.bash_profile
                    echo -e "${GREEN}Node tamamen silindi!${NC}"
                    sleep 3
                    return
                else
                    echo -e "${YELLOW}İşlem iptal edildi.${NC}"
                    sleep 2
                fi
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}Geçersiz seçim!${NC}"
                sleep 2
                ;;
        esac
    done
}

# Ana menü
main_menu() {
    while true; do
        clear
        print_logo
        echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${NC}           $(get_text main_menu)                  ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
        echo
        echo -e "${WHITE}1)${NC}  $(get_text install)"
        echo -e "${WHITE}2)${NC}  $(get_text check_sync)"
        echo -e "${WHITE}3)${NC}  $(get_text view_logs)"
        echo -e "${WHITE}4)${NC}  $(get_text create_wallet)"
        echo -e "${WHITE}5)${NC}  $(get_text import_wallet)"
        echo -e "${WHITE}6)${NC}  $(get_text create_validator)"
        echo -e "${WHITE}7)${NC}  $(get_text delegate)"
        echo -e "${WHITE}8)${NC}  $(get_text send_tokens)"
        echo -e "${WHITE}9)${NC}  $(get_text check_balance)"
        echo -e "${WHITE}10)${NC} $(get_text node_management)"
        echo -e "${WHITE}0)${NC}  $(get_text exit)"
        echo
        read -p "$(echo -e ${YELLOW}"Seçiminiz / Your choice: "${NC})" choice
        
        case $choice in
            1) install_node ;;
            2) check_sync_status ;;
            3) view_logs ;;
            4) create_wallet ;;
            5) import_wallet ;;
            6) create_validator ;;
            7) delegate_tokens ;;
            8) send_tokens ;;
            9) check_balance ;;
            10) node_management_menu ;;
            0) 
                echo -e "${GREEN}Çıkılıyor... / Exiting...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Geçersiz seçim! / Invalid choice!${NC}"
                sleep 2
                ;;
        esac
    done
}

# Script başlangıcı
select_language
main_menu
