#!/bin/bash

# zlib
cd 0001-zlib
git checkout .
rm zconf.h.included
cd ..

# SFML
cd 0011-SFML
git checkout .
cd ..
