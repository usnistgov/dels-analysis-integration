function [idx,idxm] = mand(varargin)
%MAND Multiple AND with real or cellstr vector pairs.
%  [idx,idxm] = mand(x1,y1,x2,y2,...,is1,is2,...)
%             = mand(x1,y1,x2,y2,...)
%   x1,x2,... = real or cellstr n-element vectors
%   y1,y2,... = real array or cellstr vectors, where each x-y forms a
%               pair
% is1,is2,... = (optional) logical vectors, with same number of elements
%               as each y
%         idx = n-element index vector of matches, where idx(i) = NaN if
%               no match or multiple matches found for element i
%        idxm = n-element cell array of possible multiple matches, where
%               idxmulti{i} = index vector of matches for element i, where
%               error is thrown if multiple matches found and idxmulti is
%               not returned
%
% Returns: idxm(i) = find(x1(i) == y1 & x2(i) == y2 & ...), for real x
%          idxm(i) = find(strncmpi(x1{i},y1,length(x1(i)) & ...
%                    strncmpi(x2{i},y2,length(x1(i)) & ...), for cellstr x
%    Note: If idxm not returned and multiple matches for element i, then 
%          tries to find one exact match amoung the idxm{i} to return as
%          idx(i)
%
% Example 1: Find the lon-lat of ZIP codes 32606 and 27606 
% XY = uszip5('XY',mand([32606 27606],uszip5('Code5')))
% % XY =
% %   -82.4441   29.6820
% %   -78.7155   35.7423
%
% Example 2: Find Find the lon-lat of Gainesville, FL and Raleigh, NC
% XY = uscity('XY',mand({'Gainesville','Raleigh'},uscity('Name'),...
%                       {'FL','NC'},uscity('ST')))
% % XY =
% %   -82.3459   29.6788
% %   -78.6414   35.8302

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 17-Feb-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,Inf)
   
isis = cellfun('islogical',varargin);
if any(isis)
   is = varargin(isis);
   varargin(isis) = [];
   if ~all(diff(cellfun('length',is))==0)
      error('All logical vectors must be the same length.')
   elseif ~all(cellfun(@isvector,is))
      error('All logical arrays must be vecotrs.')
   end
   isrow = cellfun('size',is,1) == 1;
   is(isrow) = cellfun(@transpose,is(isrow),'UniformOutput',false);
   is = all([is{:}],2);
else
   is = [];
end

if mod(length(varargin),2) ~= 0
   error('Must input vector pairs x-y.')
end
for i = 1:2:length(varargin)
   if isvector(varargin{i}) && ischar(varargin), varargin = {varargin}; end
end
x = varargin(1:2:length(varargin)-1);
y = varargin(2:2:length(varargin));

if all(cellfun(@ischar,x))
   x = arrayfun(@(x) {x},x);  % Convert single strings to cells
end

if ~all(diff(cellfun('length',x))==0)
   error('Vectors x must all be the same length.')
elseif ~all(diff(cellfun('length',y))==0)
   error('Vectors y must all be the same length.')
end

for i = 1:length(x)
   if ~isvector(x{i}) && ~isreal(x{i}) && ~iscellstr(x{i})
      error(['Input x' num2str(i) ' must be a real or cellstr vector.'])
   elseif ~isvector(y{i}) && ~isreal(y{i}) && ~iscellstr(y{i})
      error(['Input y' num2str(i) ' must be a real or cellstr vector.'])
   end
end
% End (Input Error Checking) **********************************************

is0 = is;
if isempty(is0), is0 = true(length(y{1}),1); end

idx = nan(length(x{1}),1);
idxm = cell(length(x{1}),1);
for i = 1:length(x{1})
   is = is0;
   for j = 1:length(x)
      if isreal(x{j}(i))
         isj = x{j}(i) == y{j};
      else
         isj = strncmpi(x{j}{i},y{j},length(x{j}{i}));
      end
      is = is & isj;
   end
   idxm{i} = find(is);
   if isscalar(idxm{i})
      idx(i) = idxm{i};
   else
      if isempty(idxm{i})
         if nargout < 2
            error(['No match found for element ' num2str(i) '.'])
         end
      else
         idxi = [];
         for j = 1:length(x)
            idxj = find(strcmpi(x{j}(i),y{j}(idxm{i})));
            if length(idxj) == 1
               if isempty(idxi)
                  idxi = idxm{i}(idxj);
               else
                  idxi = [];
                  break
               end
            end
         end
         if ~isempty(idxi)
            idx(i) = idxi;
         elseif nargout < 2
            error(['Mutiple matches found for element ' num2str(i) '.'])
         end
      end
   end
end
