function [f,TC,nf] = lp2mcnf(x,IJCUL,SCUL)
%LP2MCNF Convert LP solution to MCNF arc and node flows.
% [f,TC,nf] = lp2mcnf(x,IJCUL,SCUL)
%     x = solution returned from solving lp = mcnf2lp(IJCUL,SCUL)
% IJCUL = [i j c u l],  arc data
%  SCUL = [s nc nu nl], node data
%     f = arc flows
%    TC = total cost (LP TC does not include demand node costs)
%       = c'*f + nc'*nf
%    nf = node flows
%
% See MCNF2LP for more details and an example

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Run from MCNF2LP
[f,TC,nf] = mcnf2lp(IJCUL,SCUL,x);
