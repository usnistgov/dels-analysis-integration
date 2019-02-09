function [y,TC,X] = ufl(k,C,dodisp)
%UFL Hybrid algorithm for uncapacitated facility location.
% [y,TC,X] = ufl(k,C),
%          = ufl(k,C,dodisp),  display intermediate results
%     k = n-element fixed cost vector, where k(i) is cost of NF at Site i
%         (if scalar, then same fixed cost)
%     C = n x m variable cost matrix,
%         where C(i,j) is the cost of serving EF j from NF i
%dodisp = true, default
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
% [y,TC,X] = ufl(k,C);       y,TC,full(X)
%
% Based on Fig. 7.6 in M.S. Daskin, Network abd Discrete Location, 1995

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,3);

[n,m] = size(C);
if isscalar(k), k = repmat(k,n,1); else k = k(:); end
if nargin < 3 || isempty(dodisp), dodisp = true; end

if length(k) ~= n || any(k < 0)
   error('"k" must be a non-negative n-element vector.')
elseif ~isscalar(dodisp) || ~islogical(dodisp)
   error('"dodisp" must be a logical scalar.')
end
% End (Input Error Checking) **********************************************

[y1,TC1] = ufladd(k,C); if dodisp, fprintf('  Add: %f\n',TC1), end
done = false;
while ~done
   [y,TC] = uflxchg(k,C,y1); if dodisp, fprintf(' Xchg: %f\n',TC), end
   if ~isequal(y,y1)
      [y1,TC1] = ufladd(k,C,y);  if dodisp, fprintf('  Add: %f\n',TC1), end
      [y2,TC2] = ufldrop(k,C,y); if dodisp, fprintf(' Drop: %f\n',TC2), end
      if TC2 < TC1, TC1 = TC2; y1 = y2; end
      if TC1 >= TC, done = true; end
   else
      done = true;
   end
end
if dodisp, fprintf('Final: %f\n',TC), end

y = sort(y);
X = logical(sparse(y(argmin(C(y,:),1)),1:m,1,n,m));
