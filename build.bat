@ECHO OFF
set LANG=ja_JP.UTF-8

%~d0
PUSHD %~dp0

SETLOCAL
SET RUBYOPT=-EUTF-8
SET JEKYLL_ENV=production
CALL jekyll build --source _source --trace
ENDLOCAL

robocopy _site ..\saasan.github.io * /MIR /XD mobamas-dojo .git .sass-cache /XF .gitattributes .gitignore /XA:SH

POPD
PAUSE
