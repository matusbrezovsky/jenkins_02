@echo off
SETLOCAL
for /f %%i in ('date /T ^| cut -d / -f3') do set Y=%%i
for /f %%i in ('date /T ^| cut -d / -f2') do set M=%%i
for /f %%i in ('date /T ^| cut -d / -f1') do set D=%%i
for /f %%i in ('time /T ^| cut -d : -f1') do set Hh=%%i
for /f %%i in ('time /T ^| cut -d : -f2') do set Mm=%%i
SET REPODIR=reports_%Y%%M%%D%_%Hh%%Mm%
SET TSTMP_START=%Y%%M%%D%%Hh%%Mm%
echo ########################################################################################################
echo #                                                                                                      #
echo #  Running the Demo suite (src\test\atf\tests\demo\Demo.robot)                                         #
echo #  Includes all Tests                                                                                  #
echo #                                                                                                      #
echo #  runAllDemo.cmd    : run all tests                                                                   #
echo #                                                                                                      #
echo #  runDemo.cmd       : run only tests without trace analysis                                           #
echo #  runTraceDemo.cmd  : run only tests with trace analysis                                              #
echo #                                                                                                      #
echo ########################################################################################################

echo Cleaning up screenshots from previous runs ...
rm -f screenshot*.png
echo Cleaning up results from previous runs ...
rm -f out_mss_all*.xml
@echo on
python -m robot.run -N "Demo" -e Trace_*  -e MandatoryManualSteps %NO_DEV% -v DEVELOPMENT_MODE:False -v DLGS_SKIP:True -v DLGS_SLEEP:15s -b debug_all.log  --output out_mss_all.xml  -P src\bin -P src\py src\test\atf\tests\demo\Demo.robot
@echo off
echo Re-executing failed TCs ...
@echo on
python -m robot.run -N "Demo" -e Fail*                       %NO_DEV% -v DEVELOPMENT_MODE:False -v DLGS_SKIP:True -v DLGS_SLEEP:15s -b debug_all_r.log --output out_mss_all_r.xml -R out_mss_all.xml  -P src\bin -P src\py src\test\atf\tests\demo\Demo.robot
@echo off
REM echo Re-Re-executing failed TCs ...
REM @echo on
REM python -m robot.run -N "Demo" -e Fail*                       %NO_DEV% -v DEVELOPMENT_MODE:False -v DLGS_SKIP:True -v DLGS_SLEEP:15s -b debug_all_r.log --output out_mss_all_r2.xml -R out_mss_all_r.xml  -P src\bin -P src\py src\test\atf\tests\demo\Demo.robot
REM @echo off
echo Preparing Report ...
for /f %%i in ('date /T ^| cut -d . -f3') do set Y=%%i
for /f %%i in ('date /T ^| cut -d . -f2') do set M=%%i
for /f %%i in ('date /T ^| cut -d . -f1') do set D=%%i
for /f %%i in ('time /T ^| cut -d : -f1') do set Hh=%%i
for /f %%i in ('time /T ^| cut -d : -f2') do set Mm=%%i
SET TSTMP_STOP=%Y%%M%%D%%Hh%%Mm%
python -m robot.rebot -N "Demo" --starttime %TSTMP_START% --endtime %TSTMP_STOP% -e robot-exit --tagstatexclude ok2016* --tagstatexclude r4p --tagstatexclude alias* --tagstatexclude *ManualStep* --merge out_mss_all*.xml
echo Archiving report to %REPODIR% ...
mkdir %REPODIR%
cp -fp *.html %REPODIR%
cp -fp *.xml %REPODIR%
cp -fp screensho*.png %REPODIR%
echo done
