@echo off
:1
if exist "%~dp0..\java\CommonFiles\Java64\JavaPortable.ini" (
echo Java is installed!
) else (
echo Installing Java...
goto getjava
)

:getjava
powershell -Command "Invoke-WebRequest https://download3.portableapps.com/portableapps/Java64/jPortable64_8_Update_241_online.paf.exe?20190321 -OutFile ..\java\jportable_online.paf.exe"
..\java\jportable_online.paf.exe
goto 1

:1a
if exist "%~dp0tuinity-paperclip.jar" (
echo Tuinity is already downloaded!
) else (
goto tutu
)

:tutu
echo Tuinity will now be downloaded
powershell -Command "Invoke-WebRequest https://ci.codemc.io/job/Spottedleaf/job/Tuinity/lastSuccessfulBuild/artifact/tuinity-paperclip.jar -OutFile tuinity-paperclip.jar"
:1b
if exist "%~dp0tuinity-paperclip.jar" (
echo Tuinity was sucessfully downloaded!
) else (
echo Tuinity was unable to be downloaded, check the link
pause
exit
)

findstr "eula=true" eula.txt>NUL
if errorlevel 1 (goto notfound) else (goto runserver)
goto :eof

:notfound
set /p accept="Accept EULA? https://www.minecraft.net/en-us/eula (y/n): "
if /i "%accept%" == "y" (goto writetrue) else (goto wellthen)
goto :eof

:writetrue
echo eula=true> eula.txt
goto runserver

:runserver
"%~dp0..\java\CommonFiles\Java64\bin\java.exe" -jar -Xmx1536m -Xms512m tuinity-paperclip.jar nogui
pause

:wellthen
echo You must accept the EULA to continue...
pause
exit



