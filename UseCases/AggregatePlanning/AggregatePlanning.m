function [ varargout ] = AggregatePlanning( varargin )
%[Production, Workforce, Overtime] = AggregatePlanning
% AggregatePlanning formulates and solves a Linear Programming
% Optimization model using the CPLEX solver to solve an Aggregate Planning
% problem, specifically (at this time) the workforce planning aspect.

% To run the ProductionSystem simulation afterward:
% [meanTotalProfit, varTotalProfit, meanServiceLevel, varServiceLevel ] = ProductionSystem(Production, Workforce, Overtime)

%INPUTS:
% * none at this time

%OUTPUTS:
% * Printed Solution
% * varargout = {X_t, W_t, O_t};
% * X_t = Production Level for each time period
% * W_t = Workforce Level for each time period
% * O_t = Overtime Level for each time period

%PLOTS:
% * none at this time

%ATTRIBUTION:
% Section 16.4 of Hopp & Spearman, Factory Physics, 1996 (edition 1).

% LICENSE:  3-clause "Revised" or "New" or "Modified" BSD License.
% Copyright (c) 2015, Georgia Institute of Technology.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of the Georgia Institute of Technology nor the
%       names of its contributors may be used to endorse or promote products
%       derived from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE GEORGIA INSTITUTE OF TECHNOLOGY BE LIABLE FOR 
% ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

%rng default;

%% Add the CPLEX solver and APIs to the MATLAB working directory
%addpath(genpath('C:\ILOG\CPLEX_Studio124\cplex\matlab'))
%addpath(genpath('C:\ILOG\CPLEX_Studio126\cplex\matlab')) %ISYE2014 Vlab
addpath(genpath('C:\ILOG\CPLEX_Enterprise_Server1262\CPLEX_Studio\cplex\matlab')) %ISYE2015 Vlab


%% %%%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%
nPeriods = 12;              %Number of Periods in Planning Horizon

%maxDem = 0;                 %Maximum Demand in Each Period
%minSales = 0;               %Minimum Sales Allowed in Each Period
meanDemand = [200 220 230 300 400 450 320 180 170 170 160 180];
%meanDemand = round((140-80)*rand(1,nPeriods) + 80); %Expected Demand in Each Period

revenue =   1000;           %Net profit per unit of product sold
holding =   10;             %Cost to hold one unit of product for one period
b = 12;                     %number of Worker-hours required to produce one unit
varLaborC = 35;             %cost of regular time in dollars per worker-hour
varLaborOC = 52.5;          %cost of overtime in dollars per worker-hour
IncreaseWorkforce = 15;     %cost to increase workforce by one worker-hour per period
DecreaseWorkforce = 9;      %cost to decrease workforce by one worker-hour per period

%% Variables
% The decision variables declared below but are commented out are the
% decision variables in the optimization model. In many cases, only the
% initial values of particular variables, such as workforce and inventory,
% need to be set explicitly in this section.

%X_t                         %amount produced in period t
%St = meanDemand_t          %amount sold in period t
%I_t                        %inventory at end of t
I_0 = 0;                    %initial inventory (given as data)
%W_t                        %workforce in period t in worker-hours of regular time
W_0 = 168*15;               %initial workforce
%H_t                        %increase (hires) in workforce from period t-1
                                %to t in worker-hours
%F_t                        %decrease (fires) in workforce from period t-1
                                %to t in worker-hours
%O_t                        %overtime in period t in hours

%% Set Varargin overrides
% Check the Varargin for parameter overrides
if isempty(varargin) == 0
   for ii = 1:length(varargin)
       newVarPar = varargin{1,ii};
       %eval(holding = 5)
       eval(strcat(newVarPar{1,1}, '=', newVarPar{1,2}, ';'));
   end
end

try
%% Build Model
    PP = Cplex('PP');
    PP.Model.sense = 'minimize';

    %There are 6 decision variables in each time period of the optimization
    %horizon.
    nbVar = nPeriods*6;

%% Add Variables
%Note to Self 7/16: Need a Variable for each Variable type that indicates
%where it starts in the arry; i.e. WorkforceVarIndex = nPeriods then
%A(nPeriods*1+i) = 1 becomes A(WorkforceVarIndex+i);

