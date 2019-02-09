% Copyright (C) 2008, 2009, 2010, 2011, 2012, 2013 Moreno Marzolla
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
% @deftypefn {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qnom (@var{lambda}, @var{S}, @var{V})
% @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qnom (@var{lambda}, @var{S}, @var{V}, @var{m})
% @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qnom (@var{lambda}, @var{S}, @var{P})
% @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}] =} qnom (@var{lambda}, @var{S}, @var{P}, @var{m})
%
% @cindex open network, multiple classes
% @cindex multiclass network, open
%
% Exact analysis of open, multiple-class BCMP networks. The network can
% be made of @emph{single-server} queueing centers (FCFS, LCFS-PR or
% PS) or delay centers (IS). This function assumes a network with
% @math{K} service centers and @math{C} customer classes.
%
% @quotation Note
% If this function is called specifying the visit ratios
% @var{V}, class switching is @strong{not} allowed.
% If this function is called specifying the routing probability matrix
% @var{P}, then class switching @strong{is} allowed; however, in this
% case all nodes are restricted to be fixed rate servers or delay
% centers: multiple-server and general load-dependent centers are not
% supported.
% Note that the meaning of parameter @var{lambda} is different 
% from one case to the other (see below).
% @end quotation
%
% @strong{INPUTS}
%
% @table @var
%
% @item lambda
% If this function is invoked as @code{qnom(lambda, S, V, @dots{})},
% then @code{@var{lambda}(c)} is the external arrival rate of class
% @math{c} customers (@code{@var{lambda}(c) @geq{} 0}). If this
% function is invoked as @code{qnom(lambda, S, P, @dots{})}, then
% @code{@var{lambda}(c,k)} is the external arrival rate of class
% @math{c} customers at center @math{k} (@code{@var{lambda}(c,k) @geq{}
% 0}).
%
% @item S
% @code{@var{S}(c,k)} is the mean service time of class @math{c}
% customers on the service center @math{k} (@code{@var{S}(c,k)>0}).
% For FCFS nodes, mean service times must be class-independent.
%
% @item V
% @code{@var{V}(c,k)} is the visit ratio of class @math{c}
% customers to service center @math{k} (@code{@var{V}(c,k) @geq{} 0 }).
% @strong{If you pass this argument, class switching is not
% allowed}
%
% @item P
% @code{@var{P}(r,i,s,j)} is the probability that a class @math{r}
% job completing service at center @math{i} is routed to center @math{j}
% as a class @math{s} job. @strong{If you pass argument @var{P},
% class switching is allowed}; however, all servers must be fixed-rate or infinite-server nodes (@code{@var{m}(k) @leq{} 1} for all @math{k}).
%
% @item m
% @code{@var{m}(k)} is the number of servers at center @math{i}. If
% @code{@var{m}(k) < 1}, enter @math{k} is a delay center (IS);
% otherwise it is a regular queueing center with @code{@var{m}(k)}
% servers. Default is @code{@var{m}(k) = 1} for all @math{k}.
%
% @end table
%
% @strong{OUTPUTS}
%
% @table @var
%
% @item U
% If @math{k} is a queueing center, then @code{@var{U}(c,k)} is the
% class @math{c} utilization of center @math{k}. If @math{k} is an IS
% node, then @code{@var{U}(c,k)} is the class @math{c} @emph{traffic
% intensity} defined as @code{@var{X}(c,k)*@var{S}(c,k)}.
%
% @item R
% @code{@var{R}(c,k)} is the class @math{c} response time at center
% @math{k}. The system response time for class @math{c} requests can be
% computed as @code{dot(@var{R}, @var{V}, 2)}.
%
% @item Q
% @code{@var{Q}(c,k)} is the average number of class @math{c} requests
% at center @math{k}. The average number of class @math{c} requests
% in the system @var{Qc} can be computed as @code{Qc = sum(@var{Q}, 2)}
%
% @item X
% @code{@var{X}(c,k)} is the class @math{c} throughput
% at center @math{k}.
%
% @end table
%
% @seealso{qnopen,qnos,qnomvisits}
%
% @end deftypefn

