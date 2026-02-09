@echo off
set /p "W=width / height: "

magick %1 -gravity Center -crop %W%x%W%+0+0 +repage "%~p1%~n1_centercrop%~x1"
