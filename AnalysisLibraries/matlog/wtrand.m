function r = wtrand(w0,w1,varargin)
%WTRAND Weighted random number.
%     r = wtrand(w0,w1,m,n)
%       = wtrand(w0,w1,[m n])
%    w0 = scalar nonnegative weight at 0
%    w1 = scalar nonnegative weight at 1
%     r = m x n matrix of pseuto-random values between 0 and 1
%
% Calculates the inverse of the power-function distribution, which is a
% special case of the beta with parameter b = 1:
%
%    r = rand(m,n) .^ (w0/w1);
%
% The mean of r is equal to the centroid of w0 and w1: w1/(w0 + w1).
% Numbers are uniformly distriuted when w0 = w1.
% Works for more than a 2-D matrix: r = wtrand(w0,w1,m,n,p,...)
%
% Example:
% w0 = 1; w1 = 2;
% r = wtrand(w0,w1,1,1000);
% numeric_mean = mean(r)
% analytic_mean = w1/(w0 + w1)
%
% (The help of Jim Wilson in formulating the procedure used to implement
%  this function is much appreciated.)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,Inf);

if ~isscalar(w0) || ~isscalar(w1)
   error('"w0" and "w1" must be scalars.')
elseif ~isreal(w0) || ~isreal(w1)
   error('"w0" and "w1" must be real numbers.')
elseif w0 < 0 || w1 < 0
   error('"w0" and "w1" must be nonnegative numbers.')
end
% End (Input Error Checking) **********************************************

r = rand(varargin{:}) .^ (w0/w1);
