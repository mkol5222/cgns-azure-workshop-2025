#!/bin/bash

mkdir -p ~/.ssh

(cd linux; terraform output -raw ssh_key > ~/.ssh/linux.key)
chmod og= ~/.ssh/linux.key

(cd linux; terraform output -raw ssh_config | tee  ~/.ssh/config)

ssh linux
