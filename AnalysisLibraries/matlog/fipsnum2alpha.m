function [alpha,num] = fipsnum2alpha(num)
%FIPSNUM2ALPHA Convert numeric state FIPS code to alphabetic.
% [alpha,num] = fipsnum2alpha(num)
%         num = numeric FIPS code
%             = [], default, to return all alpha codes except 88 and 91
%               (and numeric codes, if second output argument provided)
%
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
% FIPS Code Source: Federal Information Processing, Standards
%                   Publication 5-2, May 28, 1987

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin < 1 || isempty(num)
   num = 1:72; num([3 7 14 43 52 57:71]) = [];
end

if ~isnumeric(num) || any(num) > 91 || any(num) < 1
   error('Invalid numeric FIPS code.')
end
% End (Input Error Checking) **********************************************

a = cell(91,1);

a{1}='AL';
a{2}='AK';
a{4}='AZ';
a{5}='AR';
a{6}='CA';
a{8}='CO';
a{9}='CT';
a{10}='DE';
a{11}='DC';
a{12}='FL';
a{13}='GA';
a{15}='HI';
a{16}='ID';
a{17}='IL';
a{18}='IN';
a{19}='IA';
a{20}='KS';
a{21}='KY';
a{22}='LA';
a{23}='ME';
a{24}='MD';
a{25}='MA';
a{26}='MI';
a{27}='MN';
a{28}='MS';
a{29}='MO';
a{30}='MT';
a{31}='NE';
a{32}='NV';
a{33}='NH';
a{34}='NJ';
a{35}='NM';
a{36}='NY';
a{37}='NC';
a{38}='ND';
a{39}='OH';
a{40}='OK';
a{41}='OR';
a{42}='PA';
a{44}='RI';
a{45}='SC';
a{46}='SD';
a{47}='TN';
a{48}='TX';
a{49}='UT';
a{50}='VT';
a{51}='VA';
a{53}='WA';
a{54}='WV';
a{55}='WI';
a{56}='WY';
a{72}='PR';
a{88}='Canada';
a{91}='Mexico';

alpha = a(num);

if any(cellfun('isempty',alpha))
   error('Invalid numeric FIPS code.')
end
