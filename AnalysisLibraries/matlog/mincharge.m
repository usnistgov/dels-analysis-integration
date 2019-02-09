function [MC,AC] = mincharge(d,ppiTL,ppiLTL,sh,idx)
%MINCHARGE Minimum transport charge for TL, LTL, or multistop route.
%     MC = mincharge(d,ppiTL)            % TL
%        = mincharge(d,[],ppiLTL)        % LTL
%        = mincharge(d,ppiTL,rte,sh)     % Multistop route
%[MC,AC] = mincharge(d,ppiTL,rte,sh,idx) % (output allocated charge)
%      d = shipment distance (mi)
%  ppiTL = TL Producer Price Index = 102.7, default (2004 value)
% ppiLTL = LTL Producer Price Index = 104.2, default (2004 value)
%    rte = route vector
%     sh = structure array with fields:
%         .b = beginning location of shipment
%         .e = ending location of shipment
%    idx = shipment index vector
%        = rte2idx(rte), default
%     MC = Minimum charge
%        = (ppiTL/102.7) * 45, for TL and d > 0
%        = (ppiLTL/104.2) * (45 + (d^(28/19))/1625), for LTL and d > 0
%        = nLU * mincharge(d,ppiTL)/2, for Multistop, where nLU is no. L 
%          and U at different locations and half MC for each L and U
%        = 0, for d = 0
%     AC = allocated minimum charge for multistop route, where the
%          allocation is based on dividing mincharge(d,tr)/2) by the number
%          of consecutive L/U at same location
%
% LTL MC not valid for sh.d > 3432

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,5)

doTL = false; doLTL = false; doMS = false; doAC = false;
if nargin < 2, ppiTL = []; end
if nargin <= 2, doTL = true; end
if nargin == 3, doLTL = true; end
if nargin >= 4, doMS = true; rte = ppiLTL; end
if nargout > 1, doAC = true; end
if nargin < 5, idx = []; end

if ~isvector(d)
   error('First input must be a vector.')
elseif (doTL || doMS) && ~isempty(ppiTL) && ~isvector(ppiTL)
   error('Input "ppiTL" required.')
elseif doLTL && ~isempty(ppiTL)
   error('For LTL, "ppiTL" must be empty.')
elseif doLTL && ~isscalar(ppiLTL) && ~isempty(ppiLTL)
   error('For LTL, "ppiLTL" must be a scalar.')
elseif doAC && ~doMS
   error('Only multistop routes can be allocated.')
elseif isempty(idx) && doAC
   error('Input "idx" needed for allocated charges.')
elseif ~isempty(idx) && ~doAC
   error('Input "idx" only needed for allocated charges.')
elseif doMS
   checkrte(rte,[],true)
end
% End (Input Error Checking) **********************************************

MC = zeros(size(d));
tol0 = 1e-4;
if doTL
   if isempty(ppiTL), ppiTL = 102.7; end
   MC(~is0(d,tol0)) = (ppiTL/102.7) * 45;
elseif doLTL
   if any(d > 3354)
      error('Min charge not defined for "d" > 3354.')
   end
   if isempty(ppiLTL), ppiLTL = 104.2; end
   MC(~is0(d,tol0)) = ...
      (ppiLTL/104.2) * (45 + (d(~is0(d,tol0)).^(28/19))/1625);
else
   loc = rte2loc(rte,sh);
   nLU = sum(diff(loc) ~= 0) + 1;
   MC = nLU * mincharge(d,ppiTL)/2;
   if doAC
      floc = find([1 diff(loc) 1] ~= 0);
      n = diff(floc);
      ACloc = zeros(1,length(rte));
      for i = 1:length(n)
         ACloc(floc(i):floc(i+1)-1) = (mincharge(d,ppiTL)/2)/n(i);
      end
      AC = zeros(1,length(idx));
      for i = 1:length(AC)
         AC(i) = sum(ACloc(rtenorm(rte,idx) == i));
      end
   end
end


