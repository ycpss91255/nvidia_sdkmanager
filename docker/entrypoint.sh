#!/usr/bin/env bash

# echo "hello docker!!"
sdkmanager

while pgrep -x "sdkmanager-gui" > /dev/null; do
  sleep 5
done
