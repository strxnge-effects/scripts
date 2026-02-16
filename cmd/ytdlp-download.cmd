echo off
:begin
set filetype=%~x1
echo YTDLP-DOWNLOAD
echo ==============
echo select download format:
echo 1) .mp3
echo 2) .mp4
echo 3) .wav
set /p op=your selection: 
if %op%==1 goto mp3
if %op%==2 goto mp4
if %op%==3 goto wav
if %op%==exit goto eof

echo please make a selection or type "exit"
goto begin


:mp3
set /p "url=url: "
yt-dlp %url% -t mp3 -f bestaudio --audio-quality 0 -o "%USERPROFILE%/Music/yt-dlp/%%(title)s.%%(ext)s"
goto eof

:mp4
set /p "url=url: "
yt-dlp %url% -t mp4 -f "best[ext=mp4]" -o "%USERPROFILE%/Videos/%%(title)s.%%(ext)s"
goto eof

:wav
set /p "url=url: "
yt-dlp %url% --audio-format wav --audio-quality 0 -x -o "%USERPROFILE%/Music/yt-dlp/%%(title)s.%%(ext)s"
goto eof

:eof
