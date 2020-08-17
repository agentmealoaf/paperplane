@echo off

:CheckPaper
if exist "%~dp0tuinity-paperclip.jar" (
echo Paper is ready...
goto CheckServerProperties
) else (
goto InstallPaper
)

:InstallPaper
echo Downloading Paper...
powershell -Command "Invoke-WebRequest https://ci.codemc.io/job/Spottedleaf/job/Tuinity/lastSuccessfulBuild/artifact/tuinity-paperclip.jar -OutFile tuinity-paperclip.jar"
goto CheckPaper

:CheckServerProperties
if exist "server.properties" (
goto CheckEula
) else (
break>"server.properties")
echo motd=\u00A7fA Portable Minecraft Server\u00A7r\nPowered by \u00A71PaperPlane> server.properties
goto CheckEula

:CheckEula
if exist "eula.txt" (
findstr "eula=true" eula.txt>NUL
if errorlevel 1 (goto SetEula) else (goto StartServer)
) else (
break>"eula.txt"
goto SetEula
)
goto :eof

:SetEula
set /p accept="Accept EULA? (y/n) (v to view eula): "
if /i "%accept%" == "y" (goto AcceptEula)
if /i "%accept%" == "n" (goto DeclineEula)
if /i "%accept%" == "v" (goto ReadEula)
goto :eof

:ReadEula
start "" https://www.minecraft.net/en-us/eula
goto SetEula

:AcceptEula
echo eula=true> eula.txt
goto StartServer

:DeclineEula
echo You must accept the EULA to continue...
goto SetEula

:StartServer
set /p RamMin="Enter Minimum Ram Ammount (mb): "
set /p RamMax="Enter Maximum Ram Ammount (mb): "
"%~dp0..\java\jdk-14.0.2_windows-x64_bin\jdk-14.0.2\bin\java.exe" -jar -Xmx%RamMax%m -Xms%RamMin%m tuinity-paperclip.jar nogui
pause