#!/bin/bash

sudo -v
while true; do sudo -n true; sleep 60; done 2>/dev/null &
