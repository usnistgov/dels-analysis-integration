function [y,TC,X] = uflxchg(k,C,y)
%UFLXCHG Exchange best improvement procedure for uncap. facility location.
% [y,TC,X] = uflxchg(k,C,y)
%     k = n-element fixed cost vector, where k(i) is cost of NF at Site i
%         (if scalar, then same fixed cost)
%     C = n x m variable cost matrix,
%         where C(i,j) is the cost of serving EF j from NF i
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
% [y,TC,X] = ufladd(k,C);     y,TC,full(X)
% [y,TC,X] = uflxchg(k,C,y);  y,TC,full(X)
%
% Based on Fig. 7.5 in M.S. Daskin, Network and Discrete Location, 1995

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,3);

C = C';  % Make column-based to speed up NF indexing
[m,n] = size(C);
if isscalar(k), k = repmat(k,1,n); else k = k(:)'; end
y = y(:)';

if length(k) ~= n || any(k < 0)
   error('"k" must be a non-negative n-element vector.')
elseif ~isempty(y) && (any(y < 1) || any(y > n) || ...
      length(y) ~= length(unique(y)))
   error('"y" must contain integers between 1 and n.')
end
% End (Input Error Checking) **********************************************

TC = sum(k(y)) + sum(min(C(:,y),[],2));

TC1 = Inf;
if length(y) > 1, done = false; else done = true; end
while ~done
   [c1,idx] = min(C(:,y),[],2);
   k1 = sum(k(y));
   ny = 1:n; ny(y) = [];
   for i = 1:length(y)
      is = i == idx;
      c1i = c1; c1i(is) = min(C(is,y([1:i-1 i+1:end])),[],2);
      for j = 1:length(ny)
         TCij = k1 - k(y(i)) + k(ny(j)) + sum(min(c1i,C(:,ny(j))));
         if TCij < TC1
            [i1,j1,TC1] = deal(i,j,TCij);
         end
      end
   end
   if TC1 < TC
      [ny(j1),y(i1)] = deal(y(i1),ny(j1));
      TC = TC1;
   else
      done = true;
   end
end

y = sort(y);
X = logical(sparse(y(argmin(C(:,y),2)),1:m,1,n,m));
