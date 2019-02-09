function A = lev2adj(varargin)
%LEV2ADJ Weighted interlevel to weighted adjacency matrix representation.
%     A = lev2adj(C)
%     A = lev2adj(C12,C23,...)
%     C = {C12,C23,...}, cell array of weighted interlevel matrices
%   Cij = mi x mj matrix from level i to level j
%    mi = number of nodes in level i
%     m = m1 + m2 + ..., total number of nodes
%     A = m x m node-node weighted adjacency matrix of arc lengths
%         (returns sparse if less than 10% nonzero values)
%
% Note: Predecessor Cij and successor Cjk must be (mi x mj) and (mj x mk)
%       matrices, respectively.
%       Zero values in interlevel matrices indicate no arc (must use NaN to
%       indicate arc with 0 weight).
%
% Examples:
% C = [3 4]
% A = lev2adj(C)        % (1 level)  A = 0 3 4
%                       %                0 0 0
%                       %                0 0 0
%
% C12 = C, C23 = [5 6]
% A = lev2adj(C12,C23)  % (2 levels)  A = 0 3 4 0
%                       %                 0 0 0 5
%                       %                 0 0 0 6
%                       %                 0 0 0 0
%
% See also ADJ2LEV, LIST2INCID, ADJ2LIST, and ADJ2INCID

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin == 1 && iscell(varargin{:})
   C = varargin{:};
elseif all(cellfun('isreal',varargin))
   C = varargin;
else
   error('C must be a single cell array or multiple numeric arrays.')
end

i = cellfun('size',C,1);
j = cellfun('size',C,2);

if any(i(2:end) ~= j(1:end-1))
   error('No. rows of succ. matrix must equal no. cols. of pred. matrix.')
end
% End (Input Error Checking) **********************************************

spA = 0.1;  % Full-sparse threshold

A = [];
for k = 1:length(C)
%    C{k}(C{k}==0) = NaN;
   A = [A; sparse(i(k),i(1)+sum(j(1:k-1))) C{k} sparse(i(k),sum(j(k+1:end)))];
end
A = [A; sparse(j(end),i(1)+sum(j(1:end)))];

if nnz(A) > spA * length(A)^2, A = full(A); end
