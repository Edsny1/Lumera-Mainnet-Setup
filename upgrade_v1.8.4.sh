#!/bin/bash

# Lumera v1.8.4 "Aurora Halo Δ" Upgrade Script
# Upgrade Height: 2270000
# ETA: 2025-11-12 · 15:39:40 UTC

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ASCII Art
print_logo() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                                                               ║"
    echo "║          Lumera Network v1.8.4 Upgrade Script                 ║"
    echo "║                  'Aurora Halo Δ'                              ║"
    echo "║                                                               ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Upgrade Height: ${WHITE}2270000${NC}"
    echo -e "${YELLOW}ETA: ${WHITE}2025-11-12 · 15:39:40 UTC${NC}"
    echo -e "${YELLOW}Upgrade Path: ${WHITE}v1.7.2 → v1.8.4${NC}"
    echo
}

# Versiyon kontrolü
check_current_version() {
    echo -e "${BLUE}Mevcut versiyon kontrol ediliyor...${NC}"
    CURRENT_VERSION=$(lumerad version 2>/dev/null)
    
    if [ -z "$CURRENT_VERSION" ]; then
        echo -e "${RED}✗ lumerad bulunamadı!${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Mevcut versiyon: ${WHITE}$CURRENT_VERSION${NC}"
    
    if [ "$CURRENT_VERSION" = "1.8.4" ]; then
        echo -e "${GREEN}✓ Zaten v1.8.4 versiyonundasınız!${NC}"
        read -p "Yine de devam etmek istiyor musunuz? (y/n): " CONTINUE
        if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
            exit 0
        fi
    fi
}

# Cosmovisor kontrolü
check_cosmovisor() {
    echo -e "${BLUE}Cosmovisor kontrol ediliyor...${NC}"
    
    if [ -d "$HOME/.lumera/cosmovisor" ]; then
        USE_COSMOVISOR=true
        echo -e "${GREEN}✓ Cosmovisor tespit edildi${NC}"
    else
        USE_COSMOVISOR=false
        echo -e "${YELLOW}⚠ Cosmovisor bulunamadı - Manuel upgrade yapılacak${NC}"
    fi
}

# Yedek al
backup_binary() {
    echo -e "${BLUE}Mevcut binary yedekleniyor...${NC}"
    
    if [ -f "$HOME/go/bin/lumerad" ]; then
        cp $HOME/go/bin/lumerad $HOME/go/bin/lumerad.backup.$(date +%Y%m%d_%H%M%S)
        echo -e "${GREEN}✓ Binary yedeklendi${NC}"
    fi
}

# libwasmvm güncelleme
update_libwasmvm() {
    echo -e "${BLUE}══════════════════════════════════════${NC}"
    echo -e "${BLUE}libwasmvm v3.0.0-ibc2.0 güncelleniyor...${NC}"
    echo -e "${BLUE}══════════════════════════════════════${NC}"
    
    cd $HOME
    
    echo -e "${CYAN}Binary'ler indiriliyor...${NC}"
    wget -q --show-progress https://github.com/LumeraProtocol/lumera/releases/download/v1.8.4/lumera_v1.8.4_linux_amd64.tar.gz
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ İndirme başarısız!${NC}"
        exit 1
    fi
    
    echo -e "${CYAN}Arşiv açılıyor...${NC}"
    tar xzvf lumera_v1.8.4_linux_amd64.tar.gz > /dev/null 2>&1
    
    echo -e "${CYAN}libwasmvm kütüphanesi kuruluyor...${NC}"
    sudo mv libwasmvm.x86_64.so /usr/lib/
    
    echo -e "${CYAN}Checksum doğrulanıyor...${NC}"
    wget -q https://github.com/CosmWasm/wasmvm/releases/download/v3.0.0-ibc2.0/checksums.txt
    
    if sha256sum -c checksums.txt 2>/dev/null | grep -q "libwasmvm.x86_64.so: OK"; then
        echo -e "${GREEN}✓ Checksum başarıyla doğrulandı${NC}"
    else
        echo -e "${RED}✗ Checksum doğrulama başarısız!${NC}"
        echo -e "${YELLOW}Bu durumda node başlatılamayabilir.${NC}"
        read -p "Devam etmek istiyor musunuz? (y/n): " CONTINUE_CHECKSUM
        if [ "$CONTINUE_CHECKSUM" != "y" ] && [ "$CONTINUE_CHECKSUM" != "Y" ]; then
            exit 1
        fi
    fi
    
    echo -e "${GREEN}✓ libwasmvm başarıyla güncellendi${NC}"
}

