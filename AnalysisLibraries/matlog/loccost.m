function c = loccost(loc,C)
%LOCCOST Calculate location sequence cost.
% c = loccost(loc,C)
%   loc = location vector
%     C = n x n matrix of costs between n locations
%
% Example:
% loc = [1   2   4   3];
%   C = triu(magic(4),1); C = C + C'
%                                     % C =  0   2   3  13
%                                     %      2   0  10   8
%                                     %      3  10   0  12
%                                     %     13   8  12   0
% c = loccost(loc,C)
%                                     % c =  2
%                                            8
%                                           12

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if max(loc(:)) > length(C)
   error('Location exceeds size of cost matrix.')
end
% End (Input Error Checking) **********************************************

c = diag(C(loc(1:end-1),loc(2:end)));


