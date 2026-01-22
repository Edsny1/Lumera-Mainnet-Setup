
```bash
lumerad tx gov vote 8 yes --from wallet --chain-id lumera-mainnet-1 --gas-prices 0.1ulume --gas auto --gas-adjustment 1.6 -y
```

```bash
cd $HOME
```

```bash
wget https://github.com/LumeraProtocol/lumera/releases/download/v1.9.1/lumera_v1.9.1_linux_amd64.tar.gz
```

```bash
tar -xvzf lumera_v1.9.1_linux_amd64.tar.gz
```

```bash
chmod +x lumerad
```

```bash
mkdir -p $HOME/.lumera/cosmovisor/upgrades/v1.9.1/bin
```

```bash
mv $HOME/lumerad $HOME/.lumera/cosmovisor/upgrades/v1.9.1/bin/lumerad
```

```bash
ls -l $HOME/.lumera/cosmovisor/upgrades/v1.9.1/bin/
```

**Beklenen Çıktı:**
```
-rwxr-xr-x 1 root root ... lumerad
```

**Değişiklikler:**
- v1.9.0 → v1.9.1
