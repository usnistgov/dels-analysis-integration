function varargout = in2out(varargin)
% IN2OUT Convert variable number of inputs to outputs.
%[i,j,...] = in2out(i,j,...)
% Used in an anonymous function to provide two output arguments; e.g., to
% specify user-defined inequality and equality constraints in FMINCON:
% @(x) in2out(conineq(x),coneq(x))

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargout > nargin
   error('Number of outputs exceeds number of inputs.')
end
% End (Input Error Checking) **********************************************

for i = 1:nargin, varargout{i} = varargin{i}; end
