@echo off
SETLOCAL 
set TGT_DIR=dist
echo START BUILD > atf_dist.log
echo|set /p=Cleaning up.
rmdir /S /Q %TGT_DIR%                                >> atf_dist.log 2>&1 & echo|set /p=.
mkdir %TGT_DIR%                                      >> atf_dist.log 2>&1 & echo|set /p=.
echo done
echo|set /p=Copying Docs and tools.
cp -vpPR doc\* %TGT_DIR%                                    >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR tools\android\* %TGT_DIR%                          >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR tools\bin\* %TGT_DIR%                              >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR generate_API_doc.cmd %TGT_DIR%                     >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR show_versions.cmd %TGT_DIR%                        >> atf_dist.log 2>&1 & echo|set /p=.
cp -vp tools\templates\.gitignore %TGT_DIR%\.gitignore      >> atf_dist.log 2>&1 & echo|set /p=.
echo done
echo|set /p=Copying ATF LIBs.
cp -vpPR src\py\* %TGT_DIR%                          >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR src\bin\* %TGT_DIR%                         >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR src\test\atf\tests\templates\* %TGT_DIR%    >> atf_dist.log 2>&1 & echo|set /p=.
REM no custom code into dist
REM currently needed due to gmail POs
REM cp -vpPR src\cstm\* %TGT_DIR%                        >> atf_dist.log 2>&1 & echo|set /p=.
del /S %TGT_DIR%\src\*.c                             >> atf_dist.log 2>&1 & echo|set /p=.
del /S %TGT_DIR%\src\*.pyc                           >> atf_dist.log 2>&1 & echo|set /p=.
echo done
echo Running sanity Check with template test suite
cd dist
python -m robot.run -v DEMO_KEY:C60DD7B317E786649AAA6A5695D974B7 -P src\bin -P src\py src\test\atf\tests\templates\*.robot
IF %ERRORLEVEL% NEQ 0 (
  cd ..
  echo ERROR - Sanity check failed, exiting...
  exit /B 2
)
cd ..
echo|set /p=Preparing release tests.
cp -vpPR runReleaseTests.cmd %TGT_DIR%              >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR src\test\atf\common\py_* %TGT_DIR%         >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR src\test\atf\common\device_*.py %TGT_DIR%  >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR src\test\atf\common\*Help*.py %TGT_DIR%    >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR src\test\atf\common\dumm* %TGT_DIR%        >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR src\test\atf\common\global_* %TGT_DIR%     >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR src\test\atf\common\browser_conf*.py %TGT_DIR%  >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR src\tools\* %TGT_DIR%                      >> atf_dist.log 2>&1 & echo|set /p=.
cp -vpPR data\* %TGT_DIR%                           >> atf_dist.log 2>&1 & echo|set /p=.
cd dist                                             >> atf_dist.log 2>&1 & echo|set /p=.
echo done
echo Running release tests
set  EXCL=-e WIP -e src_cy -e dummyCnt
call runReleaseTests.cmd all
echo|set /p=Finishing up.
rm -vfr src\tools                                   >> atf_dist.log 2>&1 & echo|set /p=.
rm -vfr data                                        >> atf_dist.log 2>&1 & echo|set /p=.
rm -vfr src\test\atf\common                         >> atf_dist.log 2>&1 & echo|set /p=.
cd ..                                               >> atf_dist.log 2>&1 & echo|set /p=.
echo done
