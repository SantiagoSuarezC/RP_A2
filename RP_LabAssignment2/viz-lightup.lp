#script (python)
from clingo.symbol import String
import os
from clingo.symbol import String
def pos(x,y):
    return String(f"{str(x)},{str(y)}!")
def imgfile(x):
    s=os.getcwd() + "/" + str(x) + ".png"
    return String(s)
#end.

attr(graph_nodes, default, fontsize, "40").
attr(graph_nodes, default, fontcolor, blue).
attr(graph_nodes, default, fillcolor, white).
attr(graph_nodes, default, label, "").

node((X,Y)):-pos((X,Y)).
attr(node,(X,Y),width,1):-pos((X,Y)).
attr(node,(X,Y),shape,square):-pos((X,Y)).
attr(node,(X,Y),pos,@pos(X,Y)):-pos((X,Y)).
attr(node,(X,Y),style,filled):-pos((X,Y)).
attr(node,(X,Y),fillcolor,black):-cell(X,Y,V),V!=b.
attr(node,(X,Y),fontcolor,white):-cell(X,Y,V),V!=b,V!=x.
attr(node,(X,Y),label,V):-cell(X,Y,V),V!=b,V!=x.
attr(node,(X,Y),image,@imgfile(bulb)):-cell(X,Y,b).