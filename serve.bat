@ECHO OFF
SETLOCAL

PUSHD %~dp0

SET LANG=ja_JP.UTF-8
SET RUBYOPT=-EUTF-8
CALL jekyll serve --source _source --drafts --port 80

POPD
PAUSE
