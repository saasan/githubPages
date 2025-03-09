#!/bin/bash

curl https://raw.githubusercontent.com/saasan/PSO2Utility/master/README.md -o _source/_posts/PSO2Utility-README.md
curl https://raw.githubusercontent.com/saasan/PSO2Utility/master/CHANGELOG.md -o _source/_posts/PSO2Utility-CHANGELOG.md
curl https://raw.githubusercontent.com/saasan/prisc/master/README.md -o _source/_posts/prisc-README.md

JEKYLL_ENV=production bundle exec jekyll build --source _source --config _source/_config.yml,_source/_config-production.yml
