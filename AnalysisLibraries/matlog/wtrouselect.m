function Idx = wtrouselect(w,m,n)
%WTROUSELECT Weighted roulette selection.
%   Idx = wtrouselect(w,m,n)
%     w = p-element vector of weights
%   Idx = m x n matrix of random indices between 1 and p, where the
%         probability of selection for each index is proportional to its
%         weight; e.g., w = ones(1,p) => 1/p probability of selection
%
% Example:
% w = [0.5 0.25 0.25]         %  Half 1's, quarter 2's, and quarter 3's
% rng(141)           %  Only needed to duplicate this example
% Idx = wtrouselect(w,1,12)   %  Idx =  3  2  1  1  2  1  1  2  3  1  1  2

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,3);

if nargin < 2 || isempty(m), m = 1; end
if nargin < 3 || isempty(n), n = 1; end
% End (Input Error Checking) **********************************************

if sum(w(:)) == 0, Idx = NaN; return, end

d = [0 cumsum(w(:)')/sum(w(:))];
r = rand(m,n);

for i = 1:m
   for j = 1:n
      Idx(i,j)  = find(r(i,j) >= d(1:end-1) & r(i,j) < d(2:end));
   end
end
