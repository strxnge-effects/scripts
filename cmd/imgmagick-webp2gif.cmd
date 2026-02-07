@echo off
setlocal enableextensions
set attr=%~a1
set dirattr=%attr:~0,1%
if /i "%dirattr%"=="d" goto is_folder

magick mogrify -dispose previous -coalesce -format gif "%~p1%~n1.webp"
goto eof

:is_folder
forfiles /p %1 /m *.webp /c "magick mogrify -dispose previous -coalesce -format gif @FILE"

:eof
pause
