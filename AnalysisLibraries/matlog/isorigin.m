function is = isorigin(rte)
%ISORIGIN Identify origin of each shipment in route.
% is = isorigin(rte)
%   rte = route vector
%    is = logical vector, such that is(i) = true if rte(i) is origin

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
checkrte(rte,[],true)
% End (Input Error Checking) **********************************************

rte = argsort(rte);
is = false(size(rte));
is(rte(1:2:end)) = true;
