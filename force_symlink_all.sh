#!/bin/sh

cd ./HOME || exit
for TARGET in $(find . -type f); do
  echo ${HOME}/${TARGET#./}
  ln -sf $(realpath ${TARGET}) ${HOME}/${TARGET#./}
done
