@ECHO OFF
set LANG=ja_JP.UTF-8

%~d0
PUSHD %~dp0

CALL jekyll build --source _source --trace --watch --incremental

POPD
PAUSE
