function [rte,TC] = insertimprove(idxsh,rteTC_h,sh)
%INSERTIMPROVE Insert with improvement procedure for route construction.
%[rte,TC] = insertimprove(idxsh,rteTC_h,sh)
%   idxsh = shipment index vector specifying insertion order
% rteTC_h = handle to route total cost function, rteTC_h(rte)
%      sh = structure array with fields:
%          .b = beginning location of shipment
%          .e = ending location of shipment
%     rte = route vector
%      TC = total cost of route

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 24-Apr-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
checkrte([],sh)

if ~isa(rteTC_h,'function_handle')
   error('Second argument must be a handle to a route cost function.')
end
% End (Input Error Checking) **********************************************

rte = [idxsh(1) idxsh(1)];
if length(idxsh) > 1
   for i = 2:length(idxsh)
      [rte,TC] = twoopt(...
         mincostinsert([idxsh(i) idxsh(i)],rte,rteTC_h,sh),rteTC_h);
   end
else
   TC = rteTC_h(rte);
end
