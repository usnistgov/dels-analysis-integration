function C = padmat2cell(M)
%PADMAT2CELL Convert rows of NaN-padded matrix to cell array.
%     C = padmat2cell(M)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,1)
if ~isnumeric(M)
   error('M must be a numeric array.')
end
% End (Input Error Checking) **********************************************

C = cell(size(M,1),1);

for i = 1:size(M,1)
   C{i} = M(i,~isnan(M(i,:)));
end
