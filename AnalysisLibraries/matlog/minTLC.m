function [TLC,q,isLTL] = minTLC(sh,tr,ppiLTL,D,rtein)
%MINTLC Minimum total logistics cost comparing TL and LTL.
% [TLC,q,isLTL] = minTLC(sh,tr,ppiLTL)       % minimum of TL and LTL  
%               = minTLC(sh,tr)              % only TL
%               = minTLC(sh,[],ppiLTL)       % only LTL
%               = minTLC(sh,tr,ppiLTL,D)     % use D to determine dist
%               = minTLC(sh,tr,[],D,rte)     % min TLC for route(s)
%                                            % (only TL considered)
%    sh = structure array with fields:
%        .f = annual demand (tons/yr)
%        .s = shipment density (lb/ft^3)
%        .a = inventory 0-D fraction
%        .v = unit shipment value ($/ton)
%        .h = inventory carrying rate (1/yr)
%       = required field if D not provided
%        .d = shipment distance (mi)
%       = required fields if D provided
%        .b = beginning location of shipment
%        .e = ending location of shipment
%       = optional fields to use to treat single shipment routes as
%         independent shipments
%        .TLC1  = minimum TLC for shipment ($/yr)
%        .q1    = optimal weight (tons)
%        .isLTL = true if LTL minimizes TLC for shipment
%    tr = structure with fields:
%        .r   = transport rate ($/mi)
%        .Kwt = weight capacity of trailer (tons) = Inf, default
%        .Kcu = cube capacity of trailer (ft^3) = Inf, default
%        .ppiTL = TL Producer Price Index = 102.7 * (tr.r/2), default where
%                 the ratio of tr.r to 2 is used as a PPI approximation 
%                 since $2 per mile is average tr.r for 2004
%                 and 102.7 is the average TL PPI for 2004
%ppiLTL = LTL Producer Price Index = 104.2, default, average 2004 LTL PPI
%     D = matrix of inter-location distances
%   rte = route vector of shipments (if specified, sh.TLC1,q1,isLTL,c1 are
%         used for single shipment routes)
%       = m-element cell array of m route vectors
%   TLC = minimum total logistics cost ($/yr)
%       = min TLC(i) for sh(i), if rte not provided
%       = min TLC for shipments in route, if rte provided
%       = m-element vector, min TLC(i) for rte{i}
%     q = optimal single shipment weight (tons)
%       = q(i) for sh(i), if rte not provided
%       = q(i) for sh(i) in route, if single rte provided
%       = cell array, where q{i}(j) weight for sh(j) in rte{i}
% isLTL = logical vector, true if LTL minimizes TLC for shipment

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,5)

if nargin < 3, ppiLTL = []; end
if nargin < 4, D = []; end
if nargin < 5, rtein = []; end

checkrte(rtein,sh)
if isempty(rtein)
   do1shmt = true;
   if isempty(tr), doTL = false; else doTL = true; end
   if nargin < 3, doLTL = false; else doLTL = true; end
else
   do1shmt = false;
end

if ~isempty(rtein) && isfield(sh,'TLC1') && isfield(sh,'q1') && ...
      isfield(sh,'isLTL')
   do1rte = true; else do1rte = false;
end

if ~isfield(sh,'f')
   error('Required field f missing in shipment structure.')
elseif ~(isfield(sh,'a') && isfield(sh,'v') && isfield(sh,'h'))
   error('Required field a, v, and/or h missing in shipment structure.')
elseif ~do1shmt && ~isfield(tr,'r')
   error('Required field "r" missing in truck structure.')
elseif do1shmt && ~isfield(sh,'d') && isempty(D)
   error('Field d in shipment structure or input D must be provided.')
elseif ~do1shmt && isempty(D)
   error('Input D must be provided.')
elseif do1shmt && ~doTL && ~doLTL
   error('Must specify tr and/or ppiLTL.')
end
% End (Input Error Checking) **********************************************

if (~do1shmt || doTL) && (~isfield(tr,'ppiTL') || isempty(tr.ppiTL))
   tr.ppiTL = 102.7 * (tr.r/2);
end

