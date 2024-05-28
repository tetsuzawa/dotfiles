#!/bin/sh

cd ./HOME || exit
for TARGET in $(find . -type f); do
  sed -i -e "s|{HOME}|${HOME}|g" ${TARGET}
done
