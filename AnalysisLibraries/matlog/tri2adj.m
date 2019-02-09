function A = tri2adj(T)
%TRI2ADJ Triangle indices to adjacency matrix representation.
%     A = tri2adj(T)
%     T = n x 3 matrix, where each row defines indices for one of n 
%         triangles
%     A = (sparse) m x m adjacency matrix, m is the maximum index value
%
% Converts set of triangles defined by X and Y vector indices into A. 
% Useful for ploting results from DELAUNAY triangulation using GPLOT.
%
% See also CONVHULL and DSEARCH

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if size(T,2) ~= 3
   error('"T" must be an n x 3 matrix of triangle indices.')
end
% End (Input Error Checking) **********************************************

m = max(T(:));
A = sparse(m,m);
for i = 1:length(T(:,1))
   A(T(i,1),T(i,2)) = 1;
   A(T(i,2),T(i,3)) = 1;
   A(T(i,3),T(i,1)) = 1;
end
A = A | triu(A)' | tril(A)';
