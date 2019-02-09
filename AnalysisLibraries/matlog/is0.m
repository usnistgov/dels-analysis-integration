function y = is0(x,Tol)
%IS0 True for zero elements (within tolerance).
%     y = is0(x,Tol)
%       = abs(x) < Tol
%   Tol = tolerance
%       = [0.01*sqrt(eps)], default

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,2);
if nargin < 2 || isempty(Tol), Tol = 0.01*sqrt(eps); end
% End (Input Error Checking) **********************************************

y = abs(x) < Tol;
