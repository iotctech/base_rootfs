#!/bin/bash

EXE='simplebox'
PWD=`pwd`
files=`ldd $EXE | awk '{if(match($3,"^/"))printf("%s "),$3}'`
cp $files $PWD
