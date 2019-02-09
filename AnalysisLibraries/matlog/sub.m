function varargout = sub(varargin)
% SUB Create subarray.
% sub(x,is)         % Output as 'ans'
% sub(x1,x2,...,is) % Output same name subarray in base workspace
% [sx1,...] = sub(x1,...,is) % Output subarrays
% sx = sub(x,'# < .5') % Match # to x and evaluate result
%    = sub(x,'#(:,1)') % Extract first column of x
% is = logical array used to create subarrays

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,Inf)
if nargin == 2 && ischar(varargin{end})
   sis = strrep(varargin{end},'#','varargin{1}');
   if isequal(sis,varargin{end})
      error('Must use # token in logical string.')
   else
      varargin{end} = eval(sis);
   end  
else
   if ~islogical(varargin{end})
      error('Last input argument must be a logical array.')
   elseif ~all(cellfun('isreal',varargin)) || ...
         any(diff(cellfun('prodofsize',varargin)) ~= 0)
      error('All inputs must be the same size.')
   end
   if nargout == 0 && nargin > 2
      for i = 1:nargin-1, if isempty(inputname(i))
            error('Input arguments must be workspace variables.')
         end, end
   elseif nargin > 2 && nargout ~= nargin - 1
      error('Number of outputs must equal number of inputs.')
   end
end
% End (Input Error Checking) **********************************************

if ~islogical(varargin{end})  % Might be '#(1:5)'
   varargout{1} = varargin{end};
   return
end

for i = 1:length(varargin)-1
   val{i} = varargin{i};
   val{i} = val{i}(varargin{end});
   if nargout == 0 && nargin > 2
      assignin('base',inputname(i),val{i})
   else
      varargout(i) = val(i);
   end
end
