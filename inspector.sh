#!/bin/bash

wget https://inspector-agent.amazonaws.com/linux/latest/install
sudo bash install
sudo /etc/init.d/awsagent start
sudo /opt/aws/awsagent/bin/awsagent status