@ECHO OFF

PUSHD %~dp0

CALL build.bat

robocopy _site ..\saasan.github.io * /MIR /XD mobamas-dojo .git .sass-cache /XF .gitattributes .gitignore /XA:SH

POPD
PAUSE
