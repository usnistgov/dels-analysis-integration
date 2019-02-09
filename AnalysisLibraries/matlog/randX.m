function X = randX(P,n)
%RANDX Random generation of n points X that are within P's boundaries.
%     X = randX(P,n)
% Generates n x d matrix X of n random d-dimensional NF locations, where
% each dimension is within the min and max EF locations of P (if m = 1, 
% then each X(i,:) = P).
%     P = m x d matrix of m d-dimensional EF locations
%     n = number of NF locations to generate
%       = 1, default
%
% Example: Two X points within x = 0..2 and y = 0..3
% P = [0 0;2 0;2 3]
% X = randX(P,2)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,2);

if nargin < 2 || isempty(n), n = 1; end

if length(n(:)) ~= 1 || ~isint(n) || n < 1
   error('"n" must be a positive integer.')
elseif size(P,1) < 1
   error('P must have at least one point')
end
% End (Input Error Checking) **********************************************

if size(P,1) == 1
   X = P(ones(1,n),:);
else
   rangeP = max(P) - min(P);
   X = ones(n,1)*min(P) + rand(n,size(P,2)).*rangeP(ones(n,1),:);
end
