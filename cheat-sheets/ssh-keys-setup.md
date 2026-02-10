# SSH Server Keys Setup

### Generate Public/Private Key Pair

On localhost

```bash
ssh-keygen -t ed25519
```

This will generate a private and public key

## Config the server

On the server

```bash
- create the following file (sudo):  /etc/ssh/authorized_keys
- add the public key to the authorized_keys file
- Make the following edits to the sshd_config file (sudo):
-- PermitRootLogin no
-- PubkeyAuthentication yes
-- AuthorizedKeysFile  /etc/ssh/authorized_keys
-- ChallengeResponseAuthentication no
-- PasswordAuthentication no
save and exit
- restart ssh: sudo service ssh restart
```

## Modify Terminal Startup

On the local host. Append the following script to the followiong file: bash.bashrc

```bash
# Start the SSH agent if not already running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
if [ $agent_run_state = 2 ]; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/private-key
elif [ $agent_run_state = 1 ]; then
    ssh-add ~/.ssh/private-key
fi
```

## Create an alias command

Append the following to the file: /home/brando/.bashrc

- alias sshdfw1='ssh brando@psychz-dfw1.eventec.io'
