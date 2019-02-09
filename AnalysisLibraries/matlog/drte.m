function rte = drte(rtein)
%DRTE Convert destination of each shipment in route to negative value.
% rte = drte(rte)
%   rte = route vector
%       = m-element cell array of m route vectors

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
checkrte(rtein)
% End (Input Error Checking) **********************************************

if ~iscell(rtein), rte = {rtein}; else rte = rtein; end

for i = 1:length(rte)
   rte{i} = rte{:} .* (2*isorigin(rte{:})-1);
end

if ~iscell(rtein), rte = rte{:}; end
