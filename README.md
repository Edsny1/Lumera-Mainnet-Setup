# Lumera Network Mainnet Kurulum Scripti

![Lumera](https://img.shields.io/badge/Lumera-Mainnet-blue)
![Cosmovisor](https://img.shields.io/badge/Cosmovisor-Enabled-green)
![Go](https://img.shields.io/badge/Go-1.23.5-00ADD8)

Bu script, Lumera Network mainnet node kurulumunu otomatikleştiren kapsamlı bir araçtır. Cosmovisor desteği ile birlikte gelir ve kullanıcı dostu bir menü arayüzü sunar.

## 🌟 Özellikler

- ✅ Otomatik Go versiyon kontrolü ve kurulumu
- ✅ Cosmovisor ile otomatik upgrade desteği
- ✅ Otomatik snapshot indirme ve uygulama
- ✅ Çoklu dil desteği (Türkçe/English)
- ✅ İnteraktif menü sistemi
- ✅ Cüzdan yönetimi (oluşturma/içe aktarma)
- ✅ Validator oluşturma ve yönetimi
- ✅ Token işlemleri (delege/transfer)
- ✅ Real-time log görüntüleme
- ✅ Sync durumu kontrolü

## 📋 Sistem Gereksinimleri

### Minimum Gereksinimler
- **CPU:** 4 Core
- **RAM:** 8 GB
- **Disk:** 200 GB SSD
- **İşletim Sistemi:** Ubuntu 20.04 veya üzeri

### Önerilen Gereksinimler
- **CPU:** 8 Core
- **RAM:** 16 GB
- **Disk:** 500 GB NVMe SSD
- **İşletim Sistemi:** Ubuntu 22.04 LTS

## 🚀 Hızlı Başlangıç

### Tek Komut ile Kurulum

```bash
wget -O lumera-setup.sh https://raw.githubusercontent.com/Edsny1/Lumera-Mainnet-Setup/refs/heads/Edsny/lumera-setup.sh && chmod +x lumera-setup.sh && ./lumera-setup.sh
```

## 📝 Detaylı Kurulum Adımları

### 1. Script İndirme

```bash
# Script'i indirin
wget https://raw.githubusercontent.com/Edsny1/Lumera-Mainnet-Setup/refs/heads/Edsny/lumera-setup.sh

# Çalıştırma izni verin
chmod +x lumera-setup.sh

# Script'i çalıştırın
./lumera-setup.sh
```

### 2. Dil Seçimi

Script başladığında dil seçimi yapmanız istenecektir:
- `1` - English
- `2` - Türkçe

### 3. Ana Menü

Kurulum tamamlandıktan sonra aşağıdaki menü seçeneklerini göreceksiniz:

```
╔════════════════════════════════════════╗
║          ANA MENÜ / MAIN MENU          ║
╚════════════════════════════════════════╝

1)  Kurulum Yap / Install Node
2)  Sync Durumu Kontrol Et / Check Sync Status
3)  Logları Görüntüle / View Logs
4)  Cüzdan Oluştur / Create Wallet
5)  Cüzdan İçe Aktar / Import Wallet
6)  Validator Oluştur / Create Validator
7)  Token Delege Et / Delegate Tokens
8)  Token Gönder / Send Tokens
9)  Bakiye Kontrol Et / Check Balance
0)  Çıkış / Exit
```

## 🔧 Kurulum Süreçleri

### Node Kurulumu (Menü 1)

Script otomatik olarak:
1. Sistem bağımlılıklarını yükler
2. Go 1.23.5 versiyonunu kontrol eder ve gerekirse yükler
3. Lumera binary'lerini indirir
4. Cosmovisor'ı kurar ve yapılandırır
5. Node'u initialize eder
6. Genesis ve addrbook dosyalarını indirir
7. Snapshot'ı indirir ve uygular
8. Systemd servisi oluşturur ve başlatır

### Cüzdan İşlemleri

#### Yeni Cüzdan Oluşturma (Menü 4)
```bash
# Script içinden menü seçeneğini kullanın
# Cüzdan ismi girin
# Mnemonic kelimelerinizi güvenli bir yere kaydedin!
```

#### Mevcut Cüzdanı İçe Aktarma (Menü 5)
```bash
# Script içinden menü seçeneğini kullanın
# Cüzdan ismi girin
# Mnemonic kelimelerinizi girin
```

### Validator Oluşturma (Menü 6)

Validator oluştururken aşağıdaki bilgileri girmeniz istenecektir:

- **Cüzdan İsmi:** Validator için kullanılacak cüzdan
- **Moniker:** Validator ismi
- **Identity:** Keybase kimlik numarası (opsiyonel)
- **Website:** Web siteniz (opsiyonel)
- **Security Contact:** İletişim e-postası
- **Details:** Validator açıklaması
- **Commission Rate:** Komisyon oranı (örn: 0.05 = %5)
- **Max Rate:** Maksimum komisyon oranı (örn: 0.20 = %20)
- **Max Change Rate:** Maksimum değişim oranı (örn: 0.01 = %1)
- **Min Self Delegation:** Minimum self delegasyon
- **Amount:** Stake miktarı (örn: 1000000ulume)

## 🔍 Yararlı Komutlar

### Node Durumu
```bash
# Servis durumu
sudo systemctl status lumerad

# Logları görüntüle
sudo journalctl -u lumerad -f

# Node bilgileri
lumerad status 2>&1 | jq
```

### Cüzdan Komutları
```bash
# Cüzdanları listele
lumerad keys list

# Cüzdan bakiyesi
lumerad query bank balances $(lumerad keys show CUZDAN_ADI -a)

# Cüzdan adresini göster
lumerad keys show CUZDAN_ADI -a
```

### Validator Komutları
```bash
# Validator bilgileri
lumerad query staking validator $(lumerad keys show CUZDAN_ADI --bech val -a)

# Aktif validator seti
lumerad query staking validators --limit 1000 -o json | jq -r '.validators[] | select(.status=="BOND_STATUS_BONDED") | [.operator_address, .description.moniker, .status] | @csv' | column -t -s','

# Jail durumundan çıkış
lumerad tx slashing unjail --from CUZDAN_ADI --chain-id lumera-mainnet-1 --gas auto --gas-adjustment 1.4 --fees 500ulume -y
```

## 🛠 Manuel Konfigürasyon

### Port Değiştirme

Script varsayılan olarak `10` portunu kullanır. Farklı bir port kullanmak isterseniz:

```bash
# .bash_profile dosyasını düzenleyin
nano ~/.bash_profile

# LUMERA_PORT değerini değiştirin
export LUMERA_PORT="20"  # Örnek: 20

# Değişiklikleri uygulayın
source ~/.bash_profile
```

### Cosmovisor Konfigürasyonu

Cosmovisor environment değişkenleri:

```bash
DAEMON_NAME=lumerad
DAEMON_HOME=$HOME/.lumera
DAEMON_ALLOW_DOWNLOAD_BINARIES=false
DAEMON_RESTART_AFTER_UPGRADE=true
UNSAFE_SKIP_BACKUP=true
```

## 📊 Monitoring

### Prometheus Metrics

Node'unuz Prometheus metrics sunmaktadır:
```
http://localhost:10660/metrics
```

### Log Seviyeleri

Log seviyesini değiştirmek için:
```bash
lumerad config log_level "info"
```

Kullanılabilir seviyeler: `debug`, `info`, `warn`, `error`

## 🔒 Güvenlik

### Güvenlik Tavsiyeleri

1. **Firewall Yapılandırması:**
```bash
# UFW aktif et
sudo ufw enable

# SSH portu
sudo ufw allow 22

# P2P portu
sudo ufw allow 10656

# RPC portu (sadece localhost)
sudo ufw allow from 127.0.0.1 to any port 10657
```

2. **Mnemonic Kelimeleri:**
   - Mnemonic kelimelerinizi asla kimseyle paylaşmayın
   - Güvenli bir yere (kağıt, şifreli USB) yedekleyin
   - Dijital ortamda saklamayın

3. **Private Key:**
   - Private key dosyalarınızı şifreleyin
   - Düzenli yedekleme yapın

## 🆘 Sorun Giderme

### Node Sync Olmuyor

```bash
# Peer sayısını kontrol edin
curl -s localhost:10657/net_info | jq -r '.result.n_peers'

# Seed/peer ekleyin
# config.toml dosyasını düzenleyin
nano ~/.lumera/config/config.toml
```

### Disk Doldu

```bash
# Pruning ayarlarını kontrol edin
cat ~/.lumera/config/app.toml | grep pruning

# Log dosyalarını temizleyin
sudo journalctl --vacuum-time=3d
```

### Servis Başlamıyor

```bash
# Hata loglarını kontrol edin
sudo journalctl -u lumerad -n 100

# Binary versiyonunu kontrol edin
lumerad version

# Konfigürasyonu doğrulayın
lumerad validate-genesis
```

## 📚 Ek Kaynaklar

- **Resmi Dökümanlar:** [Lumera Docs](https://docs.lumera.network/)
- **Discord:** [Lumera Discord](https://discord.gg/lumera)
- **Explorer:** [Lumera Explorer](https://explorer.lumera.network/)
- **Telegram:** [Lumera Telegram](https://t.me/lumera)

## 🤝 Katkıda Bulunma

Bu projeye katkıda bulunmak isterseniz:

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Branch'e push edin (`git push origin feature/AmazingFeature`)
5. Pull Request açın

## 📜 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 👨‍💻 Geliştirici

**OshVanK**

- Twitter: [@oshvank](https://twitter.com/oshvank)
- GitHub: [@Edsny1](https://github.com/Edsny1)

## ⭐ Destek

Bu projeyi faydalı bulduysanız yıldız vermeyi unutmayın!

---

**Not:** Bu script topluluk tarafından geliştirilmiştir ve resmi Lumera takımı tarafından desteklenmemektedir. Kullanımdan kaynaklanan sorunlardan script geliştiricisi sorumlu değildir.
