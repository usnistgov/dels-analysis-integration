function s = fixseq(a,tol)
%FIXSEQ Fixed sequence proportional to percentage of demand.
% s = fixseq(a,tol)
%    a = n-element vector of demands
%  tol = tolerance of rational approximation to demand percentage
%      = 1e-2, default
%    s = sequence of indices i = 1 to n, where the frequency of i's in "s"
%        is proportional to the percentage of a(i) in the total demand,
%        i.e., |sum(s == i)/length(s) - a(i)/sum(a)| < tol
%
% Example:
% If a = [0.1193  0.0504] then
% a/sum(a) is [0.7030 0.2970]
% fixseq(a) is [1  1  2  1  1  1  2  1  1  2]
% fixseq(a,1e-1) is [1  1  2]

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin < 2 || isempty(tol), tol = 1.e-2; end
% End (Input Error Checking) **********************************************

a = a/sum(a);

if length(a) == 1, s = 1; return, end

% Find smallest LCM
done1 = 0;
k = Inf;
while ~done1
   
   % Find rational approximation
   done2 = 0;
   while ~done2
      [n2,d2] = rat(a,tol);
      if any(n2 == 0)
         tol = tol/10; % Decreasing "tol" by tenth due to 0 in numerator
      else
         done2 = 1;
      end
   end
   
   % LCM of vector elements
   k2 = lcm(d2(1),d2(2));
   for i = 2:length(d2)-1, k2 = lcm(k2,d2(i+1)); end
   
   if k2 < k
      k = k2; n = n2; d = d2;
      tol = tol/10;
   else
      done1 = 1;
   end
end

n = n.*(k./d);
[n,idx] = sort(-n); n = -n;
s = idx(1) * ones(1,n(1));

for i = 2:length(n)
   s = [s; NaN * ones(1,length(s))];
   z = length(s)/n(i);
   idxi = round(z .* (1:n(i)));
   % Error correction needed, e.g., for FIXSEQ([1 1])
   if any(idxi > size(s,2)), idxi(idxi > size(s,2)) = size(s,2); end
   s(2,idxi) = idx(i);
   s = s(:)';
   s(isnan(s)) = [];
end
