@echo off

SETLOCAL 
SET PYTHONPATH=src\bin;src\py;src\cstm
python src\py\getVersions.py

echo.
echo Runtime:
echo --------
for /f %%i in ('wmic OS get OSArchitecture ^| head -2 ^| tail -1') do set WIN_ARCH=%%i
for /f "delims=xxx" %%i in ('wmic OS get Caption ^| head -2 ^| tail -1') do set WIN_VER=%%i
echo %WIN_VER%(%WIN_ARCH%)
rem for /f "delims=xxx" %%i in ('python -c "import sys;print sys.version"') do set PY_V=%%i
rem echo Python %PY_V%
python -m robot.run --version

ENDLOCAL