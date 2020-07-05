#!/bin/sh


FOLDERS=$(ls -lh|grep -E "^d"|awk '{print $9}')

for folder in ${FOLDERS}
do
	cd $folder
	sh build.sh
	cd ..
done