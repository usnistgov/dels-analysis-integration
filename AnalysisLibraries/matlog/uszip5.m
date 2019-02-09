function varargout = uszip5(varargin)
%USZIP5 US 5-digit ZIP code data.
%      s = uszip5             Output all variables as structure 's'
%[x1,x2] = uszip5             Output only first 1, 2, etc., variables
%      s = uszip5('x',...)    Output only variables 'x', ... as struct. 's'
%[x,...] = uszip5('x',...)    Output variables 'x', ... as variables
%        = uszip5(...,is)     Output subset 'x(is)' using SUBSETSTUCT(s,is)
%                             where 'is' is vector of elements to extract
%
% Loads data file "uszip5.mat" that contain the following variables:
%     Code5 = m-element vector of m 5-digit ZIP (ZCTA) codes
%        XY = m x 2 matrix of lon-lat (in decimal deg)
%        ST = m-element cell array of m 2-char state abbreviations
%       Pop = m-element vector of total population estimates (2010)
%     House = m-element vector of total housing units (2010)
%  LandArea = m-element vector of land area (square miles)
% WaterArea = m-element vector of water area (square miles)
%
% Example 1: Extract all ZIP codes in North Carolina
% NCzip = uszip5('Code5',strcmp('NC',uszip5('ST')))
% %  NCzip = 27006
% %           ...
% %          28909
%
% Example 2: Find the lon-lat of ZIP codes 27606 and 32606
% XY = uszip5('XY',mand([27606 32606],uszip5('Code5')))
% % XY =
% %   -78.7155   35.7423
% %   -82.4441   29.6820
%
% Example 3: 5-digit ZIP codes with population in continental U.S.
% z = uszip5(~mor({'AK','HI','PR'},uszip5('ST')) & uszip5('Pop') > 0);
% makemap(z.XY)
% pplot(z.XY,'g.')
%
% Example 4: U.S. 2010 resident population represents the total number of
% % people in the 50 states and the District of Columbia.
% USpop = sum(uszip5('Pop',~strcmp('PR',uszip5('ST'))))
%
% %  USpop = 308739931
%
% Sources: 
% [1] http://www.census.gov/geo/www/gazetteer/gazetteer2010.html
%     (file: .../gazetteer/files/Gaz_zcta_national.txt)
% [2] http://www.census.gov/geo/www/2010census/zcta_rel/zcta_rel.html
%     (file: .../zcta_rel/zcta_county_rel_10.txt)
% [3] http://federalgovernmentzipcodes.us (file:
%     ...//federalgovernmentzipcodes.us/free-zipcode-database-Primary.csv)
%
% ZIP codes derived from the US Census Bureau's ZIP Code Tabulation Areas
% (ZCTAs) files [1] and [2].  These contain data for all 5 digit ZCTAs in
% the 50 states, District of Columbia and Puerto Rico as of Census 2010.
% File [1] used for Code5, XY, LandArea, and WaterArea. File [2] used for
% ST, Pop, and House, where ST is converted to alpha from numeric FIPS
% codes using FIPSNUM2ALPHA. Field isCUS excludes AK, HI, and PR.
%
% Additional ZIP code data taken from [3]. This data includes P.O. Box and
% Military ZIP codes not in the ZCTA files (these codes do not have
% population data associated with them.
%
% See also USZIP3

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
varnames = {'Code5','XY','ST','Pop','House','LandArea','WaterArea'};
[errstr,varargout] = loaddatafile(varargin,nargout,varnames,mfilename);
if ~isempty(errstr), error(errstr), end
% End (Input Error Checking) **********************************************
