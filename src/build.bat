cd /d "%~dp0"
echo #define COMMENTS "%date%">date.h
for %%i in (*.rc) do brc32 -r %%i
for %%i in (*.dpr) do dcc32 -U.\shl\;.\tnt\ %%i
pause
del *.res date.h

