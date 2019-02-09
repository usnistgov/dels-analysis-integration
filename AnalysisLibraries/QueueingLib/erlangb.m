% Copyright (C) 2014 Moreno Marzolla
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
% @deftypefn {Function File} {@var{B} =} erlangb (@var{A}, @var{m})
%
% @cindex Erlang-B formula
%
% Compute the value of the Erlang-B formula @math{E_B(A, m)} giving the
% probability that an open system with @math{m} identical servers,
% arrival rate @math{\lambda}, individual service rate @math{\mu}
% and offered load @math{A = \lambda / \mu} has all servers busy.
% 
% @tex
% @math{E_B(A, m)} is defined as:
%
% $$
% E_B(A, m) = \displaystyle{{A^m \over m!} \left( \sum_{k=0}^m {A^k \over k!} \right) ^{-1}}
% $$
% @end tex
%
% @strong{INPUTS}
%
% @table @var
%
% @item A
% Offered load, defined as @math{A = \lambda / \mu} where
% @math{\lambda} is the mean arrival rate and @math{\mu} the mean
% service rate of each individual server (real, @math{A > 0}).
%
% @item m
% Number of identical servers (integer, @math{m @geq{} 1}). Default @math{m = 1}
%
% @end table
%
% @strong{OUTPUTS}
%
% @table @var
%
% @item B
% The value @math{E_B(A, m)}
%
% @end table
%
% @var{A} or @var{m} can be vectors, and in this case, the results will
% be vectors as well.
%
% @seealso{qsmmm}
%
% @end deftypefn

% Author: Moreno Marzolla <moreno.marzolla(at)unibo.it>
% Web: http://www.moreno.marzolla.name/
function B = erlangb(A, m)
  if ( nargin < 1 || nargin > 2 )
    error('Please use the correct number of inputs');
  end

  assert( isnumeric(A) && all( A(:) > 0 ), 'A must be positive');
  
  if ( nargin == 1 )
    m = 1;
  else
    assert( isnumeric(m) && all( fix(m(:)) == m(:)) && all( m(:) > 0 ), 'm must be a positive integer');
  end

  [err, A, m] = common_size(A, m);
  if ( err )
    error('parameters are not of common size');
  end

  B = arrayfun( @erlangb_compute, A, m);
end

% Compute E_B(A,m) recursively, as described in:
%
% Guoping Zeng, Two common properties of the erlang-B function,
% erlang-C function, and Engset blocking function, Mathematical and
% Computer Modelling Volume 37, Issues 12–13, June 2003, Pages
% 1287–1296 http://dx.doi.org/10.1016/S0895-7177(03)90040-9
%
% To improve numerical stability, the recursion is based on the inverse
% 1 / E_B rather than E_B itself.

function B = erlangb_compute(A, m)
  Binv = 1.0;
  for k=1:m
    Binv = 1.0 + k/A*Binv;
  end
  B = 1.0 / Binv;
end

%!test
%! fail("erlangb(1, -1)", "positive");
%! fail("erlangb(-1, 1)", "positive");
%! fail("erlangb(1, 0)", "positive");
%! fail("erlangb(0, 1)", "positive");
%! fail("erlangb('foo',1)", "positive");
%! fail("erlangb(1,'bar')", "positive");
%! fail("erlangb([1 1],[1 1 1])","common size");

