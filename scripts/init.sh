#!/bin/bash

echo export DB_HOST="mongodb://54.54.3.82:27017/posts" | sudo tee -a /etc/profile
. /etc/profile
cd /home/ubuntu/app/app/
sudo -E npm install
sudo -E pm2 start app.js
