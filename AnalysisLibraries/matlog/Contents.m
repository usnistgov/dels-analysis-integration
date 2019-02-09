% Logistics Engineering Toolbox.
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)
%
% Location:
%   ala          - Alternate location-allocation procedure
%   alaplot      - Plot ALA iterations
%   minisumloc   - Continuous minisum facility location
%   pmedian      - Hybrid algorithm for p-median location
%   randX        - Random generation of new points
%   sumcost      - Determine total cost of new facilities
%   ufladd       - Add construction procedure
%   ufldrop      - Drop construction procedure
%   ufl          - Hybrid algorithm for uncapacitated facility location
%   uflxchg      - Exchange best improvement procedure
%
% Freight transport:
%   aggshmt      - Aggregate multiple shipments
%   maxpayld     - Determine maximum payload
%   plotshmt     - Plot shipments
%   rateLTL      - Determine estimated LTL rate
%   mincharge    - Minimum transport charge for TL, LTL, or multistop route
%   minTLC       - Minimum total logistics cost comparing TL and LTL
%   totlogcost   - Calculate total logistics cost
%   transcharge  - Transport charge for TL and LTL
%
% Routing:
%   checkrte     - Check if valid route vector
%   drte         - Convert destination in route to negative value
%   isorigin     - Identify origin of each shipment in route
%   loccost      - Calculate location sequence cost
%   insertimprove - Insert with improvement for route construction
%   mincostinsert - Min cost insertion of route i into route j
%   pairwisesavings - Calculate pairwise savings
%   rte2idx      - Convert route to route index vector
%   rte2ldmx     - Convert route vector to load-mix cell array
%   rte2loc      - Convert route to location vector
%   rtesegid     - Identify shipments in each segment of route
%   rtesegsum    - Cumulative sum over each segment of route
%   rtenorm      - Normalize route vector
%   rteTC        - Total cost of route
%   savings      - Savings procedure for route construction
%   sh2rte       - Create routes for shipments not in existing routes
%   twoopt       - 2-optimal exchange procedure for route improvement
%
% Vehicle routing (VRP) and traveling salesman (TSP) problems:
%   combineloc   - Combine non-overlapping location sequences
%   locTC        - Calculate total cost of location sequences
%   sfcpos       - Compute position of points along 2-D spacefilling curve
%   tspchinsert  - Convex hull insertion algorithm for TSP construction
%   tspnneighbor - Nearest neighbor algorithm for TSP construction
%   tspspfillcur - Spacefilling curve algorithm for TSP construction
%   tsp2opt      - 2-optimal exchange procedure for TSP improvement
%   vrpcrossover - Crossover procedure for VRP improvement
%   vrpexchange  - Two-vertex exchange procedure for VRP improvement
%   vrpinsert    - Insertion algorithm for VRP construction
%   vrpsavings   - Clark-Wright savings algorithm for VRP construction
%   vrpsweep     - Gillett-Miller sweep algorithm for VRP construction
%   vrptwout     - Generate output VRP with time windows
%
% Networks:
%   addconnector - Add connector from new location to transport. network
%   adj2incid    - Convert weighted adjacency matrix to incidence matric
%   adj2lev      - Convert weighted adjacency to weighted interlevel matrix
%   adj2list     - Convert weighted adjacency matrix to arc list
%   dijk         - Shortest paths using Dijkstra algorithm
%   dijkdemo     - Demonstrate Dijkstra's algorithm to find shortest path
%   gtrans       - Greedy heuristic for the transportation problem
%   lev2adj      - Convert weighted interlevel to weighted adjacency matrix
%   lev2list     - Weighted interlevel to arc list representation
%   incid2list   - Convert node-arc incidence matrix to arc list
%   list2adj     - Convert arc list to weighted adjacency matrix
%   list2incid   - Convert arc list to incidence matrix
%   lp2mcnf      - Convert LP solution to MCNF arc and node flows
%   mcnf2lp      - Convert minimum cost network flow to LP model
%   minspan      - Minimum weight spanning tree using Kruskal algorithm
%   pred2path    - Convert predecessor indices to shortest path
%   loc2listidx  - Find indices of loc seq segments in arc list
%   subgraph     - Create subgraph from graph
%   thin         - Thin degree-two nodes from graph
%   trans        - Transportation and assignment problems
%   tri2adj      - Triangle indices to adjacency matrix representation
%   tri2list     - Convert triangle indices to arc list representation
%   trineighbors - Find neighbors of a triangle
%
% Geocoding:
%   destloc      - Destination location from starting location
%   fipsnum2alpha - Convert numeric state FIPS code to alphabetic
%   invproj      - Inverse Mercator projection
%   lonlat2city  - Determine nearest city given a location
%   makemap      - Create projection plot of World or US
%   normlonlat   - Convert longitude and latitude to normal form
%   proj         - Mercator projection
%
% Layout:
%   binaryorder  - Binary ordering of machine-part matrix
%   loc2W        - Converts routings to weight matrix
%   sdpi         - Steepest descent pairwise interchange heuristic for QAP
%
% General purpose:
%   dists        - Metric distances between vectors of points
%   gantt        - Gantt chart
%   lplog        - Matlog linear programming solver
%   milplog      - Matlog mixed-integer linear programming solver
%   Milp         - Mixed-integer linear programming model
%   pplot        - Projection plot
%
% Utility:
%   arcang       - Arc angles (in degrees) from xy to XY
%   argmax       - Indices of maximum component
%   argmin       - Indices of minimum component
%   argsort      - Indices of sort in ascending order
%   boundrect    - Bounding rectangle of XY points
%   cell2padmat  - Convert cell array of vectors to NaN-padded matrix
%   deletelntag  - Delete last tagged line objects from plot
%   editcellstr  - Edit or create a cell array of strings
%   file2cellstr - Convert file to cell array
%   findXY       - Find XY points in rectangle
%   fixseq       - Fixed sequence proportional to percentage of demand
%   getfile      - Download file from Internet and save local copy
%   grect        - Get rectangular region in current axes
%   idx2is       - Convert index vector to n-element logical vector
%   iff          - Conditional operator as a function
%   in2out       - Convert variable number of inputs to outputs
%   idxkey       - Create index key to array from unique integer values
%   inputevaldlg - Input dialog with evaluation of values
%   invperm      - Inverse permutation
%   isinrect     - Are XY points in rectangle
%   isint        - True for integer elements (within tolerance)
%   is0          - True for zero elements (within tolerance)
%   loaddatafile - Common code for data file functions
%   mand         - Multiple AND with real or cellstr vector pairs
%   matlogupdate - Automatically download updates to Matlog files
%   mat2vec      - Convert columns of matrix to vectors
%   mdisp        - Display matrix
%   mor          - Multiple OR with each element of real or cellstr vector
%   num2cellstr  - Create cell array of strings from numerical vector
%   optstructchk - Validate 'opt' structure
%   padmat2cell  - Convert rows of NaN-padded matrix to cell array
%   pauseplot    - Drawnow and then pause after plotting
%   projtick     - Project tick marks on projected axes
%   randreorder  - Random re-ordering of an array
%   sdisp        - Display structure vector with all scalar field values
%   struct2scalar - Remove non-scalar values from structure vector
%   subsetstruct - Extract subset of each field of a structure
%   sub          - Create subarray
%   varnames     - Convert input to cell arrays of variable name and value
%   vec2struct   - Add each element in vector to field in structure array
%   vdisp        - Display vectors
%   wtbinselect  - Weighted binary selection
%   wtrand       - Weighted random number
%   wtrandperm   - Weighted random permutation
%   wtrouselect  - Weighted roulette selection
%   xls2struct   - Convert Excel database to structure array
%
% Data:
%   mapdata      - Data for maps of the World, US, and North Carolina
%   nccity       - North Carolina cities with populations of at least 10k
%   uscenblkgrp  - US census block group data
%   uscity       - US cities data
%   uscity10k    - US cities with populations of at least 10,000 data
%   uscity50k    - US cities with populations of at least 50,000 data
%   usrdlink     - US highway network links data
%   usrdnode     - US highway network nodes data
%   uszip3       - US 3-digit ZIP code data
%   uszip5       - US 5-digit ZIP code data
%   vrpnc1       - Christofiles' VRP problem 1 data
%   vrpsolrc101  - Soloman's VRP with Time Windows problem RC101 data
%
