function loc = rte2loc(rtein,sh,tr)
%RTE2LOC Convert route to location vector.
% loc = rte2loc(rte,sh)
%     = rte2loc(rte,sh,tr) % Include beginning/ending truck locations
%   rte = route vector
%       = m-element cell array of m route vectors
%    sh = structure array with fields:
%        .b = beginning location of shipment
%        .e = ending location of shipment
%    tr = (optional) structure with fields:
%        .b = beginning location of truck
%           = sh(rte(1)).b, default
%        .e = ending location of truck
%           = sh(rte(end)).e, default
%   loc = location vector
%       = m-element cell array of m location vectors
%       = NaN, degenerate location vector, which occurs if bloc = eloc and
%         truck returns to eloc before end of route (=> > one route)
%
% Example:
% rte = [1   2  -2  -1];
%  sh = vect2struct('b',[1 2],'e',[3 4]);
% loc = rte2loc(rte,sh)               % loc = 1   2   4   3

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,3)

if nargin < 3, tr = []; end

checkrte(rtein,sh)
if ~isfield(sh,'b') || ~isfield(sh,'e')
   error('Required field(s) missing in shipment structure.')
end
% End (Input Error Checking) **********************************************

if ~iscell(rtein), rte = {rtein}; else rte = rtein; end

loc = deal(cell(size(rte)));
for i = 1:length(rte)
   if isnan(rte{i}), loc{i} = NaN; continue, end
   
   loc{i} = zeros(size(rte{i}));
   is = isorigin(rte{i});
   loc{i}(is) = [sh(rte{i}(is)).b];
   loc{i}(~is) = [sh(rte{i}(~is)).e];
   isrow = size(loc{i},1) == 1;
   
   if ~isempty(tr)
      if isfield(tr,'b'), bloc = tr.b; else bloc = loc{i}(1); end
      if isfield(tr,'e'), eloc = tr.e; else eloc = loc{i}(end); end
      if bloc == eloc
         k = diff(bloc == loc{i});
         idx = find(k);
         if length(idx) > 2 || (length(idx) == 2 && ...
               (k(idx(1)) ~= -1 || k(idx(2)) ~= 1))
            loc{i} = NaN;
         end
      end
      loc{i} = [bloc; loc{i}(:); eloc];
   end

   if isrow, loc{i} = loc{i}(:)'; end
end

if ~iscell(rtein), loc = loc{:}; end


