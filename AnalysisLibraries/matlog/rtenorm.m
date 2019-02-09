function rte = rtenorm(rte,idx)
%RTENORM Normalize route vector.
%  nrte = rtenorm(rte)
%       = rtenorm(rte,idx)  % If specifying index order
%   rte = route vector
%   idx = shipment index vector
%       = rte2idx(rte), default
%  nrte = normalized route vector such that its indices range from 1 to n =
%         length(rte(rte>0)) for shipments idx(1) to n
%
% Example 1:
% rte = [100   22   33   22   45   500   33   66   500   100   45   66];
% idx = rte2idx(rte)  % idx = 100  22  33  45  500  66
% rtenorm(rte)        % ans = 1   2   3   2   4   5   3   6   5   1   4   6
% Example 2:
% idx = [33   45   500   66   22   100];
% rtenorm(rte,idx)    % ans = 6   5   1   5   2   3   1   4   3   6   2   4
%

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
checkrte(rte)
if nargin < 2, idx = []; end
% End (Input Error Checking) **********************************************

if isempty(idx)
   nidx = 1:length(rte)/2;
else
   idx0 = rte2idx(rte);
   if ~isequal(sort(idx),sort(idx0))
      error('Shipment index not valid.')
   end
   nidx = argsort(idx);
   nidx = nidx(invperm(argsort(idx0)));
end
% nidx2 = argsort(-rte(rte<0));
% rte(rte<0) = -nidx(argsort(nidx2(argsort(argsort(rte(rte>0))))));
% rte(rte>0) = nidx;
is = isorigin(rte);
nidx2 = argsort(rte(~is));
rte(~is) = nidx(argsort(nidx2(argsort(argsort(rte(is))))));
rte(is) = nidx;
