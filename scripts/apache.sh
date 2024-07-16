#!/bin/bash

# Update and upgrade system
yes | sudo apt update 
yes | sudo apt upgrade 

# Install Apache
yes | sudo apt install httpd
sudo systemctl enable httpd
sudo systemctl start httpd
yes | sudo apt install apache2 
sudo systemctl enable apache2
sudo systemctl start apache2
yes | sudo apt install curl

# Get the AMI ID and write it to index.html
AMI_ID=$(wget -q -O - http://169.254.169.254/latest/meta-data/ami-id || die \"wget ami-id has failed: $?\")
echo "<html><body><h1>AMI ID: ${AMI_ID}</h1></body></html>" > /var/www/html/index.html

# Get the user data and write it to users.html
USER_DATA=$(curl -s http://169.254.169.254/latest/user-data)
echo "<html><body><pre>${USER_DATA}</pre></body></html>" > /var/www/html/users.html

# Restart Apache to ensure changes are applied
sudo systemctl restart apache2
