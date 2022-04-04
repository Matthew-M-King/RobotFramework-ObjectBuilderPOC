#!/bin/sh
apt-get update && apt-get install --quiet --assume-yes python3-pip unzip wget
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
apt update
apt install -y google-chrome-stable
cp requirements.txt /tmp/requirements.txt
pip install -r /tmp/requirements.txt
apt-get install -y unzip xvfb libxi6 libgconf-2-4
CHROMEDRIVER_VERSION=`wget --no-verbose --output-document - https://chromedriver.storage.googleapis.com/LATEST_RELEASE`
wget --no-verbose --output-document /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver
chmod +x /opt/chromedriver/chromedriver
ln -fs /opt/chromedriver/chromedriver /usr/local/bin/chromedriver