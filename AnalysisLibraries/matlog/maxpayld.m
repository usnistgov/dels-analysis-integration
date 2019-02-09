function qmax = maxpayld(s,tr)
%MAXPAYLD Determine maximum payload.
%  qmax = maxpayld(s,tr)
%       = maxpayld(sh,tr)
%     s = vector of shipment density (lb/ft^3)
%    sh = structure array with field:
%        .s = shipment density (lb/ft^3)
%    tr = structure with fields:
%        .Kwt = weight capacity of trailer (tons)
%             = Inf, default
%        .Kcu = cube capacity of trailer (ft^3)
%             = Inf, default
%  qmax = maximum payload (tons)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if ~isvector(s) && ~isstruct(s)
   error('First input must be a vector or a structure.')
elseif isstruct(s) && ~isfield(s,'s')
   error('Required field "s" missing in shipment structure.')
elseif ~isstruct(tr)
   error('Second input must be a structure.')
end
if ~isfield(tr,'Kwt'), tr.Kwt = Inf; end
if ~isfield(tr,'Kcu'), tr.Kcu = Inf; end
% End (Input Error Checking) **********************************************

if isstruct(s), s = reshape([s.s],size(s)); end
qmax = min(tr.Kwt,s*tr.Kcu/2000);
