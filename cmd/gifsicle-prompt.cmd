echo off
:begin
echo GIFSICLE-PROMPT
echo ==========
echo select operation for file %1:
echo 1) compress
echo 2) optimize
echo 3) resize (nearest neighbor)
set /p op=your selection: 
if %op%==1 goto comp
if %op%==2 goto opt
if %op%==3 goto resize
if %op%==exit goto eof

echo please make a selection or type "exit"
goto begin

:comp
gifsicle %1 -O3 --lossy=100 --colors=128 > "%~p1%~n1-compress.gif"
goto eof

:opt
gifsicle %1 -O3 > "%~p1%~n1-optimize.gif"
goto eof

:resize
set /p dmn=image dimensions (WxH):
gifsicle %1 --resize %dmn% --resize-method sample > "%~p1%~n1-resize.gif"
goto eof

:eof
