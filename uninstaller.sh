#!/bin/bash

sudo launchctl unload -w /Library/LaunchDaemons/cn.edu.scu.mentohust-for-mac.plist
sudo rm /Library/LaunchDaemons/cn.edu.scu.mentohust-for-mac.plist
sudo rm /Library/PrivilegedHelperTools/cn.edu.scu.mentohust-for-mac
sudo rm /var/run/cn.edu.scu.mentohust-for-mac.socket