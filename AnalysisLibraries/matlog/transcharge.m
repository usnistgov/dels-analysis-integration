function [c,isLTL,cTL,cLTL] = transcharge(q,sh,tr,ppiLTL)
%TRANSCHARGE Transport charge for TL and LTL.
% [c,isLTL,cTL,cLTL] = transcharge(q,sh,tr,ppiLTL)  % min of TL and LTL
%                    = transcharge(q,sh,tr)         % only TL
%                    = transcharge(q,sh,[],ppiLTL)  % only LTL
%     q = single shipment weight (tons)
%    sh = structure array with required fields:
%        .s = shipment density (lb/ft^3)
%        .d = shipment distance (mi)
%    tr = structure with fields:
%        .r     = transport rate ($/mi)
%        .Kwt   = weight capacity of trailer (tons) = Inf, default
%        .Kcu   = cube capacity of trailer (ft^3) = Inf, default
%        .ppiTL = TL Producer Price Index = 102.7 * (tr.r/2), default where
%                 the ratio of tr.r to 2 is used as a PPI approximation 
%                 since $2 per mile is average tr.r for 2004
%                 and 102.7 is the average TL PPI for 2004
%ppiLTL = LTL Producer Price Index = 104.2, default, average 2004 LTL PPI
%     c = transport charge ($ per shipment)
%       = min(max(cTL,MCtl), max(cLTL,MCltl))
%       = 0, if q = 0
% isLTL = logical vector, true if LTL minimizes charge for shipment
%   cTL = TL transport charge ($)
%  cLTL = LTL transport charge ($)
%
% Note: The use of ppiTL can be confusing. Using tr.r = $2/mi and expecting
% it to increase 2*tr.ppiTL/102.7 if tr.ppiTL = 110.9 is input will not
% work. If you are using a ppi adjusted $2/mi rate, then you should use
% tr.r = 2* ppiTL/102.7 and then can either not specify tr.ppiTL or use
% tr.ppiTL = ppiTL. The reason for this is that sometimes a non-53-foot
% truck is used and tr.r might be $1/mi but ppiTL can still be used to
% estimate the general truck inflation.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,4)

doTL = true; doLTL = true;
if isempty(tr), doTL = false; end
if nargin < 4, doLTL = false; end

if ~isvector(q)
   error('First input must be a vector.')
elseif any(isnan(q))
   error('Elements of first input cannot be NaN.')
elseif ~isstruct(sh)
   error('Second input must be a shipment structure.')
elseif ~isfield(sh,'d')
   error('Required field "d" missing in shipment structure.')
elseif doTL && ~isfield(tr,'r')
   error('Required field "r" missing in truck structure.')
elseif length(q(:)) ~= length(sh(:))
   error('Length of q and sh must be the same.')
elseif ~doTL && ~doLTL
   error('Must specify tr and/or ppiLTL.')
end
% End (Input Error Checking) **********************************************

tol0 = 1e-4;
d = reshape([sh.d],size(q));
cTL = Inf(size(q)); cLTL = cTL;
if doTL
   if ~isfield(tr,'ppiTL') || isempty(tr.ppiTL)
      tr.ppiTL = 102.7 * (tr.r/2);
   end
   qmax = maxpayld(reshape(sh,size(q)),tr); % = Inf if no Kwt and Kcu
   if any(isinf(qmax)), qmax(isinf(qmax)) = q(isinf(qmax)); end
   cTL = max(ceil(q./qmax) .* d * tr.r, mincharge(d,tr.ppiTL));
end
isLTL = false(size(q));
if doLTL
   cLTL = max(rateLTL(q,reshape([sh.s],size(q)),d,ppiLTL) .* q .* d, ...
      mincharge(min(d,3354),[],ppiLTL));
   isLTL = cLTL < cTL;
end
c = cTL;
c(isLTL) = cLTL(isLTL);
c(is0(q,tol0)) = 0;


