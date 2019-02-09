function [rte,minTC,TCij] = mincostinsert(rtei,rte,rteTC_h,sh,doNaN)
%MINCOSTINSERT Min cost insertion of route i into route j.
%[rte,TC,TCij] = mincostinsert(rtei,rtej,rteTC_h,sh,doNaN)
%    rtei = route i vector
%    rtej = route j vector
% rteTC_h = handle to route total cost function, rteTC_h(rte)
%      sh = structure array with fields:
%          .b = beginning location of shipment
%          .e = ending location of shipment
%   doNaN = return NaN for rte if cost increase
%         = false, default
%     rte = combined route vector
%         = NaN if cost increase
%      TC = total cost of combined route
%    TCij = original total cost of routes i and j

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
checkrte(rtei,sh)
checkrte(rte,sh)

if nargin < 5 || isempty(doNaN), doNaN = false; end

if ~isa(rteTC_h,'function_handle')
   error('Third argument must be a handle to a route cost function.')
end
% End (Input Error Checking) **********************************************

rteiTC = rteTC_h(rtei);
rtejTC = rteTC_h(rte);

if length(rte) < length(rtei) || ...
      (length(rte) == length(rtei) && rtejTC < rteiTC)
   [rte,rtei] = deal(rtei,rte);  % Comb route is dependent on i,j order;
end                              % also, shorter rtei to increase speed (?)

si = rte2idx(rtei);
for i = 1:length(si)
   loc = rte2loc(rte,sh);
   bloci = sh(si(i)).b;
   isduploc = [false loc(1:end-1) == loc(2:end)]; %Don't check dupicate loc
   [rte,minTC] = mincostshmtinsert(si(i),rte,rteTC_h,isduploc,loc,bloci);
   if isinf(minTC), return, end
end
if doNaN && minTC >= rteiTC + rtejTC
   rte = NaN;
end
TCij = rteiTC + rtejTC;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rte,minTC]= mincostshmtinsert(idx,rte,rteTC_h,isduploc,loc,bloci)
% Min cost insertion of shipment "idx" into route.

if any(idx == rte2idx(rte))
   % error('Shipment in both routes.')
   rte = NaN; minTC = Inf; return
end
minTC = Inf;
for i = 1:length(rte)+1
   for j = i:length(rte)+1
%       if i == 1 && j == 1 || isduploc(j-1), continue, end
      if j > 1 && isduploc(j-1), continue, end
      if i < length(rte) + 1 && bloci == loc(i) && rte(i) < 0,
         break,
      end
      rij = [rte(1:i-1) idx rte(i:j-1) idx rte(j:end)];
      cij = rteTC_h(rij);
%       disp([i j cij rij])
      if cij < minTC, minTC = cij; mini = i; minj = j; end
   end
end
if ~isinf(minTC)
   rte = [rte(1:mini-1) idx rte(mini:minj-1) idx rte(minj:end)];
else
   rte = NaN;
end
