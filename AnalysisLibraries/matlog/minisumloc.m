function [X,TC,XFlg,X0] = minisumloc(P,W,p,V,X0,varargin)
%MINISUMLOC Continuous minisum facility location.
% [X,TC,XFlg,X0] = minisumloc(P,W,p,V,X0,opt)
%     Determines locations X that minimizes TC = SUMCOST(X,P,W,p,V).
%     Uses best solution from gradient-based and Nelder-Mead searches.
%     P = m x d matrix of m d-dimensional points
%     W = n x m matrix of X-P weights
%     p = distance parameter for DISTS in SUMCOST
%     V = n x n matrix of X-X weights for multifacility problem
%         (all elements of V used)
%       = [] (default), solve n single-facility problems
%    X0 = n x d matrix of starting points
%       = RANDX(P,n) (default)
%   opt = options structure, with fields:
%       .SearchTech = search techniques to use 
%                   = 1 => only FMINUNC (gradient-based search)
%                   = 2 => only FMINSEARCH (Nelder-Mead direct search)
%                   = 3 => best of both (default)
%       .MajorityChk = check for majority single-facility solution
%                      (i.e., X = P(FIND(W >= SUM(W)),:))
%                    = 1, do check (default)
%                    = 0, do not check
%       .e = epsilon parameter for DISTS passed through SUMCOST
%          = 1e-4 (default)
%       .IterPlot = plot each X evaluated by SUMCOST
%                   (use 'delete(findobj('Tag','iterplot'))' to erase)
%                 = h, handle of axes for plotting
%                 = [] (defualt), no plotting
%       .NormLonLat = normalize lon-lat (i.e., X = NORMLONLAT(X))
%                   = 1, normalize (default)
%                   = 0, do not normalize
%       .Uopt = option structure for FMINUNC, with MINISUMLOC defaults:
%             .Display = 'off',.GradObj = 'on',.LargeScale = 'off',
%             .LineSearchType = 'cubicpoly'
%       .Sopt = option structure for FMINSEARCH, with MINISUMLOC defaults:
%             .Display = 'off',.TolFun = 1e-6,.TolX = 1e-6
%       = 'Field1',value1,'Field2',value2, ..., where multiple input
%         arguments or single cell array can be used instead of the full
%         options structure to change only selected fields
%   opt = MINISUMLOC('defaults'), to get defaults values for option struct.
%  XFlg = 3 => majority solution found
%       = 2 => best solution found using FMINSEARCH
%       = 1 => best solution found using FMINUNC
%       = 0 => maximum number of iterations reached, if best solution found
%              using FMINSEARCH; or maximum number of function evaluations
%              reached, if best solution found using FMINUNC
%       = -1 => did not converge to a solution, if only FMINUNC used
%       = -2 => all 0 row in W matrix (returns X(i,:) = X0(i,:); TC(i) = 0)
%
% Examples: 
% P = [1 1;2 0;2 3], w = [4 3 5]        % Single-facility location
% [X,TC,XFlg,X0] = minisumloc(P,w,2)    %  X = 1.2790    1.1717
%
% W = [4 3 5;2 3 0], V = [0 1;0 0],     % Multifacility location
% [X,TC,XFlg,X0] = minisumloc(P,W,2,V)  %  X = 1.3197    1.1093
%                                       %      2.0000    0.0000
%
% V = [],                               % Two single-facility locations
% [X,TC,XFlg,X0] = minisumloc(P,W,2)    %  X = 1.2790    1.1717
%                                       %      2.0000         0

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin == 6 && isstruct(varargin{:})	   % Use opt only to check fields
   opt = struct('SearchTech',[],'MajorityChk',[],'e',[],'IterPlot',[],...
      'NormLonLat',[],'Uopt',[],'Sopt',[]);
else													 % Set defaults for opt structure
   opt = struct('SearchTech',3,...
      'MajorityChk',1,...
      'e',1e-4,...
      'IterPlot',[],...
      'NormLonLat',1,...
      'Uopt',[],...
      'Sopt',optimset(fminsearch('defaults'),...
      	'Display','off',...
      	'TolFun',1e-6,...
      	'TolX',1e-6));
   if exist('fminunc','file') == 2
      opt.Uopt = optimset(fminunc('defaults'),...
         'Display','off',...
         'GradObj','on',...
         'LargeScale','off');
   end
   if nargin == 1 && strcmpi('defaults',P), X = opt; return, end
   narginchk(3,Inf)
end

if nargin < 4, V = []; end
if nargin < 5, X0 = []; end

if nargin > 5
   opt = optstructchk(opt,varargin);
   if ischar(opt), error(opt), end
end

m = size(P,1);
[n,cW] = size(W);
if isempty(X0), X0 = randX(P,n); end