%addCols (obj, A, lb, ub, ctype, colname)
    %Add Inventory Variables
    InventoryVarIndex = 0;
    for ii =1:nPeriods
        PP.addCols(holding,[],0,[], 'C', strcat('I_', num2str(ii)));
    end
    
    %Add Workforce Variables
    WorkforceVarIndex = nPeriods;
    for ii =1:nPeriods
        PP.addCols(varLaborC,[],0,[], 'C', strcat('W_', num2str(ii)));
    end
    
    %Add Overtime Variables
    OvertimeVarIndex = nPeriods*2;
    for ii =1:nPeriods
        PP.addCols(varLaborOC,[],0,[], 'C', strcat('O_', num2str(ii)));
    end
    
    %Add Hiring Variables
    HiringVarIndex = nPeriods*3;
    for ii =1:nPeriods
        PP.addCols(IncreaseWorkforce,[],0,[], 'C', strcat('H_', num2str(ii)));
    end
    
    %Add Firing Variables
    FiringVarIndex = nPeriods*4;
    for ii =1:nPeriods
        PP.addCols(DecreaseWorkforce,[],0,[], 'C', strcat('F_', num2str(ii)));
    end
    
    %Add Production Variables
    ProductionVarIndex = nPeriods*5;
    for ii =1:nPeriods
        PP.addCols(0,[],0,[], 'C', strcat('X_', num2str(ii)));
    end
    
%% Add Constraints
%addRows (lhs, A, rhs, rowname)

    % Add Inventory Constraints
    % Exception on First to accomodate Initial Inventory
    A = zeros(1,nbVar);
    A(1) = 1;
    A(ProductionVarIndex+1) = -1;
    PP.addRows(-meanDemand(1)+I_0, A, -meanDemand(1)+I_0, strcat('InvBal_', num2str(1)));
    
    %I_2 - I_1 - X_2 = -d_2;
    for ii =2:nPeriods
        A = zeros(1,nbVar);
        A(InventoryVarIndex+ii) = 1;
        A(InventoryVarIndex+ii-1) = -1;
        A(ProductionVarIndex+ii) = -1;
        PP.addRows(-meanDemand(ii), A, -meanDemand(ii), strcat('InvBal_', num2str(ii)));
    end
    
    % Add WorkForce Constraints
    %Exception on First to accomodate Initial WorkForce
    %W_1 - W_0 - H_1 + F_1 = 0;
    A = zeros(1,nbVar);
    A(WorkforceVarIndex+1) = 1;
    A(HiringVarIndex+1) = -1;
    A(FiringVarIndex+1) = 1;
    PP.addRows(W_0, A, W_0, strcat('WorkForceBal_', num2str(1)));
    
    %W_2 - W_1 - H_2 + F_2 = 0
    for ii =2:nPeriods
        A = zeros(1,nbVar);
        A(WorkforceVarIndex+ii) = 1;
        A(WorkforceVarIndex+ii-1) = -1;
        A(HiringVarIndex+ii) = -1;
        A(FiringVarIndex+ii) = 1;
        PP.addRows(0, A, 0, strcat('WorkForceBal_', num2str(ii)));
    end
    
    % Add Production Constraints
    %12X_1 - W_1 - O_1 <= 0
    for ii =1:nPeriods
        A = zeros(1,nbVar);
        A(ProductionVarIndex+ii) = b;
        A(WorkforceVarIndex+ii) = -1;
        A(OvertimeVarIndex+ii) = -1;
        PP.addRows(-inf, A, 0, strcat('ProdBal_', num2str(ii)));
    end
  
%% Solve Model    
%disp(PP.Model.A);
PP.solve();
PP.writeModel('PP.mps');

%% Print the Solution to the Decision Variables
disp (' - Solution:');
{'Period', 'Demand', 'Inventory', 'Workforce', 'Overtime', 'Hiring', 'Firing', 'Production'}
for jj = 1:nPeriods
    {strcat('Period ', num2str(jj),': '), meanDemand(jj), num2str(PP.Solution.x(nPeriods*0+jj)), num2str(PP.Solution.x(nPeriods*1+jj)), num2str(PP.Solution.x(nPeriods*2+jj)), ...
        num2str(PP.Solution.x(nPeriods*3+jj)), num2str(PP.Solution.x(nPeriods*4+jj)), num2str(PP.Solution.x(nPeriods*5+jj))}
end

fprintf('\n   Cost = %f\n', PP.Solution.objval);    
fprintf('\n   Profit = %f\n', revenue*sum(meanDemand) - PP.Solution.objval);
  
%% Output the Solution
% Only the Production, Workforce, and Overtime solutions are output because
% they are the only data required by the ProductionSystem simulation
Solution = PP.Solution.x;
X_t = Solution(ProductionVarIndex+1:ProductionVarIndex+nPeriods);
W_t = Solution(WorkforceVarIndex+1:WorkforceVarIndex+nPeriods);
O_t = Solution(OvertimeVarIndex+1:OvertimeVarIndex+nPeriods);
%H_t = Solution(HiringVarIndex+1:HiringVarIndex+nPeriods);
%F_t = Solution(FiringVarIndex+1:FiringVarIndex+nPeriods);

varargout = {X_t, W_t, O_t};

catch m
    throw (m);      
end


























