# Lumera v1.8.4 Upgrade - Hızlı Başlangıç

## ⚡ Tek Komut ile Upgrade

### Otomatik Script ile (Önerilen)

```bash
wget -O upgrade_v1.8.4.sh https://raw.githubusercontent.com/Edsny1/Lumera-Mainnet-Setup/refs/heads/Edsny/upgrade_v1.8.4.sh && chmod +x upgrade_v1.8.4.sh && ./upgrade_v1.8.4.sh
```

### Manuel Upgrade (Cosmovisor Kullanmayanlar)

```bash
# 1. libwasmvm güncelle
cd $HOME
wget https://github.com/LumeraProtocol/lumera/releases/download/v1.8.4/lumera_v1.8.4_linux_amd64.tar.gz
tar xzvf lumera_v1.8.4_linux_amd64.tar.gz
sudo mv libwasmvm.x86_64.so /usr/lib/

# 2. Checksum doğrula
wget https://github.com/CosmWasm/wasmvm/releases/download/v3.0.0-ibc2.0/checksums.txt
sha256sum -c checksums.txt | grep libwasmvm.x86_64.so

# 3. Binary güncelle
chmod +x lumerad
mv lumerad $HOME/go/bin/

# 4. Versiyon kontrol et
lumerad version  # Çıktı: 1.8.4

# 5. Node restart
sudo systemctl restart lumerad
```

### Cosmovisor ile Upgrade

```bash
# 1. libwasmvm güncelle
cd $HOME
wget https://github.com/LumeraProtocol/lumera/releases/download/v1.8.4/lumera_v1.8.4_linux_amd64.tar.gz
tar xzvf lumera_v1.8.4_linux_amd64.tar.gz
sudo mv libwasmvm.x86_64.so /usr/lib/

# 2. Checksum doğrula
wget https://github.com/CosmWasm/wasmvm/releases/download/v3.0.0-ibc2.0/checksums.txt
sha256sum -c checksums.txt | grep libwasmvm.x86_64.so

# 3. Cosmovisor upgrade klasörü oluştur
mkdir -p $HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin

# 4. Binary kopyala
chmod +x lumerad
cp lumerad $HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin/

# 5. Versiyon kontrol et
$HOME/.lumera/cosmovisor/upgrades/v1.8.4/bin/lumerad version  # Çıktı: 1.8.4

# 6. Otomatik upgrade bekleyin (Height: 2270000)
```

## 📊 Upgrade Bilgileri

| Parametre | Değer |
|-----------|-------|
| **Upgrade Height** | 2270000 |
| **ETA** | 2025-11-12 · 15:39:40 UTC |
| **Versiyon** | v1.8.4 |
| **Upgrade Adı** | Aurora Halo Δ |

## ✅ Kontrol Komutları

```bash
# Mevcut versiyon
lumerad version

# Block height
lumerad status 2>&1 | jq .SyncInfo.latest_block_height

# Sync durumu
lumerad status 2>&1 | jq .SyncInfo.catching_up

# Logları izle
sudo journalctl -u lumerad -f

# Servis durumu
sudo systemctl status lumerad

# Node restart
sudo systemctl restart lumerad
```

## ⚠️ ÖNEMLİ NOTLAR

1. **libwasmvm v3.0.0-ibc2.0 zorunlu!**
   - Bu adım atlanırsa node panic verecektir
   
2. **Checksum doğrulaması önemli**
   - Güvenlik için mutlaka kontrol edin

3. **Cosmovisor kullanıyorsanız**
   - Otomatik geçiş yapacak, bekleyin
   - Manuel restart gerekmez

4. **Manuel upgrade yapıyorsanız**
   - Upgrade height'a ulaştığında node restart gerekli
   - Binary'nin v1.8.4 olduğundan emin olun

## 🔥 Hızlı Sorun Giderme

### libwasmvm Panic
```bash
sudo mv libwasmvm.x86_64.so /usr/lib/
sudo systemctl restart lumerad
```

### Versiyon Doğrulama
```bash
lumerad version  # Beklenen: 1.8.4
```

### Upgrade Height Kontrolü
```bash
# Mevcut height
lumerad status 2>&1 | jq .SyncInfo.latest_block_height

# Kalan block sayısı
echo $((2270000 - $(lumerad status 2>&1 | jq -r '.SyncInfo.latest_block_height')))
```

## 📚 Detaylı Döküman

Detaylı upgrade rehberi için: [UPGRADE_v1.8.4.md](UPGRADE_v1.8.4.md)

## 🆘 Destek

- **Discord:** https://discord.gg/lumera
- **Telegram:** https://t.me/lumera
- **GitHub:** https://github.com/LumeraProtocol/lumera

---

**Hazırlayan:** OshVanK  
**GitHub:** [@Edsny1](https://github.com/Edsny1)
