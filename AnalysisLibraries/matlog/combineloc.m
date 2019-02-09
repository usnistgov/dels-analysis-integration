function [cmbloc,st] = combineloc(out)
%COMBINELOC Combine non-overlapping loc seqs.
% [cmbloc,st] = combineloc(out)
%   out = m-element struct array of timing output from LOCTC
%cmbloc = combine non-overlapping loc seqs, where 
%         cmbloc{i} = [j k] represents the i-th combined loc seq consisting
%         of seq j followed by seq k
%
% Uses greedy combination heuristic
%
% Example:
% [TC,out] = locTC(loc,C,cap,twin)
% [cmbloc,st] = combineloc(out);
% [TC,out] = locTC(cmbloc,C,cap,twin);  % Re-calc "out"

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
% End (Input Error Checking) **********************************************

for i = 1:length(out)
   ES(i) = out(i).EarlySF(1);
   LS(i) = out(i).LateSF(1);
   EF(i) = out(i).EarlySF(2);
end

i = argsort(LS);
st = ES;

n = 0;
while ~isempty(i)
   n = n + 1;
   i1 = i(1); i(1) = [];
   cmbloc{n} = i1;
   
   done = 0;
   while ~done && ~isempty(i)
      d = LS(i) - EF(i1);
      ij = i(d > 0);
      if isempty(ij)
         done = 1;
      else
         ij = ij(argmin(d(d > 0)));
         cmbloc{n}(end + 1) = ij;
         st(ij) = max(EF(i1),ES(ij));
         EF(i1) = st(ij) + EF(ij) - ES(ij);
         i(i == ij) = [];
      end
   end
end
