@echo off

@rem Checks if paper is currently downloaded
:CheckPaper
    if exist "%~dp0paperclip.jar" (
       echo Paper is ready...
       goto CheckServerProperties

    ) else (
       goto InstallPaper
       )

@rem Downloads the latest build of paper from the jenkins
:InstallPaper
    echo Downloading Paper...
    powershell -Command "Invoke-WebRequest https://papermc.io/ci/job/Paper-1.16/lastSuccessfulBuild/artifact/paperclip.jar -OutFile paperclip.jar"
    goto CheckPaper

@rem Checks if a server.properties file has already been generated, if not (on first run) it creates one and add custom motd
:CheckServerProperties
    if exist "server.properties" (
       goto CheckEula

    ) else (
       break>"server.properties"
       echo motd=\u00A7fA Portable Minecraft Server\u00A7r\nPowered by \u00A71PaperPlane> server.properties
       goto CheckEula
       )

@rem Checks if a eula.txt has been generated, if not (on first run) it creates an empty text document
:CheckEula
    if exist "eula.txt" (
       findstr "eula=true" eula.txt>NUL
       if errorlevel 1 (goto SetEula) else (
           echo EULA Accepted...
           goto StartServer
           )

    ) else (
       break>"eula.txt"
       goto SetEula
       )


@rem User input to accept, decline, and read the eula
:SetEula
    set /p accept="Accept EULA? (y/n/read): "
       if /i "%accept%" == "y" (goto AcceptEula)
       if /i "%accept%" == "n" (goto DeclineEula)
       if /i "%accept%" == "read" (goto ReadEula)


@rem Opens eula page in browser
:ReadEula
    start "" https://www.minecraft.net/en-us/eula
    goto SetEula


@rem Accepts eula
:AcceptEula
    echo eula=true> eula.txt
    echo EULA Accepted...
    goto StartServer

@rem Doesn't actually delcine the eula, warns the user and returns to :SetEula
:DeclineEula
    echo You must accept the EULA to continue...
    pause
    goto SetEula

@rem User input to choose min and max ram, followed by java command to start the server. Portable Java WIP
:StartServer
    set /p RamMin="Enter Minimum Ram Ammount (mb): "
       if /i "%RamMin%" LSS "512" (
           echo You need to allocate at least 512mb
           goto StartServer
       )
    set /p RamMax="Enter Maximum Ram Ammount (mb): "

    java -jar -Xmx%RamMax%m -Xms%RamMin%m paperclip.jar nogui

@rem A common exit to point to 
:CommonExit
    pause
    exit