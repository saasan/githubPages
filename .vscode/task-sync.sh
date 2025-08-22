#!/bin/bash

rsync -av _site/ ../saasan.github.io/ --exclude=.git/ --exclude=playground/noreal-koma/merged.json --delete
