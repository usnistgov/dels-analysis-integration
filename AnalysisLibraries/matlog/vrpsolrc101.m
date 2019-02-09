%VRPSOLRC101 Soloman's VRP with Time Windows problem RC101 data.
%Run vrpsolrc101 to load into workspace:
%    XY = vertex cooridinates
%     q = vertex demands, with depot q(1) = 0
%     Q = maximum loc seq load
%    ld = load/unload timespans
%    TW = time windows
%
% Best known solution: TC = 1,696.94 (excluding "ld"), 14 loc seqs
%
% Source: http://web.cba.neu.edu/~msolomon/rc101.htm
%    Ref: M.M. Soloman, "Algorithms for the vehicle routing and scheduling
%         problems with time window constraints," in Oper. Res. 35, 1987.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
% End (Input Error Checking) **********************************************

load(mfilename)
