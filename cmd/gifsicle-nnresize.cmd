REM resize using nearest neighbor alg
gifsicle %1 --resize %2 --resize-method sample > "%~p1%~n1_resize.gif"