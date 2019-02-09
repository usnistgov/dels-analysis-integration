function yseg = rtesegsum(rte,xsh)
% RTESEGSUM Cumulative sum over each segment of route.
%  yseg = rtesegsum(rte,xsh)
%   rte = route vector
%   xsh = vector of values for each shipment in route
%  yseg = cumulative sum of "xsh" over each segment of "rte"

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
checkrte(rte,[],true)
if length(rte)/2 ~= max(rte)
   error('Route not normalized (use RTENORM to normalize).')
elseif length(xsh(:)) ~= length(rte)/2
   str = inputname(2); if isempty(str), str = 'xsh'; end
   error(['Length of "' str '" must equal number shipments in route.'])
end
% End (Input Error Checking) **********************************************

yseg = cumsum(xsh(rte) .* (2*isorigin(rte)-1));
yseg(end) = [];
