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
attr(graph_nodes, default, fillcolor, yellow).
attr(graph_nodes, default, label, "").

node((X,Y)):-pos((X,Y)).
attr(node,(Y,X),width,1):-pos((X,Y)).
attr(node,(Y,X),shape,square):-pos((X,Y)).
attr(node,(Y,X),pos,@pos(X,Y)):-pos((X,Y)).
attr(node,(Y,X),style,filled):-pos((X,Y)).
attr(node,(Y,X),fillcolor,black):-cell(X,Y,V),V!=b.
attr(node,(Y,X),fontcolor,yellow):-cell(X,Y,V),V!=b,V!=x.
attr(node,(Y,X),label,V):-cell(X,Y,V),V!=b,V!=x.
attr(node,(Y,X),image,@imgfile(bulb)):-cell(X,Y,b).