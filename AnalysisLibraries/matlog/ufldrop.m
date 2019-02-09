function [y,TC,X] = ufldrop(k,C,y,p)
%UFLDROP Drop construction procedure for uncapacitated facility location.
% [y,TC,X] = ufldrop(k,C)
%          = ufldrop(k,C,y),    drop only from sites in y
%          = ufldrop(k,C,y,p), drop to exactly p NFs
%     k = n-element fixed cost vector, where k(i) is cost of NF at Site i
%         (if scalar, then same fixed cost)
%     C = n x m variable cost matrix,
%         where C(i,j) is the cost of serving EF j from NF i
%     p = fixed number of NFs to locate
%     y = NF site index vector
%    TC = total cost
%       = sum(k(y)) + sum(sum(C(X)))
%     X = n x m logical matrix, where X(i,j) = 1 if EF j allocated to NF i
%
% Example (Example 8.8 in Francis, Fac Layout and Loc, 2nd ed.):
% k = [8     8    10     8     9     8]
% C = [0     3     7    10     6     4
%      3     0     4     7     6     7
%      7     4     0     3     6     8
%     10     7     3     0     7     8
%      6     6     6     7     0     2
%      4     7     8     8     2     0]
% [y,TC,X] = ufldrop(k,C);       y,TC,full(X)
% [y,TC,X] = ufldrop(k,C,3:6); y,TC,full(X)  % Drop only from sites 3 to 6
%
% Based on Fig. 7.3 in M.S. Daskin, Network abd Discrete Location, 1995

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,4);

C = C';  % Make column-based to speed up NF indexing
[m,n] = size(C);
if isscalar(k), k = repmat(k,1,n); else k = k(:)'; end

if nargin < 3 || isempty(y), y = (1:n)'; else y = y(:)'; end
if nargin < 4, p = []; end

if length(k) ~= n || any(k < 0)
   error('"k" must be a non-negative n-element vector.')
elseif ~isempty(y) && (any(y < 1) || any(y > n) || ...
      length(y) ~= length(unique(y)))
   error('"y" must contain integers between 1 and n.')
elseif ~isempty(p) && (~isscalar(p) || p > n || p < 1)
   error('"p" must be between 1 and "n".')
elseif ~isempty(p) && ~isempty(y) && length(y) < p
   error('"p" cannot be greater than length of "y"')
end
% End (Input Error Checking) **********************************************

TC = sum(k(y)) + sum(min(C(:,y),[],2));

TC1 = Inf;
if length(y) > 1, done = false; else done = true; end
while ~done
   [c1,idx] = min(C(:,y),[],2);
   k1 = sum(k(y));
   for i = 1:length(y)
      is = i == idx;
      TCi = k1 - k(y(i)) + sum(c1(~is)) + ...
         sum(min(C(is,y([1:i-1 i+1:end])),[],2));
      if TCi < TC1
         [i1,TC1] = deal(i,TCi);
      end
   end
   if (isempty(p) && TC1 < TC) || (~isempty(p) && length(y) > p)
      y(i1) = [];
      TC = TC1;
      if ~isempty(p), TC1 = Inf; end
   else
      done = true;
   end
end

y = sort(y(:)');
X = logical(sparse(y(argmin(C(:,y),2)),1:m,1,n,m));
