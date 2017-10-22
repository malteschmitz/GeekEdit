@if "%1"=="deploy" goto :deploy
@if "%1"=="info" goto :info
@start GeekEdit.exe %1 %2 %3 %4 %4 %5 %6 %7 %8 %9
@goto :eof

@REM %~I -- Expands %I which removes any surrounding quotation marks ("").
@REM %~fI -- Expands %I to a fully qualified path name.
@REM %~dI -- Expands %I to a drive letter only.
@REM %~pI -- Expands %I to a path only.
@REM %~nI -- Expands %I to a file name only.
@REM %~xI -- Expands %I to a file extension only.
@REM %~sI -- Expands path to contain short names only.
@REM %~aI -- Expands %I to the file attributes of file.
@REM %~tI -- Expands %I to the date and time of file.
@REM %~zI -- Expands %I to the size of file.
@REM %~dpI -- Expands %I to a drive letter and path only.
@REM %~nxI -- Expands %I to a file name and extension only.
@REM %~fsI -- Expands %I to a full path name with short names only.
@REM %~ftzaI -- Expands %I to an output line that is like dir.

:deploy
@if %2!==! goto :eof
cd "%~dp2"
@call :deploy_del "%~n2"
pdflatex -shell-escape "%~nx2"
bibtex "%~n2"
@for %%i in (1,2,3) do pdflatex -shell-escape "%~nx2"
@call :deploy_del "%~n2"
@goto :eof

:deploy_del
del "%~1.aux"
del "%~1.cb"
del "%~1.cb2"
del "%~1.dvi"
del "%~1.log"
del "%~1.out"
del "%~1.toc"
del "%~1.thm"
del "*.gnuplot"
del "%~1.table"
del "%~1.snm"
del "%~1.nav"
del "%~1.vrb"
del "%~1.idx"
del "%~1.bbl"
del "%~1.blg"
@goto :eof

:info
@echo GeekEdit Batch Tool Collection
@goto :eof