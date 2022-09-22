#!/bin/sh
mkdir -p todir
rm todir/*
find | grep /src/ | grep .nc | cut -c3- | sed "s/\/[^\/]*$/ \0/g" | sed "s/ \// /g" | xargs -l bash -c 'python3 improved_c.py $1 $0 todir'
python3 improved_c.py main.c src todir
gcc todir/*.c
