function M = sdisp(s,dotranspose,rowtitle,fracdig,allfrac,isnosep)
%SDISP Display structure vector with all scalar field values.
%     sdisp(s)
% M = sdisp(s)  % Return matrix of values
%   = sdisp(s,dotranspose) % Transpose array, where by default = true if
%                          % number of shipments is less than three times
%                          % the number of filds
%   = sdisp(s,[],rowtitle,fracdig,allfrac,isnosep)  % Pass inputs to MDISP
%   s = structure array
%
% Example:
% s = vec2struct('a',[1 2],'b',[3 4]);
% sdisp(s)  % s:  a  b
%           % -:------
%           % 1:  1  3
%           % 2:  2  4

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,6)

if nargin < 6, isnosep = []; end
if nargin < 5, allfrac = []; end
if nargin < 4, fracdig = []; end
if nargin < 3 || isempty(rowtitle), rowtitle = inputname(1); end
if nargin < 2 || isempty(dotranspose)
   isdefault = true;
   dotranspose = false;
else
   isdefault = false;
end

if ~isstruct(s) || ~isvector(s)
   error('Input must be a structure vector.')
elseif ~isscalar(dotranspose) || ...
      (~islogical(dotranspose) && ~any(dotranspose == [0 1]))
   error('Second argument must be a logical scalar.')
end
c = squeeze(struct2cell(s));
if isdefault
   if size(c,2)*3 < size(c,1)
      dotranspose = true;
   else
      dotranspose = false;
   end
end
if dotranspose, c = c'; end
isemp = all(cellfun(@isempty,c),2);
c(isemp,:) = [];
if all(all(cellfun(@isscalar,c)))
   isscal = true;
elseif all(all(cellfun(@isvector,c))) && ...
      all(all(diff(cellfun('prodofsize',c)) == 0)) && ...
      all(all(cellfun(@isreal,c) | cellfun(@islogical,c)))
   isscal = false;
else
   error('Structure array must have equal-length field values.')
end
% End (Input Error Checking) **********************************************

col = fieldnames(s);
col(isemp) = [];
row = [];
if dotranspose, [col,row] = deal(row,col); end
if isscal
   for i = 1:size(c,1)
      for j = 1:size(c,2)
         m(i,j) = double(c{i,j});
      end
   end
   mdisp(m',row,col,rowtitle,fracdig,allfrac,isnosep)
else
   n = length(c(:));
   for i = 1:n
      idx = find(cellfun(@islogical,c(i)));
      if ~isempty(idx)
         c(idx) = cellfun(@double,c(idx),'Uni',false);
      end
      m(:,i) = c{i};
   end
   mdisp(m,row,col,rowtitle,fracdig,allfrac,isnosep)
end

if nargout > 0, M = m'; end


