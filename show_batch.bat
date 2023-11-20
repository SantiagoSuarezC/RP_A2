@echo off
setlocal

for %%f in (.\input\*.txt) do (
    python encode.py < %%f > output\domain_multiple_%%~nf.lp
    clingo lightup.lp output\domain_multiple_%%~nf.lp --outf=2 | clingraph --view --dir='out/lightout' --format=png --out=render --engine=neato --viz-encoding=viz-lightup.lp
)

endlocal