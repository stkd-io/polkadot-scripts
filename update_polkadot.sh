#!/bin/bash
backup_location=/root/bak
ver=$(polkadot --version | cut -c 10-15)

mkdir -p $backup_location
cp /usr/bin/polkadot $backup_location/polkadot$ver

apt update
systemctl stop polkadot.service

apt install polkadot

systemctl restart polkadot.service
journalctl -u polkadot.service -ef
