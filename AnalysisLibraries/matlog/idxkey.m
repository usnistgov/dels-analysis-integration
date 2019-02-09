function key = idxkey(i)
% IDXKEY Create index key to array from unique integer values.
% key = idxkey(i)
%   i = m-element vector of unique positive integer values
% key = max(i)-element sparse vector, where, for scalar j,
%       key(j) <=> find(i == j) and, for j not in i,
%       key(j) => 0 <=> find(i == j) => []
%
% Example
% key = idxkey(uszip5('Code5'));
% uszip5(key(27606))
% % ans = 
% %         Code5: 27606
% %            XY: [-78.7155 35.7423]
% %            ST: {'NC'}
% %           Pop: 43210
% %         House: 19275
% %      LandArea: 24.7970
% %     WaterArea: 0.9000

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if ~isvector(i) || any(~isint(i)) || any(i <= 0)
   error('Input must be a vector of positive integers.')
end
[v,idx] = unique(i);
if length(v) ~= length(i)
   error('Integer elements must be unique.')
end
% End (Input Error Checking) **********************************************

key = sparse(v,1,idx);
