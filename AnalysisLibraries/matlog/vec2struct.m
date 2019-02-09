function s = vec2struct(s,varargin)
%VEC2STRUCT Add each element in vector to field in structure array.
% s = vec2struct(s,fn,vec)
%   = vec2struct(s,fn1,vec1,fn2,vec2,...)  % Add field-vector pairs
%   = vec2struct(fn,vec)                   % Create new structure
%   s = structure array
%  fn = fieldname
% vec = vector
%
% Example:
% s = vec2struct('a',[1 2],'b',[3 4]); sdisp(s)  % s:  a  b
%                                                % -:------
%                                                % 1:  1  3
%                                                % 2:  2  4

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if ~isstruct(s), varargin = {s,varargin{:}}; s = []; end

if mod(length(varargin),2) ~= 0
   error('Field-vector pair inputs required.')
end
fn = varargin(1:2:end);
vec = varargin(2:2:end);
n = cellfun(@length,vec);
if any(~(n == max(n) | n == 1))
   error('Length of vector inputs not all equal.')
elseif ~isempty(s) && max(n) > 1 && ...
      length(s) ~= max(n) && length(s) ~= 1
   error('Length of structure and vector inputs not equal.')
end
% End (Input Error Checking) **********************************************

n = max(max(n), length(s));
if ~isempty(s) && length(s) < n, s(1:n) = s; end

for i = 1:length(fn)
   if length(vec{i}(:)) == 1, vec{i} = repmat(vec{i},n,1); end
   fni = fn{i};
   veci = vec{i};
   for j = 1:n
      if isempty(vec{i})
         s(j).(fni) = [];
      else
         s(j).(fni) = veci(j);
      end
   end
end
