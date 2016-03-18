#!/bin/bash

apt-cache madison ${0:-${SERVICE_PACKAGE}} | grep 'trusty' | grep 'Packages' | head -n 1 | awk '{print $3;}'
