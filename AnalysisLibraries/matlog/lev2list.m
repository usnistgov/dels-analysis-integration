function IJC = lev2list(varargin)
%LEV2LIST Weighted interlevel to arc list representation.
%   IJC = lev2list(C)
%   IJC = lev2list(C12,C23,...)
%     C = {C12,C23,...}, cell array of weighted interlevel matrices
%   Cij = mi x mj matrix from level i to level j
%    mi = number of nodes in level i
%     m = m1 + m2 + ..., total number of nodes
%   IJC = n x 2-3 matrix arc list [i j c], where
%     i = n-element vector of arc tails nodes
%     j = n-element vector of arc head nodes
%     c = n-element vector of arc weights
%
% Examples:
% C = [3 4]
% IJC = lev2list(C)       % (1 level)  IJC = 1 2 3
%                         %                  1 3 4
%
% C12 = C, C23 = [5 6]'
% IJC = lev2list(C12,C23) % (2 levels) IJC = 1 2 3
%                         %                  1 3 4
%                         %                  2 4 5
%                         %                  3 4 6
%
% Wrapper for IJC = ADJ2LIST(LEV2ADJ(C))
%
% See also LIST2INCID and ADJ2INCID

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
% End (Input Error Checking) **********************************************

IJC = adj2list(lev2adj(varargin{:}));
