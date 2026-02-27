#!/bin/sh

cd ./HOME || exit
find . -type f | while IFS= read -r TARGET; do
  echo "${HOME}/${TARGET#./}"
  ln -sf "$(realpath "${TARGET}")" "${HOME}/${TARGET#./}"
done
