function sout = struct2scalar(s)
%STRUCT2SCALAR Remove non-scalar values from structure vector.
% s = struct2scalar(s)
% Removes all fields from stucture that are not real or logical scalars

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if ~isvector(s)
   error('Input must be a stucture vector.')
end
% End (Input Error Checking) **********************************************

c = squeeze(struct2cell(s));
is = all(cellfun(@isscalar,c),2) & (all(cellfun('isreal',c),2) | ...
   all(cellfun('islogical',c),2));
fd = fieldnames(s);
sout = reshape(cell2struct(c(is,:),fd(is),1),size(s));
