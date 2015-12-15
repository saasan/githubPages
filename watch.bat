@ECHO OFF
set LANG=ja_JP.UTF-8

%~d0
PUSHD %~dp0

SETLOCAL
SET RUBYOPT=-EUTF-8
CALL jekyll build --source _source --watch --drafts
ENDLOCAL

POPD
PAUSE
