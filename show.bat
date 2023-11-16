python encode.py < %~1 > domain.lp
clingo lightup.lp domain.lp --outf=2 | clingraph --view --dir='out/lightout' --format=png --out=render --engine=neato --viz-encoding=viz-lightup.lp