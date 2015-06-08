@ECHO OFF
set LANG=ja_JP.UTF-8

%~d0
PUSHD %~dp0

CALL jekyll build --source _source --trace

robocopy _site ..\saasan.github.com * /MIR /XD mobamas-dojo .git .sass-cache /XF .gitattributes .gitignore /XA:SH

POPD
PAUSE
