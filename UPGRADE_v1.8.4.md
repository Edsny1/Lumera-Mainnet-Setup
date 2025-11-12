# Lumera Network v1.8.4 Upgrade Guide - "Aurora Halo Δ"

![Lumera](https://img.shields.io/badge/Lumera-v1.8.4-blue)
![Upgrade](https://img.shields.io/badge/Upgrade-Aurora_Halo_Δ-green)
![Status](https://img.shields.io/badge/Status-Active-success)

## 📋 Upgrade Bilgileri

| Parametre | Değer |
|-----------|-------|
| **Proposal** | Software Upgrade → v1.8.4 |
| **Voting Window** | 24 saat (Expedited!) |
| **Upgrade Height** | 2270000 |
| **ETA** | 2025-11-12 · 15:39:40 UTC |
| **Deposit** | 5 LUME |
| **Upgrade Path** | v1.7.2 → v1.8.4 |

## 🎯 Upgrade Özeti

**Aurora Halo Δ** upgrade'i Lumera mainnet'i v1.8.x versiyonuna yükselterek:
- IBC v2 / CosmWasm v3 migrasyonunu tamamlar
- Protobuf ve legacy codec uyumluluğunu standardize eder
- Testnet-2'de tanıtılan birleşik upgrade sistemini finalize eder

## 🚀 Temel Yenilikler

### 1. IBC v2 / Router V2 (ICS-27 & 30)

- ✅ `ibc-go v10.3.0` + `SetRouterV2` desteği
- ✅ Packet-Forward Middleware (ICS-30)
- ✅ Interchain Accounts (ICS-27)
- ✅ IBC Callbacks Middleware (custom pre/post hooks)
- ✅ Tendermint & Solomachine light clients

> **Sonuç:** Lumera artık IBC v2-ready — Ethereum/Solana bridge entegrasyonu için temel hazır!

### 2. CosmWasm + WasmVM Upgrade

- ✅ `wasmd v0.55.0-ibc2.0` & `wasmvm v3.0.0-ibc2.0`
- ✅ Contract-level IBC callbacks
- ✅ Snapshot export desteği
- ✅ Runtime & güvenlik iyileştirmeleri

### 3. Ignite CLI v29 + Buf v2 Migration

- ✅ Daha hızlı protobuf builds
- ✅ Breaking-change validation
- ✅ Yeni `appconfig` pattern + DepInject refactor

### 4. v1.8.4 Spesifik Özellikler

#### Legacy Type & Codec Compatibility
- `internal/legacyalias` eklendi (pre-versioned Action / SuperNode messages için)
- AutoCLI artık legacy-aware resolver kullanıyor

#### Enum Bridge Fix
- `internal/protobridge` layer eklendi
- `gogoproto ↔ protobuf` senkronizasyonu
- GRPC/REST enum uyumsuzlukları giderildi

#### Action.price Normalization
- Plain string'e çevrildi (external tool uyumluluğu için)
- Legacy safe

#### Unified Upgrade System
- `app.setupUpgrades()` + shared `AppUpgradeParams`
- Binary eksik plan hatası için early panic
- v1.8.4 handlers tüm ağlar için kayıtlı

#### Signature & Security
- ADR-36 / Keplr arbitrary-signing desteği
- DER→RS64 coercion
- Cascade/Sense signature validation güçlendirildi
- Kademlia ID validation sıkılaştırıldı

## ⚠️ ÖNEMLİ: libwasmvm Güncelleme Zorunluluğu

**Tüm node'lar upgrade öncesi libwasmvm'yi güncellemelidir!**

Bu adım atlanırsa node başlangıçta panic verecektir.

## 📝 Manuel Upgrade Adımları

### Adım 1: libwasmvm Güncelleme

```bash
# v1.8.4 binary'lerini indirin
cd $HOME
wget https://github.com/LumeraProtocol/lumera/releases/download/v1.8.4/lumera_v1.8.4_linux_amd64.tar.gz

# Arşivi açın
tar xzvf lumera_v1.8.4_linux_amd64.tar.gz

# libwasmvm'yi güncelleyin
sudo mv libwasmvm.x86_64.so /usr/lib/

# Checksum doğrulaması
wget https://github.com/CosmWasm/wasmvm/releases/download/v3.0.0-ibc2.0/checksums.txt
sha256sum -c checksums.txt | grep libwasmvm.x86_64.so
```

**Beklenen Çıktı:**
```
libwasmvm.x86_64.so: OK
```

### Adım 2: Binary Güncelleme

```bash
# Eski binary'yi yedekleyin
cp $HOME/go/bin/lumerad $HOME/go/bin/lumerad.v1.7.2.backup

# Yeni binary'yi taşıyın
chmod +x lumerad
mv lumerad $HOME/go/bin/

# Versiyon kontrolü
lumerad version
```

**Beklenen Çıktı:** `1.8.4`

### Adım 3: Node'u Yeniden Başlatma

```bash
# Node'u durdurun
sudo systemctl stop lumerad

# Node'u başlatın (upgrade height'a ulaştığında otomatik upgrade olacak)
sudo systemctl start lumerad

# Logları takip edin
sudo journalctl -u lumerad -f
```

### Adım 4: Upgrade Doğrulama

Upgrade height (2270000) ulaşıldıktan sonra:

```bash
# Versiyon kontrolü
lumerad version

# Sync durumu
lumerad status 2>&1 | jq .SyncInfo

# Block height kontrolü
lumerad status 2>&1 | jq .SyncInfo.latest_block_height
```

## 🤖 Cosmovisor ile Otomatik Upgrade

### Hazırlık

```bash
# Upgrade dizinini oluşturun
mkdir -p $HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin

# v1.8.4 binary'lerini indirin
cd $HOME
wget https://github.com/LumeraProtocol/lumera/releases/download/v1.8.4/lumera_v1.8.4_linux_amd64.tar.gz
tar xzvf lumera_v1.8.4_linux_amd64.tar.gz

# libwasmvm'yi güncelleyin
sudo mv libwasmvm.x86_64.so /usr/lib/

# Checksum doğrulaması
wget https://github.com/CosmWasm/wasmvm/releases/download/v3.0.0-ibc2.0/checksums.txt
sha256sum -c checksums.txt | grep libwasmvm.x86_64.so

# Binary'yi Cosmovisor upgrade klasörüne kopyalayın
chmod +x lumerad
cp lumerad $HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin/

# Binary'yi test edin
$HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin/lumerad version
```

**Beklenen Çıktı:** `1.8.4`

### Cosmovisor Otomatik Upgrade

Cosmovisor yapılandırmanız varsa, upgrade height'a ulaşıldığında otomatik olarak yeni binary'ye geçiş yapacaktır.

```bash
# Logları takip edin
sudo journalctl -u lumerad -f
```

Upgrade sırasında şu mesajları göreceksiniz:
```
INF applying upgrade "v1.8.4" at height: 2270000
INF migrating module store migrations...
INF upgrade to v1.8.4 successful
```

## 📊 Upgrade Scripti

Otomatik upgrade için hazır script:

```bash
#!/bin/bash

# Renkler
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Lumera v1.8.4 Upgrade Başlıyor...${NC}"

# libwasmvm güncelleme
echo -e "${GREEN}1. libwasmvm güncelleniyor...${NC}"
cd $HOME
wget -q https://github.com/LumeraProtocol/lumera/releases/download/v1.8.4/lumera_v1.8.4_linux_amd64.tar.gz
tar xzvf lumera_v1.8.4_linux_amd64.tar.gz > /dev/null 2>&1
sudo mv libwasmvm.x86_64.so /usr/lib/

# Checksum doğrulama
echo -e "${GREEN}2. Checksum doğrulanıyor...${NC}"
wget -q https://github.com/CosmWasm/wasmvm/releases/download/v3.0.0-ibc2.0/checksums.txt
if sha256sum -c checksums.txt 2>/dev/null | grep -q "libwasmvm.x86_64.so: OK"; then
    echo -e "${GREEN}✓ Checksum doğrulandı${NC}"
else
    echo -e "${RED}✗ Checksum hatası!${NC}"
    exit 1
fi

# Cosmovisor için hazırlık
echo -e "${GREEN}3. Cosmovisor upgrade dizini hazırlanıyor...${NC}"
mkdir -p $HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin
chmod +x lumerad
cp lumerad $HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin/

# Versiyon kontrolü
VERSION=$($HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin/lumerad version)
if [ "$VERSION" = "1.8.4" ]; then
    echo -e "${GREEN}✓ Binary versiyonu doğru: $VERSION${NC}"
else
    echo -e "${RED}✗ Binary versiyon hatası: $VERSION${NC}"
    exit 1
fi

# Temizlik
rm -f lumera_v1.8.4_linux_amd64.tar.gz checksums.txt

echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}Upgrade hazırlığı tamamlandı!${NC}"
echo -e "${YELLOW}Upgrade Height: 2270000${NC}"
echo -e "${YELLOW}ETA: 2025-11-12 · 15:39:40 UTC${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}"
```

Script'i kullanmak için:

```bash
wget -O upgrade_v1.8.4.sh https://raw.githubusercontent.com/Edsny1/Lumera-Mainnet-Setup/refs/heads/Edsny/scripts/upgrade_v1.8.4.sh
chmod +x upgrade_v1.8.4.sh
./upgrade_v1.8.4.sh
```

## 🔍 Sorun Giderme

### Problem 1: libwasmvm Panic

**Hata:**
```
panic: failed to initialize wasm vm
```

**Çözüm:**
```bash
cd $HOME
wget https://github.com/LumeraProtocol/lumera/releases/download/v1.8.4/lumera_v1.8.4_linux_amd64.tar.gz
tar xzvf lumera_v1.8.4_linux_amd64.tar.gz
sudo mv libwasmvm.x86_64.so /usr/lib/
sudo systemctl restart lumerad
```

### Problem 2: Upgrade Height'ta Takılma

**Hata:**
```
ERR UPGRADE "v1.8.4" NEEDED at height: 2270000
```

**Çözüm:**
```bash
# Binary'nin doğru versiyonda olduğundan emin olun
lumerad version

# Cosmovisor kullanıyorsanız
ls -la $HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin/

# Manuel upgrade için
sudo systemctl stop lumerad
# Binary'yi güncelleyin (Adım 2)

cd /root/.lumera/cosmovisor

# 1️⃣ Mevcut current dizinini tamamen sil
rm -rf current

# 2️⃣ Şimdi doğru şekilde symlink oluştur
ln -s upgrades/v1.8.4 current

# 3️⃣ Kontrol et
readlink -f current
Çıktı: /root/.lumera/cosmovisor/upgrades/v1.8.4

sudo systemctl start lumerad
```

### Problem 3: Checksum Hatası

**Çözüm:**
```bash
# libwasmvm'yi tekrar indirin
cd $HOME
rm -f libwasmvm.x86_64.so
wget https://github.com/LumeraProtocol/lumera/releases/download/v1.8.4/lumera_v1.8.4_linux_amd64.tar.gz
tar xzvf lumera_v1.8.4_linux_amd64.tar.gz
sudo mv libwasmvm.x86_64.so /usr/lib/
```

## 📚 Ek Kaynaklar

- **Changelog:** https://github.com/LumeraProtocol/lumera/blob/master/CHANGELOG.md
- **Release Notes:** https://github.com/LumeraProtocol/lumera/releases/tag/v1.8.4
- **Official Docs:** https://docs.lumera.network/
- **Discord:** https://discord.gg/lumera
- **Telegram:** https://t.me/lumera

## ⚡ Hızlı Komutlar

```bash
# Mevcut versiyon
lumerad version

# Block height
lumerad status 2>&1 | jq .SyncInfo.latest_block_height

# Sync durumu
lumerad status 2>&1 | jq .SyncInfo.catching_up

# Validator durumu
lumerad query staking validator $(lumerad keys show wallet --bech val -a)

# Node logları
sudo journalctl -u lumerad -f

# Servis restart
sudo systemctl restart lumerad

# Servis durumu
sudo systemctl status lumerad
```

## ✅ Upgrade Checklist

- [ ] libwasmvm v3.0.0-ibc2.0 kuruldu
- [ ] Checksum doğrulandı
- [ ] lumerad v1.8.4 binary hazırlandı
- [ ] Cosmovisor upgrade dizini oluşturuldu (eğer kullanılıyorsa)
- [ ] Node logları takip ediliyor
- [ ] Yedekler alındı
- [ ] Upgrade height biliniyor: 2270000
- [ ] ETA not edildi: 2025-11-12 · 15:39:40 UTC

---

**Hazırlayan:** OshVanK  
**Tarih:** November 2025  
**Lumera Network - Aurora Halo Δ Upgrade**

#Lumera #Mainnet #Upgrade #AuroraHaloΔ #v1.8.4
