function idx = rte2idx(rtein)
%RTE2IDX Convert route to shipment index vector.
% idx = rte2idx(rte)
%   rte = route vector
%       = m-element cell array of m route vectors
%   idx = shipment index vector, such that idx = rte(isorigin(rte))
%       = m-element cell array of m shipment index vectors
%       
% Example:
% rte = [23   15   6   23   27   17   24   27   15   17   6   24];
% idx = rte2idx(rte)    % idx = 23   15   6   27   17   24

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
checkrte(rtein)
% End (Input Error Checking) **********************************************

if ~iscell(rtein), rte = {rtein}; else rte = rtein; end

idx = cell(size(rte));
for i = 1:length(rte)
   idx{i} = rte{i}(isorigin(rte{i}));
end

if ~iscell(rtein), idx = idx{:}; end
