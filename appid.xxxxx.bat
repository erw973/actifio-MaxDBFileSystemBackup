@echo off
REM Don't remove the echo off above or the UDSAgent.log get silly comments

REM THE SECTION BELOW NEEDS CUSTOMIZATION
REM THE INFO BELOW IS FAIRLY SELF APPARENT, SHAME ON ME FOR MAKING YOU ENTER A PASSWORD IN THE CLEAR
@set DATABASE=MaxDB
@set USERNAME=DBADMIN
@set PASSWORD=Passw0rd9
@set PATH=C:\Program Files\sdb\MaxDB\pgm
REM THE SECTION ABOVE NEEDS CUSTOMIZATION

REM  This is where the script is driven by the connector supplying one parm,   you can use this for testing the script
set TASK=%1
echo %TASK%
if %TASK% equ init goto :handle_init
if %TASK% equ fini goto :handle_fini
if %TASK% equ freeze goto :handle_freeze
if %TASK% equ thaw goto :handle_thaw
if %TASK% equ abort goto :handle_abort
echo Either no valid task was given for the script to run, use init, fini, freeze, thaw or abort
goto :eof

:handle_init
echo Got an init command.  Nothing to do
goto :end

:handle_fini
echo Got an fini command.  Nothing to do
goto :end

:handle_freeze
echo ------------------------------------------ 
echo About to freeze %DATABASE% due to freeze request
echo ***** log active state 
dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c show active 
echo ***** issue suspend 
dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c util_execute suspend logwriter 
echo ***** log active state after suspend 
dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c show active 
goto :end

:handle_thaw
echo ------------------------------------------ 
echo About to thaw %DATABASE% due to thaw request
echo ***** log active state 
dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c show active 
echo ***** issue resume 
dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c util_execute resume logwriter 
echo ***** log active state after resume 
dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c show active 
goto :end

:handle_abort
echo ------------------------------------------ 
echo About to thaw %DATABASE% due to abort
echo Date and time: %date% %time% 
echo ***** log active state 
dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c show active 
echo ***** issue resume 
dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c util_execute resume logwriter 
echo ***** log active state after resume 
dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c show active 
goto :end
:end
echo Done processing commands