# Manuel upgrade
manual_upgrade() {
    echo -e "${BLUE}══════════════════════════════════════${NC}"
    echo -e "${BLUE}Manuel Upgrade Yapılıyor...${NC}"
    echo -e "${BLUE}══════════════════════════════════════${NC}"
    
    chmod +x lumerad
    mv lumerad $HOME/go/bin/
    
    NEW_VERSION=$(lumerad version 2>/dev/null)
    
    if [ "$NEW_VERSION" = "1.8.4" ]; then
        echo -e "${GREEN}✓ Binary başarıyla güncellendi: v${NEW_VERSION}${NC}"
    else
        echo -e "${RED}✗ Binary güncelleme başarısız! Versiyon: $NEW_VERSION${NC}"
        exit 1
    fi
    
    cd $HOME
    rm -f lumera_v1.8.4_linux_amd64.tar.gz checksums.txt install.sh
    
    echo -e "${GREEN}✓ Manuel upgrade hazırlığı tamamlandı${NC}"
    echo
    echo -e "${YELLOW}Node'u yeniden başlatmanız gerekiyor:${NC}"
    echo -e "${CYAN}sudo systemctl restart lumerad${NC}"
}

# ✅ GÜNCELLENMİŞ FONKSİYON
cosmovisor_upgrade() {
    echo -e "${BLUE}══════════════════════════════════════${NC}"
    echo -e "${BLUE}Cosmovisor Upgrade Hazırlanıyor...${NC}"
    echo -e "${BLUE}══════════════════════════════════════${NC}"
    
    echo -e "${CYAN}Upgrade dizini oluşturuluyor...${NC}"
    mkdir -p $HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin
    
    chmod +x lumerad
    cp lumerad $HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin/
    
    NEW_VERSION=$($HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin/lumerad version 2>/dev/null)
    
    if [ "$NEW_VERSION" = "1.8.4" ]; then
        echo -e "${GREEN}✓ Cosmovisor binary başarıyla hazırlandı: v${NEW_VERSION}${NC}"
    else
        echo -e "${RED}✗ Cosmovisor binary hazırlama başarısız! Versiyon: $NEW_VERSION${NC}"
        exit 1
    fi

    echo -e "${CYAN}Cosmovisor 'current' symlink'i güncelleniyor...${NC}"
    cd $HOME/.lumera/cosmovisor
    if [ -d "current" ] || [ -L "current" ]; then
        rm -rf current
    fi
    ln -s upgrades/v1.8.4 current
    echo -e "${GREEN}✓ Cosmovisor 'current' symlink'i güncellendi${NC}"
    readlink -f current
    
    cd $HOME
    rm -f lumera_v1.8.4_linux_amd64.tar.gz checksums.txt lumerad install.sh
    
    echo -e "${GREEN}✓ Cosmovisor upgrade hazırlığı tamamlandı${NC}"
    echo
    echo -e "${YELLOW}Cosmovisor upgrade height'a ulaştığında otomatik geçiş yapacak${NC}"
}

# Block height kontrolü
check_block_height() {
    echo -e "${BLUE}Mevcut block height kontrol ediliyor...${NC}"
    
    CURRENT_HEIGHT=$(lumerad status 2>&1 | jq -r '.SyncInfo.latest_block_height' 2>/dev/null)
    UPGRADE_HEIGHT=2270000
    
    if [ -z "$CURRENT_HEIGHT" ] || [ "$CURRENT_HEIGHT" = "null" ]; then
        echo -e "${YELLOW}⚠ Block height alınamadı (Node çalışmıyor olabilir)${NC}"
    else
        echo -e "${GREEN}✓ Mevcut height: ${WHITE}$CURRENT_HEIGHT${NC}"
        
        REMAINING=$((UPGRADE_HEIGHT - CURRENT_HEIGHT))
        
        if [ $REMAINING -gt 0 ]; then
            echo -e "${YELLOW}Upgrade height'a kalan: ${WHITE}$REMAINING blocks${NC}"
            ESTIMATED_SECONDS=$((REMAINING * 6))
            ESTIMATED_HOURS=$((ESTIMATED_SECONDS / 3600))
            ESTIMATED_MINUTES=$(((ESTIMATED_SECONDS % 3600) / 60))
            echo -e "${YELLOW}Tahmini süre: ${WHITE}~${ESTIMATED_HOURS}h ${ESTIMATED_MINUTES}m${NC}"
        elif [ $REMAINING -eq 0 ]; then
            echo -e "${GREEN}✓ Upgrade height'a ulaşıldı!${NC}"
        else
            echo -e "${GREEN}✓ Upgrade height geçildi${NC}"
        fi
    fi
}

