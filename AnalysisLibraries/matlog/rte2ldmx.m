function ldmx = rte2ldmx(rte)
%RTELD Convert route vector to load-mix cell array.
% ldmx = rte2ldmx(rte)
%  rte = route vector
% ldmx = cell array of load-mix vectors
%
% Example:
%  rte = [1   2   1   3   3   2];
% ldmx = rte2ldmx(rte); ldmx{:}      % ans = 1   2
%                                    % ans = 2   3

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
checkrte(rte,[],true)
% End (Input Error Checking) **********************************************

if nnz(diff(sign(rte))) == 1  % Non-interleaved route => one load
   ldmx = {rte2idx(rte)};
else
   k = 1;
   ldmx{k} = [];
   is = isorigin(rte);
   for i = 1:length(rte)-1
      if is(i)
         ldmx{k} = [ldmx{k} rte(i)];
         if ~is(i+1)
            k = k + 1;
            ldmx{k} = ldmx{k-1};
         end
      else
         ldmx{k}(rte(i) == ldmx{k}) = [];
      end
   end
   ldmx(k) = [];
end
