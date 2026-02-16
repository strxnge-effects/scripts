echo off
:begin
echo IMGMAGICK-RESIZE
echo ==========
set /p pcent=percentage to resize the image by: 
if %pcent%==exit @exit

echo select resampling filter:
echo 1) default
echo 2) nearest neighbor
set /p op=your selection: 
if %op%==1 goto default
if %op%==2 goto point
if %op%==exit goto eof

:default
magick %1 -resize %pcent%%% "%~p1%~n1-resize%~x1"
goto eof

:point
magick %1 -filter Point -resize %pcent%%% "%~p1%~n1-resize%~x1"
goto eof

:eof
