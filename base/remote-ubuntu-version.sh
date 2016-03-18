#!/bin/bash

apt-cache madison ${SERVICE_PACKAGE} | grep 'trusty' | grep 'Packages' | head -n 1 | awk '{print $3;}'
