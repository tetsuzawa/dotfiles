#!/bin/sh

cd ./HOME || exit
for TARGET in $(find . -type f); do
  echo $(realpath $TARGET)
  ln -sf $(realpath $TARGET) $(realpath $HOME/$TARGET)
done