if ~do1shmt
   if ~iscell(rtein), rte = {rtein}; else rte = rtein; end
   TLC = zeros(length(rte),1);
   isLTL = false(length(rte),1);
   q = cell(length(rte),1);
   for i = 1:length(rte)
      if do1rte && length(rte{i}) == 2
         ri = rte2idx(rte{i});
         TLC(i) = sh(ri).TLC1; q{i} = sh(ri).q1; isLTL(i) = sh(ri).isLTL;
      else
         [TLC(i),q{i}] = minTLCrte(rte{i},sh,D,tr);
      end
   end
   if ~iscell(rtein), q = q{:}; end
else
   if ~isempty(D), sh = vec2struct(sh,'d',diag(D([sh.b],[sh.e]))); end
   [TLC,q] = deal(Inf(size(sh)));
   if doTL
      q = optTLq(sh,tr,mincharge(reshape([sh.d],size(sh)),tr.r));
      if doLTL
         c = transcharge(q,sh,tr,ppiLTL);
      else
         c = transcharge(q,sh,tr);
      end
      TLC = totlogcost(q,c,sh);
   end
   isLTL = false(size(sh));
   if doLTL
      qLTL = optLTLq(sh,ppiLTL);
      cLTL = transcharge(qLTL,sh,[],ppiLTL);
      TLCltl = totlogcost(qLTL,cLTL,sh);
      isLTL = TLCltl < TLC;
      TLC(isLTL) = TLCltl(isLTL);
      q(isLTL) = qLTL(isLTL);
   end
end


% *************************************************************************
% *************************************************************************
% *************************************************************************
function [TLC,q] = minTLCrte(rte,sh,D,tr)

sh = sh(rte2idx(rte));
rte = rtenorm(rte);
ld = rte2ldmx(rte);

ash = aggshmt(sh);
if ~isempty(D)
   d = rteTC(rte,sh,D,tr);
   ash.d = d;
%    nLU = sum(diff(rte2loc(rte,sh))~=0)+1;  % Num L/U at different locations
%    MC = nLU * mincharge(d,tr)/2;           % Half MC for each L and U
   MC = mincharge(d,tr.ppiTL,rte,sh);
else
   MC = 0;
end

q = optTLq(ash,struct('r',tr.r),MC);
q = q*[sh.f]'/ash.f;

k = 1;
for i = 1:length(ld)
   k = min(k, maxpayld(aggshmt(sh(ld{i})),tr)/sum(q(ld{i})));
end
q = k*q;

TLC = totlogcost(sum(q),transcharge(sum(q),ash,struct('r',tr.r)),ash);


% *************************************************************************
% *************************************************************************
% *************************************************************************
function q = optTLq(sh,tr,MC)

f = reshape([sh.f],size(sh));
d = reshape([sh.d],size(sh));
qmax = reshape(maxpayld(sh,tr),size(sh));
avh = reshape([sh.v].*[sh.a].*[sh.h],size(sh));
q = min(qmax, sqrt(max(tr.r*d,MC).*f./avh));


% *************************************************************************
% *************************************************************************
% *************************************************************************
function q = optLTLq(sh,ppiLTL)

persistent opt
if isempty(opt)
   opt = optimset('fminbnd');
   opt = optimset(opt,'Display','off');
   if length(sh) > 100  % Speed-up optimization when many shipments
%       opt = optimset(opt,'TolX',sqrt(opt.TolX),'TolFun',sqrt(opt.TolFun));
      opt = optimset(opt,'TolX',sqrt(opt.TolX));
%       opt = optimset(opt,'MaxFunEvals',100,'MaxIter',100);
   end
end
q = zeros(size(sh));
for i = 1:length(sh)
   TLC = @(q) totlogcost(q,transcharge(q,sh(i),[],ppiLTL),sh(i));
   qLB = 150/2000;
   qUB = 650*sh(i).s/2000;
%    q0 = min(1, max(600/2000, 0.25*650*sh(i).s/2000)); % Make feasible
   if sh(i).f == 0
      q(i) = 0;
   elseif qLB < qUB
      q(i) = fminbnd(TLC,qLB,qUB,opt);
   else
      q(i) = Inf;
   end
end


