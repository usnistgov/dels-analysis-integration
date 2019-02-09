function c = file2cellstr(fname)
%FILE2CELLSTR Convert file to cell array.
% c = file2cellstr(fname)
% fname = name of file
%       = [], open dialog to get file name
%     c = cell array of strings, where each string is a line of the file

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin < 1 || isempty(fname)
   [fn,pn] = uigetfile('*.*','Select text file to covert to cell array');
   if fn == 0, c = {}; return, end  % Cancel dialog
   fname = fullfile(pn,fn);
end
% End (Input Error Checking) **********************************************

fid = fopen(fname);
if fid == -1, error('Error in opening file.'), end

i = 1;
while 1
   c{i} = fgetl(fid);
   if ~ischar(c{i}), break, end
   i = i + 1;
end

fclose(fid);
c = c(1:end-1)';
