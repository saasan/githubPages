@ECHO OFF
%~d0
PUSHD %~dp0

IF "%1" EQU "release" (
  CALL compass compile -e production --force
) ELSE (
  CALL compass compile -e development --force
)

POPD
