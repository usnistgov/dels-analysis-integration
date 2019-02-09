% Copyright (C) 2012, 2013 Moreno Marzolla
%
% This file is part of the queueing toolbox.
%
% The queueing toolbox is free software: you can redistribute it and/or
% modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation, either version 3 of the
% License, or (at your option) any later version.
%
% The queueing toolbox is distributed in the hope that it will be
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty
% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with the queueing toolbox. If not, see <http://www.gnu.org/licenses/>.

% -*- texinfo -*-
%
% @deftypefn {Function File} {@var{V} =} qnomvisits (@var{P}, @var{lambda})
%
% Compute the visit ratios to the service centers of an open multiclass network with @math{K} service centers and @math{C} customer classes.
%
% @strong{INPUTS}
%
% @table @var
%
% @item P
% @code{@var{P}(r,i,s,j)} is the probability that a
% class @math{r} request which completed service at center @math{i} is
% routed to center @math{j} as a class @math{s} request. Class switching
% is supported.
%
% @item lambda
% @code{@var{lambda}(r,i)} is the external arrival rate of class @math{r}
% requests to center @math{i}.
%
% @end table
%
% @strong{OUTPUTS}
%
% @table @var
%
% @item V
% @code{@var{V}(r,i)} is the visit ratio of class @math{r}
% requests at center @math{i}.
%
% @end table
% 
% @end deftypefn

% Author: Moreno Marzolla <moreno.marzolla(at)unibo.it>
% Web: http://www.moreno.marzolla.name/

function V = qnomvisits( P, lambda )

  if ( nargin ~= 2 )
    error('Enter two arguments');
  end

  assert(ndims(P) == 4, 'P must be a 4-dimensional matrix');

  [C, K, C2, K2] = size( P );
  assert(K == K2 && C == C2, 'P must be a [%d,%d,%d,%d] matrix', C, K, C, K);

  assert( ndims(lambda) == 2 && size(lambda,1) == C && size(lambda,2) == K, 'lambda must be a %d x %d matrix', C, K );

  assert(all(lambda(:)>=0), 'lambda contains negative values');

  % solve the traffic equations: V(s,j) = lambda(s,j) / lambda + sum_r
  % sum_i V(r,i) * P(r,i,s,j), for all s,j where lambda is defined as
  % sum_r sum_i lambda(r,i)
  A = eye(K*C) - reshape(P,[K*C K*C]);
  b = reshape(lambda / sum(lambda(:)), [1,K*C]);
  V = reshape(b/A, [C, K]);

  % Make sure that no negative values appear (sometimes, numerical
  % errors produce tiny negative values instead of zeros)
  V = max(0,V);
end
%!test
%! fail( "qnomvisits( zeros(3,3,3), [1 1 1] )", "matrix");

%!test
%! C = 2; K = 4;
%! P = zeros(C,K,C,K);
%! # class 1 routing
%! P(1,1,1,1) = .05;
%! P(1,1,1,2) = .45;
%! P(1,1,1,3) = .5;
%! P(1,2,1,1) = 0.1;
%! P(1,3,1,1) = 0.2;
%! # class 2 routing
%! P(2,1,2,1) = .01;
%! P(2,1,2,3) = .5;
%! P(2,1,2,4) = .49;
%! P(2,3,2,1) = 0.2;
%! P(2,4,2,1) = 0.16;
%! lambda = [0.1 0 0 0.1 ; 0 0 0.2 0.1];
%! lambda_sum = sum(lambda(:));
%! V = qnomvisits(P, lambda);
%! assert( all(V(:)>=0) );
%! for i=1:K
%!   for c=1:C
%!     assert(V(c,i), lambda(c,i) / lambda_sum + sum(sum(V .* P(:,:,c,i))), 1e-5);
%!   endfor
%! endfor

%!test
%! # example 7.7 p. 304 Bolch et al. 
%! # Note that the book uses a slightly different notation than
%! # what we use here. Specifically, the book defines the routing 
%! # probabilities as P(i,r,j,s) (i,j are service centers, r,s are job
%! # classes) while the queueing package uses P(r,i,s,j).
%! # A more serious problem arises in the definition of external arrivals.
%! # The computation of V(r,i) as given in the book (called e_ir
%! # in Eq 7.14) is performed in terms of P_{0, js}, defined as 
%! # "the probability in an open network that a job from outside the network
%! #  enters the jth node as a job of the sth class" (p. 267). This is
%! # compliant with eq. 7.12 where the external class r arrival rate at center
%! # i is computed as \lambda * P_{0,ir}. However, example 7.7 wrongly
%! # defines P_{0,11} = P_{0,12} = 1, instead of P_{0,11} = P_{0,12} = 0.5
%! # Therefore the resulting visit ratios they obtain must be divided by two.
% P = zeros(2,3,2,3);
% lambda =  zeros(2,3);
% S = zeros(2,3);
% P(1,1,1,2) = 0.4;
% P(1,1,1,3) = 0.3;
% P(1,2,1,1) = 0.6;
% P(1,2,1,3) = 0.4;
% P(1,3,1,1) = 0.5;
% P(1,3,1,2) = 0.5;
% P(2,1,2,2) = 0.3;
% P(2,1,2,3) = 0.6;
% P(2,2,2,1) = 0.7;
% P(2,2,2,3) = 0.3;
% P(2,3,2,1) = 0.4;
% P(2,3,2,2) = 0.6;
% lambda(1,1) = 1; lambda(2,1) = 1;
% V = qnomvisits(P,lambda);
% assert( V, [ 3.333 2.292 1.917; 10 8.049 8.415] ./ 2, 1e-3);
