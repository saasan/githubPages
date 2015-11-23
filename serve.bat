@ECHO OFF
set LANG=ja_JP.UTF-8

%~d0
PUSHD %~dp0

CALL jekyll serve --source _source --trace --incremental

POPD
PAUSE
