#!/bin/bash

disk=$(df -h / | tail -1 | awk '{printf "%s(%s)",$3,$5}')
echo $disk