offer_restart() {
    echo
    echo -e "${YELLOW}Node'u şimdi yeniden başlatmak istiyor musunuz?${NC}"
    echo -e "${CYAN}1)${NC} Evet, şimdi restart yap"
    echo -e "${CYAN}2)${NC} Hayır, manuel restart yapacağım"
    echo
    read -p "Seçiminiz [1-2]: " RESTART_CHOICE
    
    if [ "$RESTART_CHOICE" = "1" ]; then
        echo -e "${BLUE}Node yeniden başlatılıyor...${NC}"
        sudo systemctl restart lumerad
        sleep 3
        echo -e "${GREEN}✓ Node yeniden başlatıldı${NC}"
        echo
        echo -e "${CYAN}Logları görüntülemek için:${NC}"
        echo -e "${WHITE}sudo journalctl -u lumerad -f${NC}"
    else
        echo -e "${YELLOW}Node'u manuel olarak yeniden başlatmayı unutmayın:${NC}"
        echo -e "${WHITE}sudo systemctl restart lumerad${NC}"
    fi
}

print_summary() {
    echo
    echo -e "${GREEN}══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}           Upgrade Hazırlığı Tamamlandı!              ${NC}"
    echo -e "${GREEN}══════════════════════════════════════════════════════${NC}"
    echo
    echo -e "${CYAN}Upgrade Bilgileri:${NC}"
    echo -e "${YELLOW}• Upgrade Height: ${WHITE}2270000${NC}"
    echo -e "${YELLOW}• ETA: ${WHITE}2025-11-12 · 15:39:40 UTC${NC}"
    echo -e "${YELLOW}• Yeni Versiyon: ${WHITE}v1.8.4${NC}"
    echo -e "${YELLOW}• Upgrade Adı: ${WHITE}Aurora Halo Δ${NC}"
    echo
    echo -e "${CYAN}Yararlı Komutlar:${NC}"
    echo -e "${YELLOW}• Versiyon kontrolü: ${WHITE}lumerad version${NC}"
    echo -e "${YELLOW}• Block height: ${WHITE}lumerad status 2>&1 | jq .SyncInfo.latest_block_height${NC}"
    echo -e "${YELLOW}• Sync durumu: ${WHITE}lumerad status 2>&1 | jq .SyncInfo.catching_up${NC}"
    echo -e "${YELLOW}• Logları izle: ${WHITE}sudo journalctl -u lumerad -f${NC}"
    echo -e "${YELLOW}• Node restart: ${WHITE}sudo systemctl restart lumerad${NC}"
    echo
    
    if [ "$USE_COSMOVISOR" = true ]; then
        echo -e "${GREEN}✓ Cosmovisor otomatik geçiş yapacak${NC}"
        echo -e "${YELLOW}  Upgrade height'a ulaşıldığında node otomatik olarak v1.8.4'e geçecek${NC}"
    else
        echo -e "${YELLOW}⚠ Manuel upgrade - Node'u yeniden başlatmanız gerekiyor${NC}"
    fi
    
    echo -e "${GREEN}══════════════════════════════════════════════════════${NC}"
}

main() {
    clear
    print_logo
    
    echo -e "${CYAN}Upgrade süreci başlıyor...${NC}"
    echo
    
    check_current_version
    echo
    check_cosmovisor
    echo
    
    echo -e "${YELLOW}Devam etmek istiyor musunuz? (y/n)${NC}"
    read -p "> " CONFIRM
    
    if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
        echo -e "${RED}İşlem iptal edildi.${NC}"
        exit 0
    fi
    
    echo
    backup_binary
    echo
    update_libwasmvm
    echo
    
    if [ "$USE_COSMOVISOR" = true ]; then
        cosmovisor_upgrade
    else
        manual_upgrade
    fi
    
    echo
    check_block_height
    
    if [ "$USE_COSMOVISOR" = false ]; then
        offer_restart
    fi
    
    print_summary
    echo
    echo -e "${GREEN}Script başarıyla tamamlandı!${NC}"
    echo -e "${CYAN}Hazırlayan: OshVanK${NC}"
}

main
