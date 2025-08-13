#!/bin/bash
set -e  # exit if any command fails

# Update and install prerequisites
apt-get update -y
apt-get install -y --no-install-recommends wget gnupg unzip

# Install Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
apt-get update -y
apt-get install -y --no-install-recommends google-chrome-stable

# Install ChromeDriver
CHROME_VERSION=$(google-chrome --version | grep -oP "\d+\.\d+\.\d+")
DRIVER_VERSION=$(wget -qO- "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_${CHROME_VERSION%%.*}")
wget -O /tmp/chromedriver.zip "https://storage.googleapis.com/chrome-for-testing-public/${DRIVER_VERSION}/linux64/chromedriver-linux64.zip"
unzip /tmp/chromedriver.zip -d /usr/local/bin/

# Optional delay to avoid SCM container restart conflict
sleep 5

# Run Streamlit
exec streamlit run app.py --server.port=$PORT --server.address=0.0.0.0
