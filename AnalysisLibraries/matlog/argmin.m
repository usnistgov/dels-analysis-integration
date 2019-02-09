function [i,j,y] = argmin(X,DIM)
%ARGMIN Indices of minimum component.
%[i,j,y] = argmin(X),     where y = X(i,j) = MIN(MIN(X))
%      i = argmin(X),     where [y,i] = MIN(X)
%      i = argmin(X,DIM), where [y,i] = MIN(X,[],dim)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin > 1 && nargout > 1
   error('DIM can only be used with a single output argument.')
end
% End (Input Error Checking) **********************************************

if nargin < 2
   [y,i] = min(X);
else
   [y,i] = min(X,[],DIM);
end
if nargout > 1
   if size(X,1) == 1
      j = i; i = 1;
   elseif size(X,2) == 1
      j = 1;
   else
      [y,j] = min(y); i = i(j);
   end
end


