echo off
:begin
set filetype=%~x1
echo FFMPEG-CONVERT
echo ==========
echo select conversion for file %1:
echo 1) 128kbps mp3 conversion
echo 2) 196kbps mp3 conversion
echo 3) flac conversion
set /p op=your selection: 
if %op%==1 goto 128kmp3
if %op%==2 goto 196kmp3
if %op%==3 goto flac
if %op%==exit @exit

echo please make a selection or type "exit"
goto begin


:128kmp3
if %filetype%==.mp3 (
    ffmpeg -i %1 -map 0:a:0 -b:a 128k "%~p1%~n1-128k.mp3"
) else (
    ffmpeg -i %1 -map 0:a:0 -b:a 128k "%~p1%~n1.mp3"
)
goto eof

:196kmp3
if %filetype%==.mp3 (
    ffmpeg -i %1 -map 0:a:0 -b:a 196k "%~p1%~n1-196k.mp3"
) else (
    ffmpeg -i %1 -map 0:a:0 -b:a 196k "%~p1%~n1.mp3"
)
goto eof

:flac
ffmpeg -i %1 -af aformat=s16:44100 "%~p1%~n1.flac"
goto eof

:eof
