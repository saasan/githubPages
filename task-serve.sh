#!/bin/bash

curl https://raw.githubusercontent.com/saasan/PSO2Utility/master/README.md -o _source/software/pso2utility/README.md
curl https://raw.githubusercontent.com/saasan/PSO2Utility/master/CHANGELOG.md -o _source/software/pso2utility/CHANGELOG.md
curl https://raw.githubusercontent.com/saasan/prisc/master/README.md -o _source/software/prisc/README.md

docker run \
    --rm \
    --env TZ=Asia/Tokyo \
    --volume=$PWD:/srv/jekyll \
    -it \
    -p 4000:4000 \
    jekyll/jekyll \
    jekyll serve --source _source --drafts
