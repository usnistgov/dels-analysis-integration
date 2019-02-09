function [i,j,y] = argsort(X,DIM)
%ARGSORT Indices of sort in ascending order.
%[i,j,y] = argsort(X),     where [i,j] = IND2SUB(SIZE(X),ARGSORT(X(:)))
%      I = argsort(X),     where [Y,II] = SORT(X);
%      I = argsort(X,DIM), where [Y,II] = SORT(X,DIM);

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin > 1 && nargout > 1
   error('DIM can only be used with a single output argument.')
end
% End (Input Error Checking) **********************************************

if nargout < 2
   if nargin < 2
      [y,i] = sort(X);
   else
      [y,i] = sort(X,DIM);
   end
else
   [y,i] = sort(X(:));
   if size(X,1) == 1
      j = i; i = ones(size(X,2),1);
   elseif size(X,2) == 1
      j = ones(size(X,1),1);
   else
      [i,j] = ind2sub(size(X),i);
   end
end


