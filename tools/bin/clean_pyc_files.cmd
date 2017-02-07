@echo off
SETLOCAL
SET TGT_DIR=src\
echo Deleting all compiled python (*.pyc) files in %TGT_DIR%
del /S %TGT_DIR%*.pyc
