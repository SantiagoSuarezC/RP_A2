% All coords for grid
coords(0.. n-1 ,0.. n-1 ).
% Define block cells (both 'x' and numbered cells)
block_cell(X,Y) :- cell(X,Y,x).
block_cell(X,Y) :- numbered_cell(X,Y).
% Define numbered cells
numbered_cell(X,Y) :- cell(X,Y,N), N >= 0, N <= 4.
% Define empty cells
empty(X,Y,".") :- coords(X,Y), not block_cell(X,Y).
%   bulb can only be at places too light up but we don't know how many we need
{ bulb(X,Y) : empty(X,Y,".") }.

% 1. "No 2 Bulbs can shine on each other"

% Light up a row and column from a bulb
lights_row(XB,YB,X,Y) :- bulb(XB,YB), X = XB, Y = YB.
lights_col(XB,YB,X,Y) :- bulb(XB,YB), X = XB, Y = YB.
% Extend light in row until it hits a block cell or the grid edge
lights_row(XB,YB,X,Y) :- lights_row(XB,YB, X1,Y), X = X1 + 1, X < n, not block_cell(X,Y).
lights_row(XB,YB,X,Y) :- lights_row(XB,YB, X1,Y), X = X1 - 1, X >= 0, not block_cell(X,Y).
% Extend light in column until it hits a block cell or the grid edge
lights_col(XB,YB,X,Y) :- lights_col(XB,YB, X,Y1), Y = Y1 + 1, Y < n, not block_cell(X,Y).
lights_col(XB,YB,X,Y) :- lights_col(XB,YB, X,Y1), Y = Y1 - 1, Y >= 0, not block_cell(X,Y).
% Combine row and column lights
lights(XB,YB,X,Y) :- lights_col(XB,YB,X,Y).
lights(XB,YB,X,Y) :- lights_row(XB,YB,X,Y).

% 2. from rules in readme
%   error(X,Y) is when coordinates X,Y are lit by more than one bulb
error(X,Y) :- lights(XB,YB,X,Y), bulb(XB1,YB1), X=XB1, Y=YB1, XB=XB1, YB!=YB1.
error(X,Y) :- lights(XB,YB,X,Y), bulb(XB1,YB1), X=XB1, Y=YB1, XB!=XB1, YB=YB1.
error(X,Y) :- lights(XB,YB,X,Y), bulb(XB1,YB1), X=XB1, Y=YB1, XB!=XB1, YB!=YB1.
%   there should not be any errors
:- not 0{error(X,Y)}0.

% 3. "All grid must be lit up"
%   all coords that are lighted
lighted_coords (X,Y) :- lights(_,_,X,Y).
%   checking if all board is lit up
:- lighted_coords(X,Y), not empty(X,Y,".").
:- not lighted_coords(X,Y), empty(X,Y,".").

% 4. "Neighbour thingy"
%   XBlock, YBlock has neighbour XBulb, YBulb.
neighbours(XBlock,YBlock,XBulb,YBulb) :- block_cell(XBlock, YBlock),bulb(XBulb,YBulb), XBlock + 1 = XBulb, YBlock = YBulb, XBulb < n.
neighbours(XBlock,YBlock,XBulb,YBulb) :- block_cell(XBlock,YBlock),bulb(XBulb,YBulb), XBlock - 1 = XBulb, YBlock = YBulb, XBulb >= 0.
neighbours(XBlock,YBlock,XBulb,YBulb) :- block_cell(XBlock,YBlock),bulb(XBulb,YBulb), XBlock = XBulb, YBlock + 1 = YBulb, YBulb < n.
neighbours(XBlock,YBlock,XBulb,YBulb) :- block_cell(XBlock,YBlock),bulb(XBulb,YBulb), XBlock = XBulb, YBlock - 1 = YBulb, YBulb >= 0.

% 4. from rules in readme
% neighbours_count(XBl,YBl,N) how many Block Xbl, Ybl has bulbs (N)
neighbours_count(XBl, YBl, N) :- block_cell(XBl, YBl), #count{ XBulb, YBulb : neighbours(XBl, YBl, XBulb, YBulb) } = N.
% it has be equal to number in block
:- neighbours_count(X, Y, N1), numbered_cell(X, Y), cell(X, Y, N2), N1 != N2.


#show bulb/2.

#show cell/3.  % Add this line to show cells in the required format

% Additional rule to output the positions of bulbs in the required format for decode.py
cell(X, Y, b) :- bulb(X, Y).
