function [y,TC,X] = pmedian(p,C,dodisp)
%PMEDIAN Hybrid algorithm for p-median location.
% [y,TC,X] = pmedian(p,C)
%          = pmedian(p,C,dodisp),  display intermediate results
%     p = scalar number of NFs to locate
%     C = n x m variable cost matrix,
%         where C(i,j) is the cost of serving EF j from NF i
%dodisp = true, default
%     y = p-element NF site index vector
%    TC = total cost
%       = sum(sum(C(X)))
%     X = n x m logical matrix, where X(i,j) = 1 if EF j allocated to NF i
%
% Algorithm: Report the minimum of UFLADD(0,C,[],p) followed by 
% UFLXCHG(O,C,yADD) and UFLDROP(0,C,[],p) followed by UFLXCHG(O,C,yDROP),
% where yADD and yDROP are the p-element NF site index vector returned by
% UFLADD and UFLDROP for a fixed number of NFs
%
% Example (Example 8.8 in Francis, Fac Layout and Loc, 2nd ed.):
% p = 2
% C = [0     3     7    10     6     4
%      3     0     4     7     6     7
%      7     4     0     3     6     8
%     10     7     3     0     7     8
%      6     6     6     7     0     2
%      4     7     8     8     2     0]
% [y,TC,X] = pmedian(p,C);       y,TC,full(X)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,3);

[n,m] = size(C);
if nargin < 3 || isempty(dodisp), dodisp = true; end

if ~isscalar(p) || p > n || p < 1
   error('"p" must be between 1 and "n".')
elseif ~isscalar(dodisp) || ~islogical(dodisp)
   error('"dodisp" must be a logical scalar.')
end
% End (Input Error Checking) **********************************************

[y,TC] = ufladd(0,C,[],p); if dodisp, fprintf('  Add: %f\n',TC), end
[y,TC] = uflxchg(0,C,y); if dodisp, fprintf(' Xchg: %f\n',TC), end

[y1,TC1] = ufldrop(0,C,[],p); if dodisp, fprintf(' Drop: %f\n',TC1), end
[y1,TC1] = uflxchg(0,C,y1); if dodisp, fprintf(' Xchg: %f\n',TC1), end

if TC1 < TC, TC = TC1; y = y1; end
if dodisp, fprintf('Final: %f\n',TC), end

y = sort(y);
X = logical(sparse(y(argmin(C(y,:),1)),1:m,1,n,m));
