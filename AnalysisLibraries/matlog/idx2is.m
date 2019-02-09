function is = idx2is(idx,n)
%IDX2IS Convert index vector to n-element logical vector.
%    is = idx2is(idx,n)
%   idx = index vector
%     n = length of logical vector
%    is = logical vector, is(idx) = 1
%
% Inverse of FIND(is) = idx, used to convert logical to index vectors.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,2)
[ridx,cidx] = size(idx);
idx = idx(:);

if isempty(n), n = max(idx); end

if any(idx < 1) || any(idx > n)
   error('Error in index vector idx.')
end
% End (Input Error Checking) **********************************************

is = false(n,1);
is(idx(:)) = 1;

if ridx == 1 && cidx > 1, is = is'; end
