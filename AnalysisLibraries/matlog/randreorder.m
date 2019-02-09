function X = randreorder(X,r)
%RANDREORDER Random re-ordering of an array.
%     X = rankreorder(X,r)
%     X = array
%     r = scalar between 0 and 1
%
% Initially, X = X(1:n,:); for i = 1:n, if rand < r, then
% X(i,:) placed at the end of X.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,2)

if ~ismatrix(X)
   error('"X" must be a two-dimensional array.')
elseif length(r(:)) ~= 1 || r < 0 || r > 1
   error('"r" must be a scalar between 0 and 1.')
end
% End (Input Error Checking) **********************************************

if size(X,1) == 1, X = X(:); isrow = 1; else isrow = 0; end

is = rand(1,size(X,1)) < r;

X = [X(~is,:); X(is,:)];
if isrow, X = X'; end
