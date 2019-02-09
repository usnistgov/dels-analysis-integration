function A = list2adj(IJC,m,spA)
%LIST2ADJ Arc list to node-node weighted adjacency matrix representation.
%     A = list2adj(IJC,m,spA)
%   IJC = n x 2-5 matrix arc list [i j c u l], where
%     i = n-element vector of arc tails nodes
%     j = n-element vector of arc head nodes
%     c = (optional) n-element vector of arc costs, where n = number arcs
%       = (default) ONES(n,1)
%     u = (optional) ignored
%     l = (optional) ignored
%     m = (optional) scalar size of A if greater than 
%         max{max(i),max(abs(j))} 
%   spA = (optional) make A sparse matrix if n <= spA x m x m
%       = 1, always make A sparse
%       = 0.1 (default), A sparse if 10% arc density
%       = 0, always make A full matrix
%     A = m x m node-node weighted adjacency matrix
%
% Transforms: If j(k) > 0, then [i(k) j(k) c(k)] -> A[i(k),j(k)]  = c(k)
%
%             If j(k) < 0, then [i(k) j(k) c(k)] -> A[i(k),-j(k)] = c(k)
%                                                   A[-j(k),i(k)] = c(k)
%
% Note: Weights of any duplicate arcs added together in A
%       c(k) = 0 => A(i(k),j(k)) = NaN
%       Wrapper for c(c==0) = NaN; A = SPARSE(i,j,c,m,m);
%
% Examples:
% IJC = [1 2 1
%        3 1 3
%        3 2 2]
% A = list2adj(IJC)  % A =  0  1  0
%                           0  0  0
%                           3  2  0
%
% IJC(3,1) = 0             % Arc (3,1) has 0 weight
% A = list2adj(IJC)  % A =  0  1  0
%                           0  0  0
%                         NaN  2  0
%
% IJC = [1 -2  1           % Symmetric arcs
%        3 -1  3
%        3 -2  2]
% A = list2adj(IJC)  % A =  0  1  3
%                           1  0  2
%                           3  2  0
%
% See also LIST2INCID, ADJ2LIST, and ADJ2INCID

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 24-Apr-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,3)

[n,cIJC] = size(IJC);
if cIJC < 2 || cIJC > 5, error('IJC must be a 2-5 column matrix.'), end

[i,j,c] = mat2vec(IJC);
if isempty(c), c = ones(n,1); end

jsgn = sign(j); j = abs(j);
minIJ = min(min([i j]));
if isempty(minIJ) || minIJ < 1 || any(~isint(i)) || any(~isint(j))
   error('All elements of "i" and "j" must be nonzero integers.')
end

if nargin < 2 || isempty(m)
   m = max(max([i j]));
elseif length(m(:)) ~= 1 || ~isint(m) || m < max(max([i j]))
   error('"n" must be >= max{max(i),max(abs(j))}.')
end

if nargin < 3 || isempty(spA)
   spA = 0.1;
elseif length(spA(:)) ~= 1 || spA < 0
   error('"spA" must be non-negative scalar.')
end
% End (Input Error Checking) **********************************************

if any(jsgn < 0)						% Add elements from undirected arcs
   jsgn(jsgn < 0 & i == j) = 1;
   i = [i; j(jsgn < 0)];
   j = [j; i(jsgn < 0)];
   c = [c; c(jsgn < 0)];
end

c(c==0) = NaN;
A = sparse(i,j,c,m,m);

if n > spA * m * m, A = full(A); end
