function [F,TC] = gtrans(C,s,d)
%GTRANS Greedy Heuristic for the transportation problem.
%[F,TC] = gtrans(C,s,d)
%     C = m x n matrix of costs
%     s = m-element vector of supplies
%       = [1], default
%     d = n-element vector of demands
%       = [1], default
%     F = m x n matrix of flows
%    TC = total cost

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ******************************************************
narginchk(1,3);

[m,n] = size(C);

if nargin < 2 || isempty(s), s = ones(m,1); else s = s(:); end
if nargin < 3 || isempty(d), d = ones(n,1); else d = d(:); end

if sum(s) < sum(d)
   error('Total supply cannot be less than total demand.')
elseif length(s) > m
   error('"s" must be an m-element vector.');
elseif length(d) > n
   error('"d" must be an n-element vector.');
end
% End (Input Error Checking) ************************************************

warning('GTRANS does not give optimal answers--use TRANS instead.')

F = zeros(m,n);
TC = 0;
while any(s) && any(d)
   idxs = find(s);
   idxd = find(d);
   [i,j,c] = argmin(C(idxs,idxd));
   f = min(s(idxs(i)),d(idxd(j)));
   F(idxs(i),idxd(j)) = f;
   TC = TC + c*f;
   s(idxs(i)) = s(idxs(i)) - f; s(is0(s)) = 0;
   d(idxd(j)) = d(idxd(j)) - f; d(is0(d)) = 0;
end
