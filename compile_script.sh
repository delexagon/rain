#!/bin/sh
mkdir -p todir
rm todir/*
find | grep /src/ | grep .nc | cut -c3- | sed "s/\/[^\/]*$/ \0/g" | sed "s/ \// /g" | xargs -l bash -c 'python3 donewc.py $1 $0 todir'
python3 donewc.py main.c src todir
gcc -g todir/*.c
