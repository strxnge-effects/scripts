@echo off
set /p "W=width: "
set /p "H=height: "

magick convert %1 -gravity Center -crop %W%x%H%+0+0 +repage "%~p1%~n1_resize50_compress%~x1"