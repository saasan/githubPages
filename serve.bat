@ECHO OFF
set LANG=ja_JP.UTF-8

%~d0
PUSHD %~dp0

START compass watch
CALL jekyll serve --watch --source source

POPD
PAUSE
