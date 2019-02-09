function varargout = uszip3(varargin)
%USZIP3 US 3-digit ZIP code data.
%      s = uszip3             Output all variables as structure 's'
%[x1,x2] = uszip3             Output only first 1, 2, etc., variables
%      s = uszip3('x',...)    Output only variables 'x', ... as struct. 's'
%[x,...] = uszip3('x',...)    Output variables 'x', ... as variables
%        = uszip3(...,is)     Output subset 'x(is)' using SUBSETSTUCT(s,is)
%                             where 'is' is vector of elements to extract
%
% Loads data file "uszip3.mat" that contain the following variables:
%     Code3 = m-element vector of m 3-digit ZIP (ZCTA) codes
%        XY = m x 2 matrix of population centroid lon-lat (in decimal deg)
%        ST = m-element cell array of m 2-char state abbreviations
%       Pop = m-element vector of total population estimates (2000)
%     House = m-element vector of total housing units (2000)
%  LandArea = m-element vector of land area (square miles)
% WaterArea = m-element vector of water area (square miles)
%
% Example 1: Extract all 3-digit ZIP codes in North Carolina
% NCzip = uszip3('Code3',strcmp('NC',uszip3('ST')))
%
% %  NCzip = 270
% %          ...
% %          289
%
% Example 2: 3-digit ZIP codes with population in continental U.S.
% z = uszip3(~mor({'AK','HI','PR'},uszip3('ST')) & uszip3('Pop') > 0);
% makemap(z.XY)
% pplot(z.XY,'g.')
%
% Derivation:
% 3-digit ZIP codes derived from 5-digit codes (see USZIP5) by using the 
% centroid of the 5-digit code regions weighed by their population and, 
% when the 5-digit are in multiple states, the median state as the state.
% The population, housing, and land and water areas are the sum of the
% 5-digit values. If all 5-digit codes have zero populations, then each
% code given equal weight in calculating 3-digit lon-lat.
%
% See also USZIP5

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
varnames = {'Code3','XY','ST','Pop','House','LandArea','WaterArea'};
[errstr,varargout] = loaddatafile(varargin,nargout,varnames,mfilename);
if ~isempty(errstr), error(errstr), end
% End (Input Error Checking) **********************************************
