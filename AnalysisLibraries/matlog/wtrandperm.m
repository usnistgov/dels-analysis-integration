function idx = wtrandperm(w,nin)
%WTRANDPERM Weighted random permutation.
%   idx = wtrandperm(w,n)
%     w = p-element vector of weights
%     n = length of output value (faster to use n if only first n elements
%         of idx are needed and n < length of w)
%       = length of w, default
%   idx = n-element permutation vector, where the probability that
%         idx(1) == i is w(i)/sum(w)
%
% See also RANDPERM and WTROUSELECT

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 17-Feb-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,2);

if nargin < 2 || isempty(nin), nin = length(w(:)); end

if isempty(w)
   idx = w;
elseif min(size(w)) ~= 1
   error('"w" must be a vector.')
end
% End (Input Error Checking) **********************************************

idxw = 1:length(w);

idxw0 = find(is0(w(:)'));  % Remove 0 elements of w and put at end of idx
idxw(idxw0) = [];
n = min(nin,length(w(:)) - length(idxw0));

idx = zeros(1,n);
for i = 1:n
   idxi = wtrouselect(w(idxw));
   idx(i) = idxw(idxi);
   idxw(idxi) = [];
end

idx = [idx idxw0];
idx = idx(1:nin);

if size(w,2) == 1, idx = idx'; end
