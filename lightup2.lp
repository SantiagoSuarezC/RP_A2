% Game Setup: Definition of Grid and Cell Types
% -----------------------------------------------------------------------------------
% Define all positions for the grid
pos((X, Y)) :- X=0..n-1, Y=0..n-1.

% Define block cells (cells that are either 'x' or contain a number)
block_cell(X,Y) :- cell(X,Y,x).
block_cell(X,Y) :- cell(X,Y,N), N >= 0, N <= 4.

% Define empty cells (white cells without a number or 'x')
empty_cell(X,Y,".") :- pos((X, Y)), not block_cell(X,Y).

% Bulb Placement Rules
% -----------------------------------------------------------------------------------
% Bulbs can be placed in any empty cell
{ bulb(X,Y) : empty_cell(X,Y,".") }.

% Lighting Mechanics: How Bulbs Illuminate Cells
% -----------------------------------------------------------------------------------
% A bulb illuminates its entire row and column unless blocked by a black cell
illuminate_row(XB,YB,X,Y) :- bulb(XB,YB), X = XB, Y = YB.
illuminate_column(XB,YB,X,Y) :- bulb(XB,YB), X = XB, Y = YB.
illuminate_row(XB,YB,X,Y) :- illuminate_row(XB,YB, X1,Y), X = X1 + 1, X < n, not block_cell(X,Y).
illuminate_row(XB,YB,X,Y) :- illuminate_row(XB,YB, X1,Y), X = X1 - 1, X >= 0, not block_cell(X,Y).
illuminate_column(XB,YB,X,Y) :- illuminate_column(XB,YB, X,Y1), Y = Y1 + 1, Y < n, not block_cell(X,Y).
illuminate_column(XB,YB,X,Y) :- illuminate_column(XB,YB, X,Y1), Y = Y1 - 1, Y >= 0, not block_cell(X,Y).
illuminated(X,Y) :- illuminate_column(_,_,X,Y).
illuminated(X,Y) :- illuminate_row(_,_,X,Y).

% Game Rules: Constraints for Valid Bulb Placement
% -----------------------------------------------------------------------------------
% Rule 1: All white cells must be lighted up by some bulb
:- empty_cell(X,Y,"."), not illuminated(X,Y).
:- not empty_cell(X,Y,"."), illuminated(X,Y).

% Rule 2: A light bulb cannot send a light ray on another bulb
conflict(X,Y) :- illuminate_column(XB,YB,X,Y), bulb(XB1,YB1), XB1 != XB, YB1 = Y.
conflict(X,Y) :- illuminate_row(XB,YB,X,Y), bulb(XB1,YB1), XB1 = XB, YB1 != Y.
:- not 0{conflict(X,Y)}0.

% Rule 3: Number in black cell must match the count of neighboring bulbs
adjacent(X1, Y1, X2, Y2) :- X1 = X2, Y1 + 1 = Y2, pos((X1, Y1)), pos((X2, Y2)).
adjacent(X1, Y1, X2, Y2) :- X1 = X2, Y1 - 1 = Y2, pos((X1, Y1)), pos((X2, Y2)).
adjacent(X1, Y1, X2, Y2) :- X1 + 1 = X2, Y1 = Y2, pos((X1, Y1)), pos((X2, Y2)).
adjacent(X1, Y1, X2, Y2) :- X1 - 1 = X2, Y1 = Y2, pos((X1, Y1)), pos((X2, Y2)).
neighbour_bulb(XBlock,YBlock,XBulb,YBulb) :- block_cell(XBlock, YBlock), bulb(XBulb,YBulb), adjacent(XBlock, YBlock, XBulb, YBulb).
count_neighbour_bulbs(XBl, YBl, N) :- block_cell(XBl, YBl), N = #count { XBulb, YBulb : neighbour_bulb(XBl, YBl, XBulb, YBulb) }.
:- block_cell(X, Y, N), count_neighbour_bulbs(X, Y, N1), N1 != N.

% Output Formatting
% -----------------------------------------------------------------------------------
% Bulb cell definition
cell(X, Y, b) :- bulb(X, Y).

% Show directives
#show pos/1.
#show cell/3.