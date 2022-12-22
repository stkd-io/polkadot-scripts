#!/bin/bash
#Useage ./check_sessionKeys.sh StashAccount
#This will check if the local machine is the validator for a wallet.

#checks if jq is installed
#https://stackoverflow.com/a/10439058
REQUIRED_PKG="jq"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi


session_key=$(curl -s http://api.paranodes.io:5000/NextKeys?address=$1)

result=$(jq -n --arg session_key "$session_key" '{id:"1", jsonrpc:"2.0", method: "author_hasSessionKeys", params:[$session_key]}' | 
    curl -s -H 'Content-Type: application/json' -d @- "http://localhost:9933" | jq -r '.result')

echo "This node is currently the validator for $1 stash: $result"
