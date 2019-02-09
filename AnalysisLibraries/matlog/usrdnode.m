function varargout = usroad(varargin)
%USRDNODE US highway network nodes data.
%      s = usrdnode           Output all variables as structure 's'
%[x1,x2] = usrdnode           Output only first 1, 2, etc., variables
%      s = usrdnode('x',...)  Output only variables 'x', ... as struct. 's'
%[x,...] = usrdnode('x',...)  Output variables 'x', ... as variables
%        = usrdnode(...,is)   Output subset 'x(is)' using SUBSETSTUCT(s,is)
%                             where 'is' is vector of elements to extract
%
% Based on Oak Ridge National Highway Network, which contains approximately
% 500,000 miles of roadway in US, Canada, and Mexico, including virtually
% all rural arterials and urban principal arterials in the US. It includes 
% a large attribute set relevant to routing. Version used (hp80) last 
% updated Jan 2008.
%
% Loads data file "usrdnode.mat" that contain the following variables:
%               XY = m x 2 matrix of node lon-lat (in decimal deg)
%         NodeFIPS = m-element vector of node state FIPS codes, where nodes
%                    on state and international boundaries are 0, and 
%              1 AL Alabama       22 LA Louisiana      40 OK Oklahoma
%              2 AK Alaska        23 ME Maine          41 OR Oregon
%              4 AZ Arizona       24 MD Maryland       42 PA Pennsylvania
%              5 AR Arkansas      25 MA Massachusetts  44 RI Rhode Island
%              6 CA California    26 MI Michigan       45 SC South Carolina
%              8 CO Colorado      27 MN Minnesota      46 SD South Dakota
%              9 CT Connecticut   28 MS Mississippi    47 TN Tennessee
%             10 DE Delaware      29 MO Missouri       48 TX Texas
%             11 DC Dist Columbia 30 MT Montana        49 UT Utah
%             12 FL Florida       31 NE Nebraska       50 VT Vermont
%             13 GA Georgia       32 NV Nevada         51 VA Virginia
%             15 HI Hawaii        33 NH New Hampshire  53 WA Washington
%             16 ID Idaho         34 NJ New Jersey     54 WV West Virginia
%             17 IL Illinois      35 NM New Mexico     55 WI Wisconsin
%             18 IN Indiana       36 NY New York       56 WY Wyoming
%             19 IA Iowa          37 NC North Carolina 72 PR Puerto Rico
%             20 KS Kansas        38 ND North Dakota   88    Canada
%             21 KY Kentucky      39 OH Ohio           91    Mexico
%
%  NodePostal_abbr = m x 2 char array of m node 2-char state abbreviations
%                    (DO NOT USE: Not complete; use NodeFIPS instead)
%          NodeTag = m-element cell array of node names
%
% See USRDLINK for the links in the network
% 
% (Above description adapted from the more detailed description available 
%  at http://cta.ed.ornl.gov/transnet/nhndescr.html)
%
% Derived from Source: Oak Ridge National Highway Network
% http://cta.ed.ornl.gov/transnet/Highways.html
%
% FIPS Code Source: Federal Information Processing, Standards
%                   Publication 5-2, May 28, 1987

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
varnames = {'XY','NodeFIPS','NodePostal_abbr','NodeTag'};
[errstr,varargout] = loaddatafile(varargin,nargout,varnames,mfilename);
if ~isempty(errstr), error(errstr), end
% End (Input Error Checking) **********************************************
