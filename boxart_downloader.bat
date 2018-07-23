@echo off
cls
Color 0A
title Boxart Downloader PoC - By MarioMasta64
setlocal enabledelayedexpansion

:: if not exist .\magick\magick.exe (
:: echo download and extract magick to "!CD!\magick\"
:: echo make sure it is the portable version
:: echo i will open your browser, ok.
:: pause
:: start https://www.imagemagick.org/script/download.php#windows
:: echo press enter when youre finished
:: pause>nul
:: )
:: echo if you renamed your roms or didnt dump your roms with godmode9
:: echo download this:
if exist debug.txt call :Set-Debug
if not exist debug.txt (
	if not exist select_folder.vbs call :Set-Batch
	if exist select_folder.vbs call :Set-VBS
)
if not exist .\boxart\ mkdir .\boxart\
if not exist "!boxart!\boxart" mkdir "!boxart!\boxart"

if exist overwrite.txt del "!boxart!\boxart\*"
if exist overwrite.txt del *.bmp

:Continue
cls
if exist readbytesraw.py goto readbytes
if exist IDRead.exe goto IDRead

for %%A in ("!ndsroms!\*.nds") do (
	set "A=%%A"
	set "B=!A:~-13,4!"
	call :Get-Artwork
)
if exist temp.txt del temp.txt
if exist ndsroms.txt del ndsroms.txt
if exist boxart.txt del boxart.txt
title "Downloading - Finished"
pause
exit

:Set-Debug
set "ndsroms=H:\roms\nds"
set "boxart=H:\_nds\dsimenuplusplus"
(goto) 2>nul

:Set-Batch
echo.
echo you can right click and it may paste if not select paste
echo please make sure no roms have an exclamation mark in them
set /p "ndsroms=where are your roms: "
cls
echo exa: H:\_nds\dsimenuplusplus
set /p "boxart=where is your dsimenu++ folder: "
(goto) 2>nul

:Set-VBS
cscript /nologo select_folder.vbs "where are your roms. " > ndsroms.txt
set /p ndsroms=<ndsroms.txt
if "!ndsroms!" == "Cancelled" goto Cancelled
cscript /nologo select_folder.vbs "where is your dsimenu++ folder. example: H:\_nds\dsimenuplusplus\" > boxart.txt
set /p boxart=<boxart.txt
if "!boxart!" == "Cancelled" goto Cancelled
(goto) 2>nul

:Cancelled
cls
echo why would you do that?
pause
goto :Set-VBS

:IDRead
for %%A in ("!ndsroms!\*.nds") do (
	set "A=%%A"
	title "Checking - !A!"
	IDRead.exe "!A!" >temp.txt
	set /p B=<temp.txt
	set "B=!B!"
	call :Get-Artwork
)
pause
exit

:readbytes
for %%A in ("!ndsroms!\*.nds") do (
	set "A=%%A"
	title "Checking - !A!"
	python readbytesraw.py C 10 "!A!" temp.txt
	set /p B=<temp.txt
	set "B=!B!"
	call :Get-Artwork
)
pause
exit

:Get-Artwork
set region=
set "C=!B:~3!"
:RU
if "!C!"=="R" set region=RU
:KO
if "!C!"=="K" set region=KO
:US
if "!C!"=="E" set region=US
:: ???
if "!C!"=="O" set region=EN
:: ???
if "!C!"=="T" set region=US
if "!C!"=="W" set region=US
:JA
if "!C!"=="A" set region=JA
if "!C!"=="J" set region=JA
:EN
if "!C!"=="C" set region=EN
if "!C!"=="D" set region=EN
if "!C!"=="F" set region=EN
if "!C!"=="G" set region=EN
if "!C!"=="H" set region=EN
if "!C!"=="I" set region=EN
if "!C!"=="L" set region=EN
if "!C!"=="M" set region=EN
if "!C!"=="N" set region=EN
if "!C!"=="P" set region=EN
if "!C!"=="Q" set region=EN
if "!C!"=="S" set region=EN
if "!C!"=="U" set region=EN
if "!C!"=="V" set region=EN
if "!C!"=="X" set region=EN
if "!C!"=="Y" set region=EN
if "!C!"=="Z" set region=EN
if "!region!" NEQ "" (
	call :Download-Boxart
)
(goto) 2>nul

:Download-Boxart
if exist direct.txt set "boxartdownloaddir=!boxart!\boxart"
if not exist direct.txt set "boxartdownloaddir=.\boxart"
title "Downloading - TitleID: !B! - Region: !region!"
:: if not exist !B!.png (
if not exist !boxartdownloaddir!\!B!.bmp (
:: if not exist !B!.bmp wget -q --show-progress "https://art.gametdb.com/ds/coverS/!region!/!B!.png"
	if not exist !boxartdownloaddir!\!B!.bmp wget -P "!boxartdownloaddir!\\" -q --show-progress "https://art.gametdb.com/ds/coverDS/!region!/!B!.bmp"
)
:: if exist !B!.png echo "!B!.png successfully downloaded"
if exist .\!boxartdownloaddir!\!B!.bmp echo "!B!.bmp successfully downloaded"
:: if not exist !B!.bmp call :Convert-Boxart
if not exist direct.txt (
	if exist .\boxart\!B!.bmp call :Copy-Boxart
)
(goto) 2>nul

:Convert-Boxart
if not exist "!B!.png!" (goto) 2>nul
title "Converting - TitleID: !B! - Region: !region!"
if not exist deepfry.txt .\magick\magick !B!.png -resize 128x115 -define bmp:subtype=RGB555 !B!.bmp
if exist deepfry.txt .\magick\magick !B!.png -resize 128x115 -define bmp:subtype=RGB565 !B!.bmp
if exist !B!.bmp echo "!B!.png successfully converted"
(goto) 2>nul

:Copy-Boxart
if exist !B!.png del !B!.png
title "Copying - TitleID: !B! - Region: !region!"
copy .\boxart\!B!.bmp "!boxart!\boxart\" >nul
if exist "!boxart!\boxart\!B!.bmp" echo "!B!.bmp successfully copied"
(goto) 2>nul