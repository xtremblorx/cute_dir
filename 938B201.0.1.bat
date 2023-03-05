SETLOCAL ENABLEDELAYEDEXPANSION
@echo off
:BACK
ECHO PLEASE WRITE DIR PARAMETERS SEPARATED BY SPACE:
SET /P PARAM=
IF NOT DEFINED PARAM (SET PARAM=)
 
FOR /f %%y IN ("%PARAM%") DO SET SETTEST=%%y 


IF NOT DEFINED SETTEST (ECHO NOT DEFINED PARAMETER :-SETTING /o-d as DEFAULT&SET PARAM=/o-d)

SET ABOM=/w /W /b /B
for %%X in (%ABOM%) DO ( FOR /F %%A IN ('ECHO %PARAM% ^| find "%%X"') DO SET SEARCH=%%A & IF DEFINED SEARCH ( ECHO /b /w PARAMETER NOT ALLOWED. PRESS A KEY TO START A NEW& PAUSE & START CMD /c CUTE_DIR.BAT & EXIT ) )
COLOR 8
CLS

for /f "delims=*" %%i in ('cd') DO set currentdir=%%i
:back
for /f "delims=" %%i in ('dir /b') do set rootfilename=%%i& goto next
if NOT DEFINED rootfilename ( cd \ & goto back )
:next



for /f "delims=" %%a in ('dir ^| find "%rootfilename%"') do for /F %%b in ('python -c "s1 = '%%a';s2 = '%rootfilename%';print(s1.index(s2))"') do set /a INDEX=%%b   & goto skip
:skip
cd %currentdir%
for /f "tokens=3 delims= " %%a in ('reg query "hkey_current_user\control panel\international" /v sshortdate ^| find /i "sshortdate"') do set str=%%a

for /f %%a in ('powershell -c "(Get-date).Tostring('%str%')"') do set datz=%%a

set /a counter=0
for /f "delims=" %%a in ('dir !PARAM!') do set /a counter+=1
set /a total=counter-5
set /a counter=0
rem set /a dup=0
ECHO dir %PARAM% 
for /f "skip=4 delims=" %%a in ('dir %PARAM%') do (if !counter! GEQ !total! (goto here)) & set /a counter+=1 & echo|set /p=.&  for /f "tokens=1,2,3,4 delims= " %%b in ("%%a") do set dt=%%b & (set filename=%%a& set filename=!filename:~%INDEX%,200!)&(if "%%e"=="<DIR>" (set /a DIR=0) else (set /a DIR=1))&powershell -c "$str = (Get-date).Tostring('%str%');$number = (Get-date $str)-(Get-date !dt!);$number = $number.Days;$dir = '!dir!';if ($number -eq 0) { write-host  -nonewline \"`t`t`t`t`t:Today\";write-host -nonewline  \":!filename!:\";write-host} " 
:here
echo. & echo.  --Total-File^(s^)---^>!TOTAL!
PAUSE
