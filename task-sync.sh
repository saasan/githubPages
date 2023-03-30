#!/bin/bash

rsync -av _site/ ../saasan.github.io/ --exclude=.git/ --delete
