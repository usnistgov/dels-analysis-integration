function [F,TC] = trans(C,s,d)
%TRANS Transportation and assignment problems.
%[F,TC] = trans(C,s,d), transportation problem
%       = trans(C),     assignment problem
%     C = m x n matrix of costs
%     s = m-element vector of supplies
%       = [1], default
%     d = n-element vector of demands
%       = [1], default
%     F = m x n matrix of flows
%    TC = total cost
%
% Example:
% C = [8 6 10 9; 9 12 13 7;14 9 16 5];
% dem = [45 20 30 30];
% sup = [55 50 40];
% [F,TC] = trans(C,sup,dem)
% % F =
% %      5    20    30     0
% %     40     0     0     0
% %      0     0     0    30
% % TC =
% %    970
%
% Note: LINPROG is used as the LP solver

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,3);

[m,n] = size(C);

if nargin < 2 || isempty(s), s = ones(m,1); else s = s(:); end
if nargin < 3 || isempty(d), d = ones(n,1); else d = d(:); end

if sum(s) < sum(d)
   error('Total supply cannot be less than total demand.')
elseif length(s) > m || any(s < 0)
   error('"s" must be an m-element non-negative vector.')
elseif length(d) > n || any(d < 0)
   error('"d" must be an n-element non-negative vector.')
end
% End (Input Error Checking) **********************************************

persistent opt

if isempty(opt)
   opt = optimset(linprog('defaults'),'Display','none');
end

C(C == 0) = NaN;       % Can have zero costs on arcs
s(isinf(s)) = sum(d);  % MCNF requires finite supplies

if all(isint(s)) && all(isint(d))
   TolInt = 1e-3;
else
   TolInt = [];
end

IJC = lev2list(C);
s = [s; -d];
lp = mcnf2lp(IJC,s);

x = linprog(lp{:},[],opt);

[f,TC] = lp2mcnf(x,IJC,s);
f(isint(f,TolInt)) = round(f(isint(f,TolInt)));
if isint(TC,TolInt), TC = round(TC); end
F = reshape(f,m,n);
