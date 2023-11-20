@echo off
setlocal

for %%f in (.\input\*.txt) do (
    python encode_original.py < %%f > output\original\domain_original_%%~nf.lp
    clingo 0 lightup.lp output\original\domain_original_%%~nf.lp --outf=2 | python decode.py > output\original\txt\solution_%%~nf.txt
)

endlocal