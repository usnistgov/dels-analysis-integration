function N = trineighbors(t,T)
%TRINEIGHBORS Find neighbors of a triangle.
%     N = trineighbors(t,T)
%     t = m-element vector of triangle indices
%     T = n x 3 matrix of node indices, where each row defines node indices
%         for one of n triangles (the result from a DELAUNAY triangulation)
%     N = m x 3 matrix of triangle indices, where each row N(i,:) defines
%         indices of the neighboring triangles of triangle T(i,:) and
%         N(i,j) = NaN, if edge [T(i,j) T(i,j+1)] not shared with any other
%         triangle (e.g., if it is part of the convex hull)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,2);
t = t(:);
[rT,cT] = size(T);
if min (t) < 1 || max(t) > rT
   error('Elements of "t" must be in the range [1, n]')
elseif cT ~= 3
   error('"T" must be an n x 3 matrix of triangle indices.')
end
% End (Input Error Checking) **********************************************

N = NaN * ones(length(t),3);

for i = 1:length(t)
   if isnan(t(i)), continue, end
   for j = 1:3
      a = T(t(i),j); 
      b = T(t(i),mod(j,3)+1);
      isab = (a==T(:,1) & b == T(:,2)) | (a==T(:,2) & b == T(:,3)) | ...
         (a==T(:,3) & b == T(:,1)) | (a==T(:,1) & b == T(:,3)) | ...
         (a==T(:,3) & b == T(:,2)) | (a==T(:,2) & b == T(:,1));
      isab(t(i)) = 0;
      idxab = find(isab);
      if length(idxab) == 1
         N(i,j) = idxab;
      elseif length(idxab) > 1
         error('Incorrrect triangle index T.')
      end
   end
end