if m ~= cW
   error('Number of rows in P must equal number of columns in W.')
elseif ~isempty(V) && n == 1
   error('V matrix must be empty since "n" == 1.')
elseif size(X0,1) ~= n
   error('Number of rows in X0 and W must be the same.')
elseif length(opt.SearchTech(:)) ~= 1 || ~any(opt.SearchTech == [1 2 3])
   error('Invalid "opt.SearchTech" specified.')
elseif opt.SearchTech ~= 2 && exist('fminunc','file') ~= 2
   if opt.SearchTech == 1
      error('M-file FMINUNC from OPTIM Toolbox (Ver. 2.0) not found.')
   else
      opt.SearchTech = 2;
   end
elseif length(opt.MajorityChk(:)) ~= 1 || ~any(opt.MajorityChk == [0 1])
   error('Invalid "opt.MajorityChk" specified.')
elseif ~isempty(opt.IterPlot) && ~strcmp(get(opt.IterPlot,'type'),'axes')
      error('Invalid handle "opt.IterPlot" (not axes object).')
elseif length(opt.NormLonLat(:)) ~= 1 || ~any(opt.NormLonLat == [0 1])
   error('Invalid "opt.NormLonLat" specified.')
elseif length(opt.e) ~= 1 || ~isreal(opt.e) || opt.e < 0
   error('"opt.e" must be a positive scalar')
elseif ~isempty(opt.Uopt) && ~isstruct(opt.Uopt)
   error('"opt.Uopt" must be a structure from FMINUNC("defaults").')
elseif ~isempty(opt.Sopt) && ~isstruct(opt.Sopt)
   error('"opt.Sopt" must be a structure from FMINSEARCH("defaults").')
end

% Use DISTS to error check X0, P, and p
try dists(X0,P,p); catch error(lasterror), end

% End (Input Error Checking) **********************************************

if isempty(V) && n > 1	% Multiple single-facility problems
   X = zeros(size(X0)); TC = zeros(n,1); XFlg = zeros(n,1);
   for i = 1:n
      a = find(W(i,:)>0);
      [X(i,:),TC(i),XFlg(i)] = ...
         minisumlocrun(P(a,:),W(i,a),p,[],X0(i,:),opt);
   end
else                    % One single- or multifacility problem
   [X,TC,XFlg] = minisumlocrun(P,W,p,V,X0,opt);
end



% *************************************************************************
% *************************************************************************
% *************************************************************************
function [X,TC,XFlg] = minisumlocrun(P,W,p,V,X0,opt)
%MINISUMLOCRUN One Single- or Multifacility Run

% Check for Majority Solution (only for single-facility problems)
if opt.MajorityChk == 1 && isempty(V)
   i = find(W >= sum(W)/2);
   if ~isempty(i) && length(i) == 1	% Unique i only if all W(j) >= 0
      X = P(i,:);
      TC = sumcost(X,P,W,p);
      XFlg = 3;
      return
   end
end

% Check for All 0 Row in W (only for single-facility problems)
if isempty(V) && (isempty(W) || all(W == 0))
   X = X0; TC = 0; XFlg = -2;
   return
end

% Plot Initial IterPlot
if ~isempty(opt.IterPlot)
   pplot(X0,'o','Color',[.5 0 .5],'Tag','iterplot')
   pauseplot
end

% FMINUNC (Gradient-based search)
if opt.SearchTech ~= 2  
   if ischar(p) || isinf(p)		% Gradient not provided by SUMCOST
      opt.Uopt.GradObj = 'off';
      opt.Uopt.LargeScale = 'off';
      opt.Uopt.LineSearchType = 'quadcubic';
   end
   [XU,TCU,XFU] = ...
      fminunc('sumcost',X0,opt.Uopt,P,W,p,V,opt.e,opt.IterPlot);
   TCS = Inf;
end

% FMINSEARCH (Nelder-Mead direct search)
if opt.SearchTech ~= 1
   if opt.SearchTech == 3
      XS0 = XU;
   else
      XS0 = X0;
      TCU = Inf;
   end
   [XS,TCS,XFS] = ...
      fminsearch('sumcost',XS0,opt.Sopt,P,W,p,V,0,opt.IterPlot);
end

% Output min TC
if TCS >= TCU || opt.SearchTech == 1
   X = XU;
   TC = TCU;
   XFlg = XFU;
else
   X = XS;
   TC = TCS;
   XFlg = XFS;
   if XFS > 0, XFlg = 2; end
end

% Normalize lon-lat pairs
if opt.NormLonLat == 1 && ischar(p)
   X = normlonlat(X);
end

% Plot Final IterPlot
if ~isempty(opt.IterPlot)
   pplot(X,'x','Color',[.5 0 .5],'Tag','iterplot')
end



