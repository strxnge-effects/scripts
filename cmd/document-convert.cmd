echo off
:begin
set filetype=%~x1
rem use libreoffice to convert filetypes unsupported by pandoc
if %filetype%==.rtf (
    set useSO=true
)
if %filetype%==.fodt (
    set useSO=true
)

echo DOCUMENT-CONVERT
echo ================
echo select conversion for file %1:
echo 1) to html
echo 2) to markdown
echo 3) to txt
set /p op=your selection: 
if %op%==1 goto html
if %op%==2 goto md
if %op%==3 goto txt
if %op%==exit goto eof

echo please make a selection or type "exit"
goto begin


:html
if defined useSO (
    soffice --headless --convert-to html %1
) else (
    pandoc --wrap=none -t html %1 > "%~p1%~n1.html"
)
goto eof

:md
if defined useSO (
    soffice --headless --convert-to md %1
) else (
    pandoc --wrap=none -t markdown %1 > "%~p1%~n1.md"
)
goto eof

:txt
if defined useSO (
    soffice --headless --convert-to txt %1
) else (
    pandoc --wrap=none %1 > "%~p1%~n1.txt"
)
goto eof

:eof
