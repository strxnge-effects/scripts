@echo off
set /p "url=youtube url: "

yt-dlp %url% -t mp4 --no-config -o "%USERPROFILE%/Videos/%%(title)s.mp4"
