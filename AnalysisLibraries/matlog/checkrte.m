function checkrte(rtein,sh,isvec)
%CHECKRTE Check if valid route vector.
% checkrte(rte)              % Check route and throw error if not correct
% checkrte(rte,sh)           % Also check that rte values in sh range
%                            % and that sh has all scalar field values
% checkrte([],sh)            % Just check sh has all scalar field values
% checkrte(rte,[],isvec)     % Require single vector rte
%    rte = route vector
%        = m-element cell array of m route vectors
%     sh = structure array of shipments
%  isvec = rte must be only a single vector, not a cell array
%        = false, default

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
persistent rtein2
if isequal(rtein,rtein2), return, else rtein2 = rtein; end

narginchk(1,3)

if nargin < 2, sh = []; end
if nargin < 3 || isempty(isvec), isvec = false; end

if ~isempty(sh) && ~isstruct(sh)
   error('Input "sh" must be a structure.')
elseif ~islogical(isvec) || ~isscalar(isvec)
   error('Input "isvec" must be a logical scalar.')
end
% End (Input Error Checking) **********************************************

if ~isempty(rtein) && isvec && (~isreal(rtein) || ~isvector(rtein))
   error('Input must be a single route vector.')
end

if ~isempty(rtein) && ~iscell(rtein), rte = {rtein}; else rte = rtein; end

for i = 1:length(rte)
   r = rte{i};
   K = reshape(sort(r),2,length(r)/2);
   if ~isreal(r) || ~isvector(r) || mod(length(r),2) ~= 0 || ...
         any(diff(K)) || ~all(diff(K(1,:))) 
      error('Infeasible route vector.')
   end
end

if ~isempty(sh)
   c = squeeze(struct2cell(sh));
   if any(any(cellfun('prodofsize',c)~=1))
      error('Structure array must have all scalar field values.')
   elseif ~isempty(rtein) && max([rte{:}]) > length(sh)
      error('Value(s) in route vector exceed number of shipments.')
   end
end
