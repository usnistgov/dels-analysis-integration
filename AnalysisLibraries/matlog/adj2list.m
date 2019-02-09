function [i,j,c] = adj2list(A)
%ADJ2LIST Node-node weighted adjacency matrix to arc list representation.
%     IJC = adj2list(A)
% [i,j,c] = adj2list(A)
%     A = m x m node-node weighted adjacency matrix of arc lengths
%   IJC = n x 2-3 matrix arc list [i j c], where
%     i = n-element vector of arc tails nodes
%     j = n-element vector of arc head nodes
%     c = n-element vector of arc weights
%
% Note: All A(i,j) = A(j,i) => [i -j c] (symmetric A)
%       A(i,j) = 0   => Arc (i,j) does not exist
%       A(i,j) = NaN => Arc (i,j) exists with 0 weight
%       Wrapper for [i,j,c] = FIND(C); c(ISNAN(c)) = 0)
%
% Examples:
% A = [0 1 0
%      0 0 0
%      3 2 0]
% IJC = adj2list(A)  % IJC = 3  1  3
%                    %       1  2  1
%                    %       3  2  2
%
% A = [0 1 0            % Arc (3,1) has 0 weight
%      0 0 0
%    NaN 2 0]
% IJC = adj2list(A)  % IJC = 3  1  0
%                    %       1  2  1
%                    %       3  2  2
%
% A = [0 1 3            % A is symmetric
%      1 0 2
%      3 2 0]
% IJC = adj2list(A)  % IJC = 1 -2  1
%                    %       1 -3  3
%                    %       2 -3  2
%
% See also LIST2INCID, LIST2ADJ, and ADJ2INCID

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
[rA,cA] = size(A);
if rA ~= cA
   error('"A" must be a square matrix.')
end
% End (Input Error Checking) **********************************************

[i,j] = find(isnan(A));        % Set NaN's to 0 so symmetric test works
Anan = sparse(i,j,NaN,rA,cA);
A(isnan(A)) = 0;
if any(any(triu(A)~=tril(A)'))
   issym = 0;
   A = A + Anan;
else
   issym = 1;
   A = triu(A) + triu(Anan);
end

[i,j,c] = find(A);
if issym, j = -j; end
c(isnan(c)) = 0;

if nargout < 2
   i = [i j c];
end
