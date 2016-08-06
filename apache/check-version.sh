#!/bin/bash

apt-cache madison apache2 | tail -n 1 | awk '{print $3;}'
