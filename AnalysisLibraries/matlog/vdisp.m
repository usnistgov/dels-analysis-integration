function vdisp(s,doTotal,doAvg)
%VDISP Display vectors.
% vdisp(str,doTotal,doAvg)
%    str = string of vector names or expressions that evaluate to a vector
%doTotal = display column total
%        = false, default
%  doAvg = display column average
%        = false, default
%
% Note: Comma's in str used to delimit vectors or expressions.
%
%Example:
% a = ones(2,1);
% vdisp('a,2*a')

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,3)

if nargin < 2 || isempty(doTotal), doTotal = false; end
if nargin < 3 || isempty(doAvg), doAvg = false; end
if ~isscalar(doTotal) || (~islogical(doTotal) && ~any(doTotal == [0 1]))
   error('Second argument must be a logical scalar.')
elseif ~isscalar(doAvg) || (~islogical(doAvg) && ~any(doAvg == [0 1]))
   error('Third argument must be a logical scalar.')
end
% End (Input Error Checking) **********************************************

i = 0;
while ~isempty(s)
   i = i + 1;
   [names{i},s] = strtok(s,',');
   names{i} = strtrim(names{i});
   val{i} = evalin('caller',names{i});
   val{i} = val{i}(:);
   if islogical(val{i}), val{i} = double(val{i}); end
end
val = cell2mat(val);
row = cellstr(num2str((1:size(val,1))'));
if doTotal
   val = [val; sum(val,1)];
   row = [row; {'Total'}];
end
if doAvg
   if ~doTotal
      val = [val; mean(val,1)];
   else
      val = [val; mean(val(1:end-1,:),1)];
   end
   row = [row; {'Avg'}];
end
mdisp(val,row,names,' ')
