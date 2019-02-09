function rLTL = rateLTL(q,s,d,ppi)
%RATELTL Determine estimated LTL rate.
% rLTL = rateLTL(q,s,d,ppi)
%    q = weight of shipment (tons)
%    s = density of shipment (lb/ft^3)
%    d = distance of shipment (mi)
%  ppi = LTL Producer Price Index
%      = 104.2, default, 2004 LTL PPI value
% rLTL = rate ($/ton-mi)
%
% Note: Any q < 150/2000 is set equal to 150/2000, and any d < 37 is set
% equal to 37. Inf returned for q > 5, d > 3354, and 2000*q/s > 650
%
% Based on LTL estimate in M.G. Kay and D.P. Warsing, "Modeling truck rates
% using publicly available empirical data," Int. J. Logistics Res. Appl.,
% 12(3):165–193, 2009.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,4)
if nargin < 4 || isempty(ppi), ppi = 104.2; end
n = [length(q(:)) length(s(:)) length(d(:))];
nun = length(unique(n));
% if (n(1) == 1 && diff(n(2:end)) ~= 0) || n(1) > 1 && diff(diff(n)) ~= 0
if nun > 2 || (nun == 2 && min(n) ~= 1)
   error('Length of q, s, and d must be the same.')
elseif length(ppi) ~= 1
   error('"ppi" must be a scalar.')
end
% End (Input Error Checking) **********************************************

b = [(-7/2) (1/7) (15/29) (1/8) 14 2 14];

minq = 150/2000; mind = 37;
q(q(:) < minq) = minq; d(d(:) < mind) = mind;

rLTL = ppi*(b(4)*s(:).^2 + b(5)) ./ ...
   ((b(1) + q(:).^b(2).*d(:).^b(3)) .* (s(:).^2 + b(6)*s(:) + b(7)));

is = (b(1) + q(:).^b(2).*d(:).^b(3)) < eps | ...
   q(:) > 5 | ...
   d(:) > 3354 | ...
   2000*q(:)./s(:) > 650;

rLTL(is) = Inf;

rLTL = reshape(rLTL,size(q));
