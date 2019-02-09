function [TLC,TC,IC] = totlogcost(q,c,sh)
%TOTLOGCOST Calculate total logistics cost.
% [TLC,TC,IC] = totlogcost(q,c,sh)
%     q = single shipment weight (tons)
%     c = transport charge ($ per shipment)
%    sh = structure array with required fields:
%        .f = annual demand (tons/yr)
%        .a = inventory 0-D fraction
%        .v = shipment value ($/ton)
%        .h = annual holding cost fraction (1/yr)
%   TLC = minimum total logistics cost ($/yr) = TC + IC
%    TC = transport cost ($/yr) = c*f/q
%    IC = cycle inventory cost ($/yr) = q*a*v*h

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,3)

if ~isfield(sh,'f')
   error('Required field "f" missing in shipment structure.')
elseif ~(isfield(sh,'a') && isfield(sh,'v') && isfield(sh,'h'))
   error('Required field a, v, and/or h missing in shipment structure.')
elseif length(sh(:)) > 1 && ...
      ~isequal(length(q(:)),length(c(:)),length(sh(:)))
   error('Length of q, c, and sh must be the same.')
elseif length(sh(:)) == 1 && ~isequal(length(q(:)),length(c(:)))
   error('Length of q and c must be the same.')
end
% End (Input Error Checking) **********************************************

if length(sh(:)) == 1
   TC = sh.f * reshape(c,size(q)) ./ max(0,q);
   IC = max(0,q) * (sh.v*sh.a*sh.h);
else
   TC = reshape(c,size(q)) .* reshape([sh.f],size(q)) ./ max(0,q);
   IC = max(0,q) .* reshape([sh.v].*[sh.a].*[sh.h],size(q));
end

% TLC(is0(c)) = 0;  % c == 0 => TLC = NaN
TC(is0(c)) = 0;   % c == 0 => TC = NaN

TLC = TC + IC;




