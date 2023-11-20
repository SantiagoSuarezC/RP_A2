% Game Setup: Definition of Grid and Cell Types
% -----------------------------------------------------------------------------------
% Define all positions for the grid
pos((X, Y)) :- X=0..n-1, Y=0..n-1.

% Define block cells (cells that are either 'x' or contain a number)
block_cell(X,Y) :- cell(X,Y,x).
block_cell(X,Y) :- numbered_cell(X,Y).
numbered_cell(X,Y) :- cell(X,Y,N), N >= 0, N <= 4.

% Define empty cells (white cells without a number or 'x')
empty_cell(X,Y,".") :- pos((X,Y)), not block_cell(X,Y).

% Bulb Placement Rules
% -----------------------------------------------------------------------------------
% Bulbs can be placed in any empty cell
{ bulb(X,Y) : empty_cell(X,Y,".") }.

% Lighting Mechanics: How Bulbs Illuminate Cells
% -----------------------------------------------------------------------------------
% A bulb illuminates its entire row and column unless blocked by a black cell
% Light up a row and column from a bulb
illuminate_column(XB,YB,X,Y) :- bulb(XB,YB), X = XB, Y = YB.
illuminate_row(XB,YB,X,Y) :- bulb(XB,YB), X = XB, Y = YB.
% Extend light in row until it hits a block cell or the grid edge
illuminate_column(XB,YB,X,Y) :- illuminate_column(XB,YB, X1,Y), X = X1 + 1, X < n, not block_cell(X,Y).
illuminate_column(XB,YB,X,Y) :- illuminate_column(XB,YB, X1,Y), X = X1 - 1, X >= 0, not block_cell(X,Y).
% Extend light in column until it hits a block cell or the grid edge
illuminate_row(XB,YB,X,Y) :- illuminate_row(XB,YB, X,Y1), Y = Y1 + 1, Y < n, not block_cell(X,Y).
illuminate_row(XB,YB,X,Y) :- illuminate_row(XB,YB, X,Y1), Y = Y1 - 1, Y >= 0, not block_cell(X,Y).
% Combine row and column lights
lights(XB,YB,X,Y) :- illuminate_row(XB,YB,X,Y).
lights(XB,YB,X,Y) :- illuminate_column(XB,YB,X,Y).

% Game Rules: Constraints for Valid Bulb Placement
% -----------------------------------------------------------------------------------
% Rule 1: All white cells must be lighted up by some bulb
illuminated (X,Y) :- lights(_,_,X,Y).
%   checking if all board is lit up
:- illuminated(X,Y), not empty_cell(X,Y,".").
:- not illuminated(X,Y), empty_cell(X,Y,".").

% Rule 2: A light bulb cannot send a light ray on another bulb
conflict(X,Y) :- lights(XB,YB,X,Y), bulb(XB1,YB1), X=XB1, Y=YB1, XB=XB1, YB!=YB1.
conflict(X,Y) :- lights(XB,YB,X,Y), bulb(XB1,YB1), X=XB1, Y=YB1, XB!=XB1, YB=YB1.
conflict(X,Y) :- lights(XB,YB,X,Y), bulb(XB1,YB1), X=XB1, Y=YB1, XB!=XB1, YB!=YB1.
:- not 0{conflict(X,Y)}0.

% Rule 3: Number in black cell must match the count of neighboring bulbs
neighbours(XBlock,YBlock,XBulb,YBulb) :- block_cell(XBlock, YBlock),bulb(XBulb,YBulb), XBlock + 1 = XBulb, YBlock = YBulb, XBulb < n.
neighbours(XBlock,YBlock,XBulb,YBulb) :- block_cell(XBlock,YBlock),bulb(XBulb,YBulb), XBlock - 1 = XBulb, YBlock = YBulb, XBulb >= 0.
neighbours(XBlock,YBlock,XBulb,YBulb) :- block_cell(XBlock,YBlock),bulb(XBulb,YBulb), XBlock = XBulb, YBlock + 1 = YBulb, YBulb < n.
neighbours(XBlock,YBlock,XBulb,YBulb) :- block_cell(XBlock,YBlock),bulb(XBulb,YBulb), XBlock = XBulb, YBlock - 1 = YBulb, YBulb >= 0.
count_neighbour_bulbs(XBl, YBl, N) :- block_cell(XBl, YBl), #count{ XBulb, YBulb : neighbours(XBl, YBl, XBulb, YBulb) } = N.
:- count_neighbour_bulbs(X, Y, N1), numbered_cell(X, Y), cell(X, Y, N2), N1 != N2.

% Output Formatting
% -----------------------------------------------------------------------------------
% Bulb cell definition
cell(X, Y, b) :- bulb(X, Y).

% Output variables
#show pos/1.
#show cell/3.