function x = iff(is,b,c)
%IFF Conditional operator as a function.
% x = iff(a,b,c) <=> if a, x = b; else x = c; end
%
% IF-statement as a function is used to allow a conditional in an
% anynomous fucntions; e.g., fh = @(x) iff(x < 0, Inf, x)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,3)
if isscalar(b), b = repmat(b,size(is)); end
if isscalar(c), c = repmat(c,size(is)); end
if ~islogical(is)
   error('First input must evaluate to a logical array.')
elseif ~isscalar(is) && ...
      (~all(size(is) == size(b)) || ~all(size(is) == size(c)))
   error('Inputs are not all the same size.')
end
% End (Input Error Checking) **********************************************

if isscalar(is)
   if is, x = b; else x = c; end
else
   x = zeros(size(is));
   x(is) = b(is);
   x(~is) = c(~is);
end
