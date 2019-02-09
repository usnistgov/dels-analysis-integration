% Copyright (C) 2008, 2009, 2010, 2011, 2012, 2013, 2014 Moreno Marzolla
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
% @deftypefn {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}, @var{p0}, @var{pm}] =} qsmmm (@var{lambda}, @var{mu})
% @deftypefnx {Function File} {[@var{U}, @var{R}, @var{Q}, @var{X}, @var{p0}, @var{pm}] =} qsmmm (@var{lambda}, @var{mu}, @var{m})
%
% @cindex @math{M/M/m} system
%
% Compute utilization, response time, average number of requests in
% service and throughput for a @math{M/M/m} queue, a queueing system
% with @math{m} identical servers connected to a single FCFS
% queue.
%
% @tex
% The steady-state probability @math{\pi_k} that there are @math{k}
% jobs in the system, @math{k \geq 0}, can be computed as:
%
% $$
% \pi_k = \cases{ \displaystyle{\pi_0 { ( m\rho )^k \over k!}} & $0 \leq k \leq m$;\cr
%                 \displaystyle{\pi_0 { \rho^k m^m \over m!}} & $k>m$.\cr
% }
% $$
%
% where @math{\rho = \lambda/(m\mu)} is the individual server utilization.
% The steady-state probability @math{\pi_0} that there are no jobs in the
% system can be computed as:
%
% $$
% \pi_0 = \left[ \sum_{k=0}^{m-1} { (m\rho)^k \over k! } + { (m\rho)^m \over m!} {1 \over 1-\rho} \right]^{-1}
% $$
%
% @end tex
%
% @strong{INPUTS}
%
% @table @var
%
% @item lambda
% Arrival rate (@code{@var{lambda}>0}).
%
% @item mu
% Service rate (@code{@var{mu}>@var{lambda}}).
%
% @item m
% Number of servers (@code{@var{m} @geq{} 1}).
% If omitted, it is assumed @code{@var{m}=1}.
%
% @end table
%
% @strong{OUTPUTS}
%
% @table @var
%
% @item U
% Service center utilization, @math{U = \lambda / (m \mu)}.
%
% @item R
% Service center response time
%
% @item Q
% Average number of requests in the system
%
% @item X
% Service center throughput. If the system is ergodic, 
% we will always have @code{@var{X} = @var{lambda}}
%
% @item p0
% Steady-state probability that there are 0 requests in the system
%
% @item pm
% Steady-state probability that an arriving request has to wait in the
% queue
%
% @end table
%
% @var{lambda}, @var{mu} and @var{m} can be vectors of the same size. In this
% case, the results will be vectors as well.
%
% @seealso{erlangc,qsmm1,qsmminf,qsmmmk}
%
% @end deftypefn

% Author: Moreno Marzolla <moreno.marzolla(at)unibo.it>
% Web: http://www.moreno.marzolla.name/

function [U, R, Q, X, p0, pm] = qsmmm( lambda, mu, m )
  if ( nargin < 2 || nargin > 3 )
    error('Please enter correct number of arguments');
  end
  if ( nargin == 2 )
    m = 1;
  else
    assert( isnumeric(lambda) && isnumeric(mu) && isnumeric(m), 'the parameters must be numeric vectors');
  end
  [err, lambda, mu, m] = common_size( lambda, mu, m );
  if ( err ) 
    error('parameters are not of common size');
  end
  lambda = lambda(:)';
  mu = mu(:)';
  m = m(:)';
  assert(all( m>0 ), 'm must be >0');
  assert(all( lambda>0 ), 'lambda must be >0');
  X = lambda;
  rho = lambda ./ (m .* mu );
  U = rho;
  assert(all( U < 1 ), 'Processing capacity exceeded');
  Q = 0*lambda;
  p0 = 0*lambda;
  pm = 0*lambda;
  for i=1:length(lambda)
    p0(i) = 1 / ( sumexpn( m(i)*rho(i), m(i)-1 ) + expn(m(i)*rho(i), m(i))/(1-rho(i)));
  end
  pm = erlangc(lambda ./ mu, m);
  Q = m .* rho + rho ./ (1-rho) .* pm;
  R = Q ./ X;
end
%!demo
%! # This is figure 6.4 on p. 220 Bolch et al.
%! rho = 0.9;
%! ntics = 21;
%! lambda = 0.9;
%! m = linspace(1,ntics,ntics);
%! mu = lambda./(rho .* m);
%! [U R Q X] = qsmmm(lambda, mu, m);
%! qlen = X.*(R-1./mu);
%! plot(m,Q,'o',m,qlen,'*');
%! axis([0,ntics,0,25]);
%! legend("Jobs in the system","Queue Length","location","northwest");
%! xlabel("Number of servers (m)");
%! title("\\lambda = 0.9, \\mu = 0.9");