% Author: Moreno Marzolla <moreno.marzolla(at)unibo.it>
% Web: http://www.moreno.marzolla.name/
function [U, R, Q, X] = qnom( varargin )
  if ( nargin < 2 || nargin > 4 )
    error('Enter the correct number of arguments');
  end

  if ( nargin == 2 || ndims(varargin{3}) == 2 )

    [err, lambda, S, V, m] = qnomchkparam( varargin{:} );

  else

    lambda = varargin{1};
    assert( ndims(lambda) == 2 && all( lambda(:) >= 0 ), 'lambda must be >= 0');
    [C,K] = size(lambda);
    S = varargin{2};
    assert( ndims(S) == 2 && size(S,1) == C && size(S,2) == K, 'S size mismatch (should be [%d,%d])', C, K );
    P = varargin{3};
    assert( ndims(P) == 4 && size(P,1) == C && size(P,2) == K && size(P,3) == C && size(P,4) == K, 'P size mismatch (should be %dx%dx%dx%d)',C,K,C,K );
    
    V = qnomvisits(P,lambda);

    if ( nargin < 4 )
      m = ones(1,K);
    else
      m = varargin{4};
      assert(isvector(m), 'm must be a vector');
      m = m(:)'; % make m a row vector
      assert(length(m) == K, 'm size mismatch (should be %d, is %d)', K, length(m) );
      assert(all(m<=1), 'IF you use parameter P, m must be <= 1');
    end

    lambda = sum(lambda,2); % lambda(c) is the overall class c arrival rate
  end

  [C, K] = size(S);

  U = zeros(C,K);
  R = zeros(C,K);
  Q = zeros(C,K);
  X = zeros(C,K);

  % NOTE; Zahorjan et al. define the class c throughput at center k as
  % X(c,k) = lambda(c) * V(c,k). However, this assumes a definition of
  % V(c,k) that is different from what is returned by the qnomvisits()
  % function. The queueing package defines V(c,k) as the class c visit
  % _ratio_ at center k (see the documentation of the queueing package
  % to see the formal definition of V(c,k) as the solution of a linear
  % system of equations), while Zahorjan et al. define V(c,k) as the
  % _number of visits_ at center k. If you want to try the examples
  % on Zahorjan with this function, you need to scale V(c,k)
  % as lambda / lambda(c) * V(c,k).

  X = sum(lambda)*V; % X(c,k) = lambda*V(c,k);

  % If there are M/M/k servers with k>=1, compute the maximum
  % processing capacity
  m(m<1) = -1; % avoid division by zero in next line
  
  %%ERROR: 4/11/16
  %Matrix dimensions must agree.
  rho = X .* S * diag( 1 ./ m ); % rho(c,k) = X(c,k) * S(x,k) / m(k)
  [Umax, kmax] = max( sum(rho,1) );
  assert(Umax < 1, 'Processing capacity exceeded at center %d', kmax );

  % Compute utilizations (for IS nodes compute also response time and
  % queue lenghts)
  for k=1:K
    for c=1:C
      if ( m(k) > 1 ) % M/M/m-FCFS
	[U(c,k)] = qsmmm( X(c,k), 1/S(c,k), m(k) );
      elseif ( m(k) == 1 ) % M/M/1 or -/G/1-PS
	[U(c,k)] = qsmm1( X(c,k), 1/S(c,k) );
      else % -/G/inf
  	[U(c,k), R(c,k), Q(c,k)] = qsmminf( X(c,k), 1/S(c,k) );
      end
    end
  end
  assert( all(sum(U,1) < 1) ); % sanity check

  % Adjust response times and queue lengths for FCFS queues
  k_fcfs = find(m>=1);
  for c=1:C
    Q(c,k_fcfs) = U(c,k_fcfs) ./ ( 1 - sum(U(:,k_fcfs),1) );
    R(c,k_fcfs) = Q(c,k_fcfs) ./ X(c,k_fcfs); % Use Little's law
  end

end
%!test
%! fail( "qnom([1 1], [.9; 1.0])", "exceeded at center 1");
%! fail( "qnom([1 1], [0.9 .9; 0.9 1.0])", "exceeded at center 2");
%! #qnom([1 1], [.9; 1.0],[],2); # should not fail, M/M/2-FCFS
%! #qnom([1 1], [.9; 1.0],[],-1); # should not fail, -/G/1-PS
%! fail( "qnom(1./[2 3], [1.9 1.9 0.9; 2.9 3.0 2.9])", "exceeded at center 2");
%! #qnom(1./[2 3], [1 1.9 0.9; 0.3 3.0 1.5],[],[1 2 1]); # should not fail

