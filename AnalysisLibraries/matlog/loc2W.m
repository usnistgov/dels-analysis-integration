function W = loc2W(loc,f,h)
%LOC2W Converts routings to weight matrix.
%   W = loc2W(loc,f,h)
% loc = routings; e.g., loc = {[1 2 3];[4 1]}, for routing 1-2-3 and 4-1
%   f = flow
%   h = handling cost (or equivalence factor)
%
% Example:
% loc = {[1 2 3 4],[2 4 1 2 3],[3 4 1 2 4]};
% f = [8 5 12];
% h = [3 2 1];
% W = loc2W(loc,f,h)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,3);

if ~iscell(loc), loc = {loc}; end
if nargin < 2, f = ones(1,length(loc)); end
if nargin < 3, h = ones(1,length(loc)); end

if length(loc) ~= length(f(:))
   error('Length of "f" must equal the number of routings.')
elseif length(loc) ~= length(h(:))
   error('Length of "h" must equal the number of routings.')
end
% End (Input Error Checking) **********************************************

n = max([loc{:}]);
W = zeros(n);

for i = 1:length(loc)
   for j = 1:length(loc{i})-1
      W(loc{i}(j),loc{i}(j+1)) = W(loc{i}(j),loc{i}(j+1)) + f(i)*h(i);
   end
end
