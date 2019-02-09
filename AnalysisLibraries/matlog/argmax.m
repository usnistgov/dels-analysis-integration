function [i,j,y] = argmax(X,DIM)
%ARGMAX Indices of maximum component.
%[i,j,y] = argmax(X),     where y = X(i,j) = MAX(MAX(X))
%      i = argmax(X),     where [y,i] = MAX(X)
%      i = argmax(X,DIM), where [y,i] = MAX(X,[],dim)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin > 1 && nargout > 1
   error('DIM can only be used with a single output argument.')
end
% End (Input Error Checking) **********************************************

if nargin < 2
   [y,i] = max(X);
else
   [y,i] = max(X,[],DIM);
end
if nargout > 1
   if size(X,1) == 1
      j = i; i = 1;
   elseif size(X,2) == 1
      j = 1;
   else
      [y,j] = max(y); i = i(j);
   end
end


