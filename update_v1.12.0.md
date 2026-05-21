
```bash
lumerad tx gov vote 12 yes --from wallet --chain-id lumera-mainnet-1 --gas-prices 0.1ulume --gas auto --gas-adjustment 1.6 -y
```

```bash
cd $HOME
```

```bash
wget https://github.com/LumeraProtocol/lumera/releases/download/v1.12.0/lumera_v1.12.0_linux_amd64.tar.gz
```

```bash
tar -xvzf lumera_v1.12.0_linux_amd64.tar.gz
```

```bash
chmod +x lumerad
```

```bash
mkdir -p $HOME/.lumera/cosmovisor/upgrades/v1.12.0/bin
```

```bash
mv $HOME/lumerad $HOME/.lumera/cosmovisor/upgrades/v1.12.0/bin/lumerad
```

```bash
ls -l $HOME/.lumera/cosmovisor/upgrades/v1.12.0/bin/
```

**Beklenen Çıktı:**
```
-rwxr-xr-x 1 root root ... lumerad
```

**Değişiklikler:**
- v1.11.1 → v1.12.0
