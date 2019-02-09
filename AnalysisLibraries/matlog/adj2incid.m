function [I,c] = adj2incid(A)
%ADJ2INCID Node-node weighted adjacency matrix to node-arc incidence matrix.
% [I,c] = adj2incid(A)
%     A = m x m node-node weighted adjacency matrix of arc lengths
%     I = m x n node-arc incidence matrix
%     c = n-element vector of arc weights (nonzero elements of A)
%
% Note: A(i,j) = 0   => Arc (i,j) does not exist
%       A(i,j) = NaN => Arc (i,j) exists with 0 weight
%       All A(i,j) = A(j,i) => A is symmetric => all undirected arcs in I 
%       Wrapper for [I,c] = LIST2INCID(ADJ2LIST(A))
%       I is column major relative to A for speed purposes
%
% Examples:
% A = [0 1 0
%      0 0 0
%      3 2 0]
% [I,c] = adj2incid(A)  % I = -1  1  0   c = 3
%                              0 -1 -1       1
%                              1  0  1       2
%
% A = [0 1 0            % Arc (3,1) has 0 weight
%      0 0 0
%    NaN 2 0]
% [I,c] = adj2incid(A)  % I = -1  1  0   c = 0
%                              0 -1 -1       1
%                              1  0  1       2
%
% A = [0 1 3            % A is symmetric
%      1 0 2
%      3 2 0]
% [I,c] = adj2incid(A)  % I =  1  1  0   c = 1
%                              1  0  1       3
%                              0  1  1       2
%
% See also LIST2INCID, LIST2ADJ, and ADJ2LIST

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
[m,cA] = size(A);
if m ~= cA
   error('"A" must be a square matrix.');
end
% End (Input Error Checking) **********************************************

if ~any(any(triu(A) ~= tril(A)'))	% A symmetric => undirected arcs (edges)
   [i,j,c] = adj2list(triu(A));
   j = -j;
else
   [i,j,c] = adj2list(A);   
end
I = list2incid([i j],issparse(A));
