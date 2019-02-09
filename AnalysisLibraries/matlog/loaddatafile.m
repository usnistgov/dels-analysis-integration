function varargout = loaddatafile(varargin0,nargout0,vn,fn)
%LOADDATAFILE Common code for data file functions.
% varargout = loaddatafile(varargin0,nargout0,vn,fn)
% varargin0 = 'varargin' of calling function
%  nargout0 = 'nargout' of calling function
%        vn = 'varnames' of calling function
%        fn = MFILENAME of calling function

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
errstr = [];
nargin0 = length(varargin0);
if nargin0 > 0 && ~ischar(varargin0{end})
   is = varargin0{end};
   varargin0 = varargin0(1:end-1);
   nargin0 = nargin0 - 1;
else
   is = [];
end
if nargout0 > 1 && nargin0 == 0 && nargout0 > length(vn)
   errstr = 'Too many output arguments.';
elseif nargout0 > 1 && nargin0 > 0 && nargin0 ~= nargout0
   errstr = ...
      'Number of output arguments not equal to number of input variables.';
elseif exist([fn,'.mat'],'file') ~= 2
   errstr = ['Data file ''',fn,'.mat'' not found.'];
elseif nargin0 > 0 && ~all(ismember(varargin0,vn))
   errstr = 'Input variable name does not match names in MAT file.';
end
% End (Input Error Checking) **********************************************

if nargin0 == 0, varargin0 = vn; end
c = {};
for i = 1:length(varargin0)  % To insure fields of vo in correct order
   c{2*i-1} = varargin0{i};
   c{2*i} = struct2cell(load(fn,varargin0{i}));
end
vo = struct(c{:});
if ~isempty(is), vo = subsetstruct(vo,is); end
if nargout0 <= 1 && nargin0 ~= 1
   varargout0 = {vo};
else
   varargout0 = struct2cell(vo);
end
varargout = {errstr,varargout0};
