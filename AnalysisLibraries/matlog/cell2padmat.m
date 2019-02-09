function M = cell2padmat(C,align)
%CELL2PADMAT Convert cell array of vectors to NaN-padded matrix.
%     M = cell2padmat(C,align)
% align = 1, left alignment (default)
%       = 2, right alignment

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,2)

if nargin < 2, align = 1; end

if ~iscell(C)
   error('C must be a cell array.')
elseif all(align ~= [1 2])
   error('Invalid "align" specified.')
end
% End (Input Error Checking) **********************************************

n = cellfun('size',C,2);
M = NaN * ones(length(C),max(n));

for i = 1:length(C)
   if align == 1
      M(i,1:n(i)) = C{i};
   else
      M(i,end-n(i)+1:end) = C{i};
   end
end
