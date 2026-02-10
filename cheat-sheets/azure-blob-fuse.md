# Azure blob fuse

## sources

- [Install BlobFuse v1 on Linux](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-how-to-mount-container-linux?tabs=Ubuntu)

## Installing blobfuse

```bash
## create conf file
sudo touch /etc/fuse_azure_connection.cfg
sudo nano /etc/fuse_azure_connection.cfg
####
accountName psychzdfwdb
accountKey MKTb8Uan2b/BNGng+QMgaI9LXZm9tphP5MYpoXG2qzvzQb5IWHawfmxHj2ReaC2LxkNzP4YkISCw+AStZZSNyw==
containerName pgbackups
authType Key
####

sudo blobfuse /mnt/pgbackups --tmp-path=/tmp/pgbackups  --config-file=/etc/fuse_azure_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 -o nonempty
```

## Crontab config to handle restart after reboot

```bash
crontab -e
## add the following line
@reboot sudo blobfuse /mnt/pgbackups --tmp-path=/tmp/pgbackups  --config-file=/etc/fuse_azure_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 -o nonempty
```
