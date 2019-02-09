function [rte,TCr] = savings(rteTC_h,sh,IJS,dodisp)
%SAVINGS Savings procedure for route construction.
%[rte,TC] = savings(rteTC_h,sh,IJS,dodisp)
%         = savings(rteTC_h,sh,IJS,prte_h)
% rteTC_h = handle to route total cost function, rteTC_h(rte)
%     sh  = structure array with fields:
%          .b = beginning location of shipment
%          .e = ending location of shipment
%     IJS = 3-column savings list
%         = pairwisesavings(rteTC_h)
%  dodisp = display intermediate results = false, default
%  prte_h = handle to route plotting function, prte_h(rte)
%           (dodisp = true when handle input)
%     rte = route vector
%         = m-element cell array of m route vectors
%   TC(i) = total cost of route i

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,4)

if nargin < 4, dodisp = false; end
if isa(dodisp,'function_handle') prte_h = dodisp; dodisp = true;
else prte_h = []; end

if ~isa(rteTC_h,'function_handle')
   error('First argument must be a handle to a route cost function.')
end
if ~isempty(IJS) && (size(IJS,2) ~= 3 || ...
      any(max(IJS(:,[1 2]),[],1) > length(sh)))
   error('Incorrect savings list input.')
elseif ~islogical(dodisp) || ~isscalar(dodisp)
   error('Third argument must be a logical scalar.')
end
% End (Input Error Checking) **********************************************

TCr = [];
if isempty(IJS), rte = []; return, end
if length(sh) < 2
   rte = {[1 1]}; TCr = rteTC_h(rte{1}); return
end
i = IJS(:,1); j = IJS(:,2);

for k = 1:length(sh), TC1(k) = rteTC_h([k k]); end

if dodisp, fprintf('SAVINGS:\n'), end
inr = zeros(length(sh),1);
rte = []; did = []; Did = [];
n = 0; done = false;
while ~done
   ischg = false;
   for k = 1:length(i)
      ik = i(k); jk = j(k);
      if inr(ik) == 0 && inr(jk) == 0
         [rij,TCij] = mincostinsert([ik ik],[jk jk],rteTC_h,sh,true);
         sij = TC1(ik) + TC1(jk) - TCij;
         if sij > 0
            n = n + 1;
            rte{n} = rij; TCr(n) = TCij;
            inr(ik) = n; inr(jk) = n;
            ischg = true;
            did = [did; false(1,length(sh))];
            Did = [Did false(n-1,1); false(1,n)];
            if dodisp
               c = sum(rteTC_h(rte(~isnan(TCr))));
               fprintf('%f: Make Rte %d using %d and %d\n',c,n,ik,jk)
               % fprintf(' %d',rij),fprintf('\n')
            end
            if ~isempty(prte_h) prte_h(rte(~isnan(TCr))), end
         end
      elseif xor(inr(ik),inr(jk))
         if inr(ik) == 0, [jk,ik] = deal(ik,jk); end
         if ~did(inr(ik),jk)
            [rij,TCij] = mincostinsert(...
               [jk jk],rte{inr(ik)},rteTC_h,sh,true);
            did(inr(ik),jk) = true;
            sij = TC1(jk) + TCr(inr(ik)) - TCij;
            if sij > 0
               rte{inr(ik)} = rij; TCr(inr(ik)) = TCij;
               inr(jk) = inr(ik);
               ischg = true;
               did(inr(ik),:) = false;
               Did(inr(ik),:) = false; Did(:,inr(ik)) = false;
               if dodisp
                  c = sum(rteTC_h(rte(~isnan(TCr))));
                  fprintf('%f: Add %d to Rte %d\n',c,jk,inr(ik))
                  % fprintf(' %d',rij),fprintf('\n')
               end
               if ~isempty(prte_h) prte_h(rte(~isnan(TCr))), end
            end
         end
      elseif inr(ik) ~= inr(jk) && ...
            ~(Did(inr(ik),inr(jk)) || Did(inr(jk),inr(ik)))
         [rij,TCij] = mincostinsert(...
            rte{inr(ik)},rte{inr(jk)},rteTC_h,sh,true);
         Did(inr(ik),inr(jk)) = true; Did(inr(jk),inr(ik)) = true;
         if ~isnan(rij)
            sij = TCr(inr(ik)) + TCr(inr(jk)) - TCij;
            if sij > 0
               inrjk = inr(jk);
               inr(rte{inrjk}(isorigin(rte{inrjk}))) = inr(ik);
               rte{inrjk} = NaN; TCr(inrjk) = NaN;
               rte{inr(ik)} = rij; TCr(inr(ik)) = TCij;
               ischg = true;
               if dodisp
                  c = sum(rteTC_h(rte(~isnan(TCr))));
                  fprintf('%f: Combine Rte %d to Rte %d\n',c,inrjk,inr(ik))
                  %fprintf(' %d',rij),fprintf('\n')
               end
               if ~isempty(prte_h) prte_h(rte(~isnan(TCr))), end
            end
         end
      end
   end
   if ~ischg || all(inr)
      done = true;
   elseif dodisp
      % fprintf('Starting next pass through savings list\n')
   end
end

if ~isempty(rte), rte(isnan(TCr)) = []; end
if ~isempty(rte), TCr(isnan(TCr)) = []; end

if dodisp, fprintf('\n'), end


