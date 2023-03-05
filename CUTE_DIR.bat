SETLOCAL ENABLEDELAYEDEXPANSION
@echo off
:BACK
ECHO PLEASE WRITE DIR PARAMETERS SEPARATED BY SPACE:
SET /P PARAM=
FOR %%y IN ('ECHO %PARAM%^| FINDSTR /r "[A-Za-z]"') DO SET SETTEST=%%y 
IF NOT DEFINED SETTEST (SET PARAM=/ad)
SET ABOM=/w /W /b /B
for %%X in (%ABOM%) DO ( FOR /F %%A IN ('ECHO %PARAM% ^| find "%%X"') DO SET SEARCH=%%A & IF DEFINED SEARCH ( ECHO /b /w PARAMETER NOT ALLOWED. PRESS A KEY TO START A NEW& PAUSE & START CMD /c CUTE_DIR.BAT & EXIT ) )
COLOR 8
echo.press W to change file name 
choice /c Wx /d x /t 1 >nul
set error=%errorlevel%
if %error%==2 ( goto x )
set /p save_file=
IF NOT DEFINED save_file (set save_file=log.txt)
:x
FOR /L %%i in (1,1,15) DO echo Writing to Log File "%homedrive%\Users\%username%\Desktop\!save_file!" in 15^(%%i^) Sec..^(^( CLOSE TO AVOID ^)^) & TIMEOUT 1 >NUL & CLS

for /f "delims=*" %%i in ('cd') DO set currentdir=%%i
:back
for /f "delims=" %%i in ('dir /b') do set rootfilename=%%i& goto next
if NOT DEFINED rootfilename ( cd \ & goto back )
:next
echo %rootfilename%


for /f "delims=" %%a in ('dir ^| find "%rootfilename%"') do for /F %%b in ('python -c "s1 = '%%a';s2 = '%rootfilename%';print(s1.index(s2))"') do set /a INDEX=%%b   & goto SKiP
:SKiP
cd %currentdir%
for /f "tokens=3 delims= " %%a in ('reg query "hkey_current_user\control panel\international" /v sshortdate ^| find /i "sshortdate"') do set str=%%a

for /f %%a in ('powershell -c "(Get-date).Tostring('%str%')"') do set datz=%%a

set /a counter=0
for /f "delims=" %%a in ('dir %PARAM%') do set /a counter+=1
set /a total=counter-5
set /a counter=0
for /f "skip=4 delims=" %%a in ('dir %PARAM%') do (if !counter! GEQ !total! (goto here)) & set /a counter+=1 &  for /f "tokens=1,2,3,4 delims= " %%b in ("%%a") do set dt=%%b & echo. & (set filename=%%a& set filename=!filename:~%INDEX%,200!)&(if "%%e"=="<DIR>" (set /a DIR=0) else (set /a DIR=1))&powershell -c "$str = (Get-date).Tostring('%str%');$number = (Get-date $str)-(Get-date !dt!);$number = $number.Days;$dir = '!dir!';if ($dir -eq 0) {write-host -NoNewline '<DIR>'};if ($number -gt 7) { write-host -NoNewline \"`t`t`t`t: $number Day Old\" } else { Write-Host -NoNewline \"`t`t`t`t:FRESH      \" };write-host  \"`t`t`t`t`t:!filename!:\" " >>"%homedrive%\Users\%username%\Desktop\!save_file!"  & echo Echoing File (!counter!) of !total!

:here
echo Files are Ready! Open log.txt on Desktop.
PAUSE >NUL
