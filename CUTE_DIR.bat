@echo off
COLOR 8
FOR /L %%i in (1,1,15) DO echo Writing to Log File "%homedrive%\Users\%username%\Desktop\log.txt" in 15^(%%i^) Sec..^(^( CLOSE TO AVOID ^)^) & TIMEOUT 1 >NUL & CLS
SETLOCAL ENABLEDELAYEDEXPANSION
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
for /f "delims=" %%a in ('dir') do set /a counter+=1
set /a total=counter-5
set /a counter=0
for /f "skip=4 delims=" %%a in ('dir') do (if !counter! GEQ !total! (goto here)) & set /a counter+=1 &  for /f "tokens=1,2,3,4 delims= " %%b in ("%%a") do set dt=%%b & echo. & (set filename=%%a& set filename=!filename:~%INDEX%,200!)&(if "%%e"=="<DIR>" (set /a DIR=0) else (set /a DIR=1))&powershell -c "$str = (Get-date).Tostring('%str%');$number = (Get-date $str)-(Get-date !dt!);$number = $number.Days;$dir = '!dir!';if ($dir -eq 0) {write-host -NoNewline '<DIR>'};if ($number -gt 7) { write-host -NoNewline \"`t`t`t`t: $number Day Old\" } else { Write-Host -NoNewline \"`t`t`t`t:FRESH      \" };write-host  \"`t`t`t`t`t:!filename!:\" " >>"%homedrive%\Users\%username%\Desktop\log.txt"  & echo Echoing File (!counter!) of !total!

:here
echo Files are Ready! Open log.txt on Desktop.