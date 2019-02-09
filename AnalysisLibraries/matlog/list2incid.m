function [I,c,u,l] = list2incid(IJCUL,spI)
%LIST2INCID Arc list to node-arc incidence matrix representation.
% [I,c,u,l] = list2incid(IJCUL,spI)
% IJCUL = n x 2-5 matrix arc list [i j c u l], with i and j required and
%         c, u, and l optional (just passed through)
%     i = n-element vector of arc tails nodes
%     j = n-element vector of arc head nodes
%     c = n-element vector of arc costs, where n = number of arcs
%     u = n-element vector of arc upper bounds
%     l = n-element vector of arc lower bounds
%   spI = (optional) make I sparse matrix if no. of nodes (m) >= 1/spI
%       = 1, always make I sparse
%       = 0.05 (default), make I sparse if m >= 20
%       = 0, always make I full matrix
%     I = m-row node-arc incidence matrix, where number of columns >= n
%         (> n if some elements of j < 0)
%
% Given arc list elements i(k) and j(k):
%         j(k) > 0 => column k in I: (i(k),j(k))
%         j(k) < 0 => undirected arc (i(k),j(k)) converted to two
%                     directed arcs corresponding to columns k and k' in I:
%                     (i(k),-j(k)) and (-j(k') -i(k'))
%	    i(k) = j(k) => (self-loop) => I[i(k),k] = I[j(k),k] = 1
%
% Examples:
% IJC = [1 2 1
%        3 1 3
%        3 2 2]
% [I,c] = list2incid(IJC)  % I =  1 -1  0   c = 1
%                                -1  0 -1       3
%                                 0  1  1       2
%
% IJC = [1 -2  1           % Symmetric arcs
%        3 -1  3
%        3 -2  2]
% [I,c] = list2incid(IJC)  % I =  1 -1  0 -1  1  0   c = 1
%                                -1  0 -1  1  0  1       2
%                                 0  1  1  0 -1 -1       3
%                                                        1
%                                                        2
%                                                        3
% See also LIST2ADJ, ADJ2LIST, and ADJ2INCID

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,2)

cIJCUL = size(IJCUL,2);
if cIJCUL < 2 || cIJCUL > 5
   error('IJCUL must be a 2-5 column matrix.')
end

idx = find(IJCUL(:,2) < 0);
IJCUL(:,2) = abs(IJCUL(:,2));
IJCUL = [IJCUL; [IJCUL(idx,2) IJCUL(idx,1) IJCUL(idx,[3:end])]]; 

[i,j,c,u,l] = mat2vec(IJCUL);

minIJ = min(min([i j]));
if isempty(minIJ) || minIJ < 1 || any(~isint(i)) || any(~isint(j))
   error('All elements of "i" and "j" must be nonzero integers.')
end

if nargin < 2 || isempty(spI)
   spI = 0.05;
elseif length(spI(:)) ~= 1 || spI < 0
   error('"spI" must be non-negative scalar.')
end
% End (Input Error Checking) **********************************************

m = max(max([i j]));
n = size(IJCUL,1);

jsgn(i==j) = 0;	% Self-loop i(k) = j(k) => I[i(k),k] = I[j(k),k] = 1

I = sparse([1:n 1:n]',[i;j],[ones(n,1);-ones(n,1)],n,m)';

if 1 > spI * m, I = full(I); end
