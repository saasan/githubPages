@ECHO OFF
SETLOCAL

PUSHD %~dp0

SET LANG=ja_JP.UTF-8
SET RUBYOPT=-EUTF-8
SET JEKYLL_ENV=production
CALL jekyll build --source _source --config _source/_config.yml,_source/_config-production.yml

POPD
PAUSE
