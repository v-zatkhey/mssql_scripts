@rem формування файла даних
@echo off 

@rem cd /D %~dp0

echo mark

if "%1" EQU "" goto lbnotparam

if not exist %1 (
	echo === Error: Not found ini-file '%1' ! ===
	goto lbend
)

for /F "usebackq eol=# tokens=1* delims==" %%i in (%1) do (
	@rem @echo %%i %%j
	if "%%i"=="server" SET server=%%j
	if "%%i"=="dbname" SET dbname=%%j
	if "%%i"=="script" SET script=%%j
	if "%%i"=="datafile" SET datafile=%%j
	if "%%i"=="zipfile" SET zipfile=%%j
)

sqlcmd -S %server% -d %dbname% -E -i%script% -o%datafile%
"C:\Program Files\7-Zip\7z.exe" a %zipfile% %datafile%
del   %datafile%

goto lbend

:lbnotparam
echo Need parameter: path_to_ini_file
:lbend