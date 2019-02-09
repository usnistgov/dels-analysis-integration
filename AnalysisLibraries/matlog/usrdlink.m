function varargout = usroad(varargin)
%USRDLINK US highway network links data.
%      s = usrdlink           Output all variables as structure 's'
%[x1,x2] = usrdlink           Output only first 1, 2, etc., variables
%      s = usrdlink('x',...)  Output only variables 'x', ... as struct 's'
%[x,...] = usrdlink('x',...)  Output variables 'x', ... as variables
%        = usrdlink(...,is)   Output subset 'x(is)' using SUBSETSTUCT(s,is)
%                             where 'is' is vector of elements to extract
%
% Based on Oak Ridge National Highway Network, which contains approximately
% 500,000 miles of roadway in US, Canada, and Mexico, including virtually
% all rural arterials and urban principal arterials in the US. It includes 
% a large attribute set relevant to routing. Version used (hp80) last 
% updated Jan 2008.
%
% Loads data file "usrdlink.mat" that contain the following variables:
%              IJD = n x 3 matrix arc list [i j c] of link heads, tails, 
%                    and distances (in miles)
%         LinkFIPS = n-element vector of link state FIPS code, where no
%                    individual link crosses a state boundary (see USRDNODE
%                    for FIPS codes)
%             Type = n-element char vector, where
%                      I - Interstate
%                      U - US route
%                      S - State route
%                      T - Secondary state route
%                      J - Interstate related route (business route, ramps)
%                      C - County route number or name
%                      L - Local road name
%                      P - Parkway
%                      R - Inventory route number (not normally posted)
%                      V - Federal reservation road Used in national parks 
%                          and forests, and Indian and military reservation
%                    "-" - (dash) Continuation of local road name from
%                          previous
%          LinkTag = n x 5 char array of route numbers, with qualifiers
%                     N, S, E, W - Directional qualifiers used to
%                          distinguish
%                          between distinct mainline routes, not to 
%                          indicate direction of travel on divided highways
%                          or couplets
%                     A  - Alternate
%                     BR - Business route or business loop
%                     BY - Bypass
%                     SP - Spur
%                     LP - Loop
%                     RM - Ramp
%                     FR - Frontage road
%                     PR - Proposed
%                     T  - Temporary
%                     TR - Truck route
%                     Y  - Wye
%          Heading = n-element char vector of travel directions N, S, E,
%                    or W
%            Urban = n-element char vector of flags indicating subjective
%                    judgement about degree of urban congestion, where
%                      U - Urban
%                      V - Urban bypasses (usually circumferential routes)
%                      S - Small urban or towns
%                      T - Partially urban; that is, part of the link is
%                          subject to congestion effects limiting speed
%                          (links having 0.5 miles subject to urban speed
%                          reduction)
%                      X - In urban area, but attributes and topology
%                          unchecked
%           Median = n-element char vector, where
%                      M - Divided highway (with median)
%                      C - Undivided (ie, "centerline")
%                      F - Ferry
%   Access_control = n-element char vector, where
%                      U - Uncontrolled access
%                      G - Partial control access (some at-grade
%                          intersections)
%                      I - Fully controlled access (all intersections are
%                          grade separated interchanges)
%                      F - Ferry
%     Number_lanes = n-element vector, usually either 2 or 4, representing
%                    all multilane roads (reported as 0 for ferries)
% Traffic_restrict = n-element char vector, where (in order of priority)
%                      Z - No vehicles (generally a passenger ferry)
%                      P - Closed to public use
%                      C - Commercial traffic prohibited
%                      H - Hazardous materials prohibited
%                      T - Large trucks prohibited
%                      Q - Occasionally closed to public
%                      L - Local commercial traffic only
%                      W - Normally closed in winter
%             Toll = n-element char vector, where
%                      T - Toll road
%                      B - Link contains a toll bridge (or tunnel)
%                      F - Free passage (roads not flagged can be assumed
%                          toll free, but ferries are uncertain unless
%                          marked)
%      Truck_route = n-element char vector, where
%                      A - State designated route for STAA-dimensioned 
%                          vehicles (the "Staggers act" National Network)
%                      B - Federally designated National Network routes for
%                          large commercial vehicles (subset of State
%                          routes)
%                      C - While nominally Federally designated route, may 
%                          be construction-related restrictions for long
%                          period
%        Major_hwy = n-element vector, integer represents 4-digit bit field
%                      1 - Major highways subsystem        
%                      2 - Major highways exclusion     
%                      3 - 16-ft route flag (not in public version)
%                      4 - Tunnel flag                   
%         Pavement = n-element char vector, where
%                      P - Paved
%                      Q - Secondary paved (through traffic discouraged)
%                      G - Gravel, or otherwise below paved quality
%                      D - Dirt or unimproved
%                      F - Ferry
%      Admin_class = n-element char vector, where
%                      I - Federal-Aid Interstate
%                      P - Federal-Aid Primary
%                      S - Federal-Aid Secondary
%                      U - Federal-Aid Urban
%                      T - Combination of "S" and "U"
%                      N - Not on a Federal-Aid system
%                      F - Direct Federal system
%                      J - Ramps, connecting roadways, collector/
%                          distributors administratively related to the
%                          Interstate system, but not part of Interstate
%                          mainline mileage
%                      Q - Auxiliary roadways related to non-Interstate
%                          primary routes
%   Function_class = n x 2 char array of functional class identifier, where
%                            Rural                       Urban             
%                     01 - Interstate             11 - Interstate
%                     02 - Principal arterial     12 - Other expressway
%                                                 13 - 
%                                                 14 - Principal arterial
%                     05 - Major arterial         15 -                    
%                     06 - Minor arterial         16 - Minor arterial
%                     07 - Major collector        17 - Collector
%                     08 - Minor collector                          
%                     09 - Local                  19 - Local
%                             Combination         
%                     _1 -  01 & 11
%                     _2 -  02 & 12
%                     _3 -  02 & 14  
%                     _4 -  06 & 12   05 & 14
%                     _5 -  06 & 14
%                     _6 -  06 & 16   07 & 14
%                     _7 -  07 & 16   07 & 17
% Future_fun_class = n-element char vector containing trailing digit of a 
%                    state proposed re- classification of the roadway
%  Special_systems = n-element vector, where
%                      2 - ILS Roadways part of FHWA/HEP Illustrative Syst.
%                      3 - Trans-America Corridor
%                      4 - NHS High Priority Corridor
%           Status = n-element char vector of 
%                      O - Open to traffic
%                      U - Under construction
%                      P - Proposed
%                      X - Speculative
%
% See USRDNODE for the nodes in the network
% 
% (Above description adapted from the more detailed description available  
%  at http://cta.ed.ornl.gov/transnet/nhndescr.html)
%
% Derived from Source: Oak Ridge National Highway Network
% http://cta.ed.ornl.gov/transnet/Highways.html

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
varnames = {'IJD','LinkFIPS','Type','LinkTag','Heading','Urban',...
      'Median','Access_control','Number_lanes','Traffic_restrict',...
      'Toll','Truck_route','Major_hwy','Pavement','Admin_class',...
      'Function_class','Future_fun_class','Special_systems','Status'};
[errstr,varargout] = loaddatafile(varargin,nargout,varnames,mfilename);
if ~isempty(errstr), error(errstr), end
% End (Input Error Checking) **********************************************
