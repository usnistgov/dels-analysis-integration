function c = num2cellstr(v)
%NUM2CELLSTR Create cell array of strings from numerical vector.
% c = num2cellstr(v)
%     v = n-element numerical vector
%     c = n-element cell array of strings
%
% Wrapper for cellstr(strjust(num2str(v(:)),'left'))

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if ~any(size(v) == 1) || ~isnumeric(v)
   error('Input argument must be a numerical vector.')
end
% End (Input Error Checking) **********************************************

c = cellstr(strjust(num2str(v(:)),'left'));

if size(v,1) == 1, c = c(:)'; end
