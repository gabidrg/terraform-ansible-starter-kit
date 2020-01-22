#cloud-config
ssh_pwauth: True
manage_etc_hosts: true
users:
  - name: ${username}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    primary_group: ${usergroup}
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    passwd: changeme
    ssh-authorized-keys:
      - ${publickey}
chpasswd:
  list: |
    ${username}:${userpwd}
  expire: False
  