function [rte,idx1,TC] = sh2rte(idx,rtein,rteTC_h)
%SH2RTE Create routes for shipments not in existing routes.
% [rte,idx1,TC] = sh2rte(idx,rte,rteTC_h)
%        = sh2rte(sh,rte,rteTC_h)
%    idx = index vector of shipments
%     sh = structure array of shipments
%          (used just to create idx = 1:length(sh))
%    rte = (optional) existing routes = [], default
%        = m-element cell array of m route vectors
%rteTC_h = (optional) handle to route total cost function used to display
%          results to command window if shipments added
%   idx1 = index vector of single-shipment routes created
%     TC = route total cost (only provided if rteTC_h input)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,3)

if nargin < 2, rtein = []; end
if nargin < 3, rteTC_h = []; end
if isstruct(idx), idx = 1:length(idx); end

checkrte(rtein)
if ~isvector(idx)
   error('Incorrect index vector of shipments.')
elseif ~isempty(rteTC_h) && ~isa(rteTC_h,'function_handle')
   error('Third argument must be a handle to a route cost function.')
elseif isempty(rteTC_h) && nargout > 2
   error('Route total cost provided only if rteTC_h input.')
end
% End (Input Error Checking) **********************************************

if ~iscell(rtein) && ~isempty(rtein), rte = {rtein}; else rte = rtein; end

if ~isempty(rte)
   ri = rte2idx([rte{:}]);
else
   ri = [];
end
idx1 = setdiff(idx,ri);
n = length(rte);
for i = 1:length(idx1)
   rte{n+i} = [idx1(i) idx1(i)];
end

if ~isempty(rteTC_h)
   TC = rteTC_h(rte);
   if ~isempty(idx1)
      fprintf('ADD SINGLE-SHIPMENT ROUTES:\n%f: Added shipments',sum(TC))
      fprintf(' %d',idx1), fprintf('\n\n')
   end
end