%!test
%! V = [1 1; 1 1];
%! S = [1 3; 2 4];
%! lambda = [3/19 2/19];
%! [U R Q X] = qnom(lambda, S, diag( lambda / sum(lambda) ) * V );
%! assert( U(1,1), 3/19, 1e-6 );
%! assert( U(2,1), 4/19, 1e-6 );
%! assert( R(1,1), 19/12, 1e-6 );
%! assert( R(1,2), 57/2, 1e-6 );
%! assert( Q(1,1), .25, 1e-6 );
%! assert( Q, R.*X, 1e-5 ); # Little's Law

%!test
%! # example p. 138 Zahorjan et al.
%! V = [ 10 9; 5 4];
%! S = [ 1/10 1/3; 2/5 1];
%! lambda = [3/19 2/19];
%! [U R Q X] = qnom(lambda, S, diag( lambda / sum(lambda) ) * V );
%! assert( X(1,1), 1.58, 1e-2 );
%! assert( U(1,1), .158, 1e-3 );
%! assert( R(1,1), .158, 1e-3 ); # modified from the original example, as the reference above considers R as the residence time, not the response time
%! assert( Q(1,1), .25, 1e-2 );
%! assert( Q, R.*X, 1e-5 ); # Little's Law

%!test
%! # example 7.7 p. 304 Bolch et al. Please note that the book uses the 
%! # notation P(i,r,j,s) (i,j are service centers, r,s are job
%! # classes) while the queueing package uses P(r,i,s,j)
% P = zeros(2,3,2,3);
% lambda = zeros(2,3); S = zeros(2,3);
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
% S(1,1) = 1/8;
% S(1,2) = 1/12;
% S(1,3) = 1/16;
% S(2,1) = 1/24;
% S(2,2) = 1/32;
% S(2,3) = 1/36;
% lambda(1,1) = 1; lambda(2,1) = 1;
% V = qnomvisits(P,lambda);
%! assert( V, [ 3.333 2.292 1.917; 10 8.049 8.415] ./ 2, 1e-3);
%! [U R Q X] = qnom(sum(lambda,2), S, V);
%! assert( sum(U,1), [0.833 0.442 0.354], 1e-3 );
%! # Note: the value of K_22 (corresponding to Q(2,2)) reported in the book
%! # is 0.5. However, hand computation using the exact same formulas
%! # from the book produces a different value, 0.451
%! assert( Q, [2.5 0.342 0.186; 2.5 0.451 0.362], 1e-3 );

% Check that the results of qnom_nocs and qnom_cs are the same
% for multiclass networks WITHOUT class switching.
%!test
% P = zeros(2,2,2,2);
% P(1,1,1,2) = 0.8; P(1,2,1,1) = 1;
% P(2,1,2,2) = 0.9; P(2,2,2,1) = 1;
% S = zeros(2,2);
% S(1,1) = 1.5; S(1,2) = 1.2;
% S(2,1) = 0.8; S(2,2) = 2.5;
% lambda = zeros(2,2);
% lambda(1,1) = 1/20;
% lambda(2,1) = 1/30;
% [U1 R1 Q1 X1] = qnom(lambda, S, P); % qnom_cs
% [U2 R2 Q2 X2] = qnom(sum(lambda,2), S, qnomvisits(P,lambda)); % qnom_nocs
%! assert( U1, U2, 1e-5 );
%! assert( R1, R2, 1e-5 );
%! assert( Q1, Q2, 1e-5 );
%! assert( X1, X2, 1e-5 );

%!demo
%! P = zeros(2,2,2,2);
%! lambda = zeros(2,2);
%! S = zeros(2,2);
%! P(1,1,2,1) = P(1,2,2,1) = 0.2;
%! P(1,1,2,2) = P(2,2,2,2) = 0.8;
%! S(1,1) = S(1,2) = 0.1;
%! S(2,1) = S(2,2) = 0.05;
%! rr = 1:100;
%! Xk = zeros(2,length(rr));
%! for r=rr
%!   lambda(1,1) = lambda(1,2) = 1/r;
%!   [U R Q X] = qnom(lambda,S,P);
%!   Xk(:,r) = sum(X,1)';
%! endfor
%! plot(rr,Xk(1,:),";Server 1;","linewidth",2, ...
%!      rr,Xk(2,:),";Server 2;","linewidth",2);
%! xlabel("Class 1 interarrival time");
%! ylabel("Throughput");

