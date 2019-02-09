function [rte,TC] = twoopt(rtein,rteTC_h,dodisp)
%TWOOPT 2-optimal exchange procedure for route improvement.
%[rte,TC] = twoopt(rtein,rteTC_h,dodisp)
%         = twoopt(rtein,rteTC_h,prte_h)
%     rte = route vector
%         = m-element cell array of m route vectors
% rteTC_h = handle to route total cost function, rteTC_h(rte)
%  dodisp = display intermediate results = false, default
%  prte_h = handle to route plotting function, prte_h(rte)
%           (dodisp = true when handle input)
%   TC(i) = total cost of route i

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,3)

if nargin < 3, dodisp = false; end
if isa(dodisp,'function_handle') prte_h = dodisp; dodisp = true;
else prte_h = []; end

checkrte(rtein)
if ~isa(rteTC_h,'function_handle')
   error('Second argument must be a handle to a route cost function.')
elseif ~islogical(dodisp) || ~isscalar(dodisp)
   error('Third argument must be a logical scalar.')
end
% End (Input Error Checking) **********************************************

if isempty(rtein), rte = []; TC = []; return, end
if ~iscell(rtein), rte = {rtein}; else rte = rtein; end

TC = zeros(length(rte),1);
if ~isempty(prte_h), prte_h(rte), end

if dodisp, fprintf('TWOOPT:\n'), end
for k = 1:length(rte), TC(k) = rteTC_h(rte{k}); end
for k = 1:length(rte)
   if dodisp
      fprintf('%f: %d: ',sum(TC),k)
      fprintf('%d ',rte{k}),fprintf('\n')
   end
   if length(rte{k}) < 3, continue, end
   done = false;
   while ~done
      done = true;
      for i = 1:length(rte{k})-1
         for j = i+1:length(rte{k})
            rij = [rte{k}(1:i-1) fliplr(rte{k}(i:j)) rte{k}(j+1:end)];
            %try checkrte(rij,[],false,false)
               TCij = rteTC_h(rij);
               if TCij < TC(k)
                  TC(k) = TCij;
                  rte{k} = rij;
                  if dodisp, fprintf('%f: %d: ',sum(TC),k),...
                        fprintf('%d ',rte{k}),fprintf('\n')
                  end
                  done = false;
                  if ~isempty(prte_h), prte_h(rte), end
               end
            %catch
            %end
            if ~done, break, end
         end % j
         if ~done, break, end
      end % i
   end % while
end % for

if ~iscell(rtein), rte = rte{:}; end
if dodisp, fprintf('\n'), end
