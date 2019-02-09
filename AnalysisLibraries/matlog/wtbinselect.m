function is = wtbinselect(w,p)
%WTBINSELECT Weighted binary selection.
%    is = wtbinselect(w,p)
%     w = n-element vector of weights
%     p = scalar probability of selection
%    is = n-element logical vector of selected elements of w
%
% If all weights are the same, than probability that w(i) = 1 is "p";
% otherwise, probability is p * w(i)/mean(w):
%
%    is = rand(1,length(w)) < p * w/mean(w)
%
% Example 1:
% p = 0.4
% w = [1 2 4 1]
% rand('state',123)           %  Only needed to duplicate this example
% is = wtbinselect(w,p)       %  is = 1  1  1  0
% is = wtbinselect(w,p)       %  is = 0  0  1  0
% is = wtbinselect(w,p)       %  is = 1  0  1  1
%
% Example 2: Repeat 100 times to compare experimental results
%            to expected p * w/mean(w) and p values
% for i=1:100, is(i,:) = wtbinselect(w,p); end
% mean(is)                    %  ans = 0.2000  0.4000  0.8300  0.2100
% p * w/mean(w)               %  ans = 0.2000  0.4000  0.8000  0.2000
%                             %  41% of the elements of w are selected
% mean(sum(is,2))/length(w)   %  ans = 0.4100
% p                           %    p = 0.4000

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,2);

if length(w) ~= length(w(:)) || any(w) < 0
   error('"w" must be a vector of non-negative weights.')
elseif length(p(:)) ~= 1 || p < 0 || p > 1
   error('"p" must be a scalar value between 0 and 1.')
end
% End (Input Error Checking) **********************************************

iscolumnvec = false;
if size(w,2) == 1, iscolumnvec = true; end

is = rand(1,length(w)) < p * w/mean(w);

if iscolumnvec, is = is'; end
