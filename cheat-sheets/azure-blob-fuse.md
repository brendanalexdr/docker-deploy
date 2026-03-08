# Azure blob fuse

## sources

- [Install BlobFuse v2 on Linux](https://learn.microsoft.com/en-us/azure/storage/blobs/blobfuse2-install?tabs=Ubuntu)

### 1. Install Blobfuse

```bash
sudo wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install fuse3 blobfuse2
```

### 2. Install the dependencies

```bash
sudo apt-get install fuse3 libfuse3-dev
```

### 3. Create config file

```bash

sudo touch /etc/fuse_azure_connection.yml
sudo nano /etc/fuse_azure_connection.yml
```

### 4. Edit config file

```bash
# Logger configuration
#logging:
  #  type: syslog|silent|base
  #  level: log_off|log_crit|log_err|log_warning|log_info|log_trace|log_debug
  #  file-path: <path where log files shall be stored. Default - '$HOME/.blobfuse2/blobfuse2.log'>

components:
  - libfuse
  - file_cache
  - attr_cache
  - azstorage


libfuse:
  attribute-expiration-sec: 120
  entry-expiration-sec: 120
  negative-entry-expiration-sec: 120

file_cache:
  path: /tmp/pgbackups
  timeout-sec: 120

attr_cache:
  timeout-sec: 120
#Required
azstorage:
  type: block
  account-name: psychzdfwdb
  container: pgbackups
  endpoint: https://psychzdfwdb.blob.core.windows.net
  mode: key
  account-key: MKTb8Uan2b/BNGng+QMgaI9LXZm9tphP5MYpoXG2qzvzQb5IWHawfmxHj2ReaC2LxkNzP4YkISCw+AStZZSNyw==
```

### 5. Create the backup directory

```bash
sudo mkdir /mnt/pgbackups
```

### 6. Now mount the volume

```bash
sudo blobfuse2 mount /mnt/pgbackups --tmp-path=/tmp/pgbackups --config-file=/etc/fuse_azure_connection.yml
```

### 7. Update Crontab config. To handle restart after reboot

```bash
crontab -e
## add the following line
@reboot sudo blobfuse2 mount /mnt/pgbackups --tmp-path=/tmp/pgbackups --config-file=/etc/fuse_azure_connection.yml
```
