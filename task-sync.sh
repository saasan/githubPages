#!/bin/bash

rsync -av _site/ ../saasan.github.io/ --exclude=mobamas-dojo/ --exclude=.git/ --delete
