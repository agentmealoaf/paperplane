@echo off
:1
if exist "%~dp0..\java\CommonFiles\Java64\JavaPortable.ini" (
echo Java is already installed!
) else (
echo Installing Java...
goto getjava
)

:1
if exist "%~dp0tuinity-paperclip.jar" (
echo Tuinity is already downloaded!
) else (
goto tuchoose
)

findstr "eula=true" eula.txt>NUL
if errorlevel 1 (goto notfound) else (goto found)
goto :eof

:tutu
echo Tuinity will now be downloaded
powershell -Command "Invoke-WebRequest https://ci.codemc.io/job/Spottedleaf/job/Tuinity/lastSuccessfulBuild/artifact/tuinity-paperclip.jar -OutFile tuinity-paperclip.jar"
:1
if exist "%~dp0tuinity-paperclip.jar" (
echo Tuinity was sucessfully downloaded!
pause
) else (
echo Tuinity was unable to be downloaded, check the link
pause
)

:notfound
set /p accept="Accept EULA? https://www.minecraft.net/en-us/eula (y/n): "
if /i "%accept%" == "y" (goto writetrue) else (goto wellthen)
goto :eof

:found

:writetrue
echo eula=true> eula.txt
goto runserver

:wellthen
echo No server for you then
pause
exit

:tuchoose
set /p tudownload="Tuinity needs to be downloaded, would you like to do this now? (y/n): "
if /i "%tudownload%" == "y" (goto tutu) else (goto wellthen)

:runserver
"%~dp0..\java\CommonFiles\Java64\bin\java.exe" -jar -Xmx1536m -Xms512m tuinity-paperclip.jar nogui
pause

:getjava
powershell -Command "Invoke-WebRequest https://download3.portableapps.com/portableapps/Java64/jPortable64_8_Update_241_online.paf.exe?20190321 -OutFile ..\java\jportable_online.paf.exe"
..\java\jportable_online.paf.exe