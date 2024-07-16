#!/bin/bash
#To intall stress tool on amazon linux
sudo yum update -y
sudo yum install stress -y

#To install stress tool on ubuntu
sudo apt update -y
sudo apt install stress -y  

# Verify the installation by checking the stress version:
stress --version

#To run and stop the stress
# Use --timeout to stop it automatically e.g. 
stress --cpu 4 --timeout 60s