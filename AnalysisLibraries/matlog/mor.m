function [is,Xidx] = mor(x,Y)
%MOR Multiple OR with each element of real or cellstr vector.
% [is,Xidx] = mor(x,Y)
%    x = real or cellstr vector
%    Y = real or cellstr array
%   is = logical array of matches
% Xidx = index of elements of x with no match in Y, where error is thrown
%        if Xidx not returned
%      = [], if at least one match in Y
%
% Returns: is = x(1) == Y | x(2) == Y | ...,           for real x
%          is = strcmp(x{1},Y) | strcmp(x{2},Y) | ..., for cellstr x
%
% Example: 3-digit ZIP codes with population in continental U.S.
% z = uszip3(~mor({'AK','HI','PR'},uszip3('ST')) & uszip3('Pop') > 0); 

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if isvector(x) && ischar(x), x = {x}; end

if ~isvector(x) && ~isreal(x) && ~iscellstr(x)
   error('First input must be a real or cellstr vector.')
elseif ~isreal(Y) && ~iscellstr(Y)
   error('Second input must be a real or cellstr array.')
end
% End (Input Error Checking) **********************************************

is = false(size(Y));
Xidx = [];
for i = 1:length(x)
   if isreal(x)
      isi = x(i) == Y;
   else
      isi = strcmp(x{i},Y);
   end
   if sum(isi(:)) < 1
      Xidx = [Xidx i];
      if nargout < 2
         str = inputname(1);
         if isempty(str), str = 'x'; end
         error(['No match found for element ' num2str(i) ' of ' str '.'])
      end
   end
   is = is | isi;
end
