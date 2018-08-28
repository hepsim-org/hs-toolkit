@echo off

REM ====================================
REM Batch for starting HS-IDE on Windows
REM ====================================

REM ==================================
REM SET JEHEP_HOME TO THE INSTALLATION DIRECTORY 
REM The default is the current directory
REM If you install in in some other location, set it like this 


REM current directory
set JEHEP_HOME=.
set JEHEP_HOME_PATH=%CD%
echo Current directory %JEHEP_HOME_PATH%

set MAX_JAVA_MEMORY=2048

set CMD_LINE_ARGS=
:args
if "%1"=="" goto start
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto args
echo ARGS: %CMD_LINE_ARGS%

:start
set JEHEP_JAR=%JEHEP_HOME%
set JEHEP_CLASSPATH=
if exist %JEHEP_JAR% set JEHEP_CLASSPATH=%JEHEP_JAR%

REM take first the main class
set LOCALCLASSPATH=%JEHEP_CLASSPATH%

REM link  LIBRARIES in lib directory
for %%i in ("%JEHEP_HOME%\*.jar") do call "%JEHEP_HOME%\lcp.bat" %%i

REM TAKE ALL
SET OPTJJ=-Djava.library.path=%LIBJEHEP%
set CLASSPATH=%LOCALCLASSPATH%
set LOCALCLASSPATH=


ECHO Start HS-IDE ..
java -mx%MAX_JAVA_MEMORY%m -classpath %CLASSPATH% %OPTJJ% -Djehep.home=%JEHEP_HOME%  jhepsim.Main  %CMD_LINE_ARGS%

