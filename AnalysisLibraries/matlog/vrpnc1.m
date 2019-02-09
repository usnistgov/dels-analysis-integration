%VRPNC1 Christofiles' VRP problem 1 data.
%Run vrpnc1 to load into workspace:
%    XY = vertex cooridinates
%     q = vertex demands, with depot q(1) = 0
%     Q = maximum loc seq load
%    ld = load/unload timespans
% maxTC = maximum total loc seq cost
%
% Best known solution: TC = 524.6, 5 loc seqs
%
% Source: http://mscmga.ms.ic.ac.uk/jeb/orlib/vrpinfo.html
%    Ref: N. Christofides et al., "The vehicle routing problem," in
%         N. Chrsitofides et al., Eds., Comb. Opt., Wiley, 1979.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
% End (Input Error Checking) **********************************************

load(mfilename)
