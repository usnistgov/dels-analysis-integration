function y = isint(x,TolInt)
%ISINT True for integer elements (within tolerance).
%      y = isint(x,TolInt)
%        = abs(x-round(x)) < TolInt
% TolInt = integer tolerance
%        = [0.01*sqrt(eps)], default

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,2);
if nargin < 2 || isempty(TolInt), TolInt = 0.01*sqrt(eps); end
% End (Input Error Checking) **********************************************

y = abs(x-round(x)) < TolInt;
