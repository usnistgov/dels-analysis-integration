function cout = editcellstr(c)
%EDITCELLSTR Edit or create a cell array of strings.
% c = editcellstr(c)  % Edit an existing cell array of strings "c"
%   = editcellstr(n)  % Create an "n"-element array
%   = editcellstr     % Create up to 10-element array, with empty trailing
%                     % elements removed
%
% Examples:
% c = {'Boston','New York','Chicago'};
% c = editcellstr(c)
%
% c = editcellstr(3)
%
% c = editcellstr

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin < 1, c = []; end
if isempty(c), n = []; end
if ~isempty(c) && iscell(c)
   n = length(c);
else
   n = c; c = [];
end
   
if ~isempty(c) && ~iscellstr(c)
   error('"c" must be a cell vector of strings')
elseif ~isempty(n) && ...
      (~isreal(n) || length(n(:)) ~= 1 || n < 1 || n ~= round(n))
   error('"n" must be a positive integer.')
end
% End (Input Error Checking) **********************************************

if isempty(c)
   is0inarg = false;
   if isempty(n), n = 10; is0inarg = true; end
   titlestr = 'Create cell vector of strings';
   cout = inputdlg(cellstr(int2str((1:n)')),titlestr,1);
   if is0inarg && ~isempty(cout)
      while isequal(cout{end},'') && length(cout) > 1
         cout(end) = [];
      end
      if isequal(cout{1},'') && length(cout) == 1, cout = {}; end
   end
else
   titlestr = ['Edit cell vector: ' inputname(1)];
   cout = inputdlg(cellstr(int2str((1:n)')),titlestr,1,c);
   if size(c,1) == 1, cout = cout'; end
end
