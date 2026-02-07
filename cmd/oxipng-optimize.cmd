@echo off
setlocal enableextensions
set attr=%~a1
set dirattr=%attr:~0,1%
if /i "%dirattr%"=="d" goto is_folder

oxipng -o 4 --strip safe --dir oxipng %1
goto eof

:is_folder
forfiles /p %1 /m *.png /c "oxipng -o 4 --strip safe --dir oxipng @FILE"

:eof
