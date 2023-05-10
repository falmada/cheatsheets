# SSH agent for protected keys

If you have a VM shared with many users, and you have SSH keys, those should be password protected. To avoid the hassle of typing it on every command, you can use a ssh-agent to store it for your session.

```
# Add on ~/.bashrc
if [ $(ps ax | grep [s]sh-agent | wc -l) -gt 0 ] ; then
    echo "ssh-agent is already running"
	export SSH_AUTH_SOCK=$(find /tmp -name "agent.*" -type s -user $(whoami) 2>/dev/null)
else
    eval $(ssh-agent -s)
    if [ "$(ssh-add -l)" == "The agent has no identities." ] ; then
        ssh-add ~/.ssh/id_rsa
    fi
fi
```

# Enable root login

Run this
```
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config
systemctl restart sshd
```