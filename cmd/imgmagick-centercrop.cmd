@echo off
set /p "W=width: "
set /p "H=height: "

magick %1 -gravity Center -crop %W%x%H%+0+0 +repage "%~p1%~n1_centercrop%~x1"
