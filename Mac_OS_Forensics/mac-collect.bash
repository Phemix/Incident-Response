#!/bin/bash
echo "Hello World"

if [ $EUID -ne 0 ]
  then echo "You must elevate privileges to root to run this script" 
  exit 
fi


# make collection directory
today=$(date +"%m_%d_%Y")
host=$(hostname)
mkdir mac-collection_folder-$today-$host



# System Information
mkdir "mac-collection_folder-$today-$host"/"System Information"
date > "mac-collection_folder-$today-$host"/"System Information"/date.txt
uname -a > "mac-collection_folder-$today-$host"/"System Information"/version.txt
hostname > "mac-collection_folder-$today-$host"/"System Information"/hostname.txt
lsmod > "mac-collection_folder-$today-$host"/"System Information"/listmodules.txt



# Login Artifacts
mkdir "mac-collection_folder-$today-$host"/"Network Artifacts"
#cd mac-collection_folder_$today_$hostname/"Network Artifacts"
last -a > "mac-collection_folder-$today-$host"/"Network Artifacts"/lastlogins.txt
lastb > "mac-collection_folder-$today-$host"/"Network Artifacts"/failedlogins.txt
w > "mac-collection_folder-$today-$host"/"Network Artifacts"/w.txt


# Account Artifacts
mkdir "mac-collection_folder-$today-$host"/"Account Artifacts"
cat /etc/passwd  > "mac-collection_folder-$today-$host"/"Account Artifacts"/etcpassword.txt
cat /etc/shadow > "mac-collection_folder-$today-$host"/"Account Artifacts"/etcshadow.txt
cat /etc/sudoers > "mac-collection_folder-$today-$host"/"Account Artifacts"/etcsudoers.txt
cat /etc/sudoers.d/* > "mac-collection_folder-$today-$host"/"Account Artifacts"/etcsudoersd.txt
compgen -u > "mac-collection_folder-$today-$host"/"Account Artifacts"/compgenuseroutput.txt



