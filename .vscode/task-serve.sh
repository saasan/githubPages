#!/bin/bash

curl https://raw.githubusercontent.com/saasan/PSO2Utility/master/README.md -o _source/_posts/PSO2Utility-README.md
curl https://raw.githubusercontent.com/saasan/PSO2Utility/master/CHANGELOG.md -o _source/_posts/PSO2Utility-CHANGELOG.md
curl https://raw.githubusercontent.com/saasan/prisc/master/README.md -o _source/_posts/prisc-README.md

bundle exec jekyll serve --source _source --drafts
