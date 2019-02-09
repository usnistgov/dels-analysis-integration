
function [meanTotalProfit, varTotalProfit, meanServiceLevel, varServiceLevel ] = ProductionSystem(Production, Workforce, Overtime, varargin)
%[meanTotalProfit, varTotalProfit, meanServiceLevel, varServiceLevel ] = ProductionSystem(Production, Workforce, Overtime)
% runlength is the number of days of demand to simulate
% seed is the index of the substreams to use (integer >= 1)
% other is not used
%runlength must be greater than warmup period 

%INPUTS:
% * Production = Production Level in each period
% * Workforce = Workforce Level in each period
% * Overtime = Overtime Level in each period
% * varargin is a {key, value} pair for overriding default system
% parameters

%OUTPUTS:
% * meanTotalProfit = mean across all replications of Total Profit for entire run period
% * varTotalProfit = variance across all replications of Total Profit for entire run period
% * meanServiceLevel = = mean across all replications of Service Level
% - Service Level is defined as 1 - sum(demand unfilled at the end of each
% period) / sum(demand in each period)
% * varServiceLevel = variance across all replications of Service Level

%PLOTS:
% * none at this time



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

%rng default %resets the random number generator -- allows replicability


%% %%%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%
% Experiment
nPeriods = 12;                  %Number of Periods in Planning Horizon
nRepetitions = 20;              %Repetitions
warmup = 0;                     %length of warm up period
seed =1;   
              
% System Properties
%maxDem = 0;                 %Maximum Demand in Each Period
%minSales = 0;               %Minimum Sales Allowed in Each Period
meanDemand = [200 220 230 300 400 450 320 180 170 170 160 180];
%meanDemand = round((140-80)*rand(1,nPeriods) + 80); %Expected Demand in Each Period
stdevDemand = 0*ones(1,nPeriods);

revenue =   1000;           %Net profit per unit of product sold
holding =   10;             %Cost to hold one unit of product for one period
backorder = 0;              %Cost to backorder one unit of product for one period
b = 12;                     %number of Worker-hours required to produce one unit
varB = 0;                   %variance of Worker-hours required to produce one unit
availability = [1, 1];    %Worker Availability between 90% and 100%
varLaborC = 35;             %cost of regular time in dollars per worker-hour
varLaborOC = 52.5;          %cost of overtime in dollars per worker-hour
IncreaseWorkforce = 15;     %cost to increase workforce by one worker-hour per period
DecreaseWorkforce = 9;      %cost to decrease workforce by one worker-hour per period
I_backorder = 0;            %Indicator if backordering is allowed

%% %%%%%% Decision Variables %%%%%%%%%
%Production;                         %amount produced in period t
%St = meanDemand_t          %amount sold in period t
%FGInv                        %inventory at end of t
initialFGI = 0;                    %initial inventory (given as data)
%Workforce;                        %workforce in period t in worker-hours of regular time
initialWorkforce = 168*15;               %initial workforce
%Hiring                       %increase (hires) in workforce from period t-1
                                %to t in worker-hours
%Firing                       %decrease (fires) in workforce from period t-1
                                %to t in worker-hours
%Overtime;                       %overtime in period t in hours

%% Check for Errors and Run-time Modifications
% Check the inputs for correct length
if length(Production) ~= nPeriods || length(Workforce) ~= nPeriods || length(Overtime) ~= nPeriods
    error('Input does not contain enough data. Check granularity of aggregation; i.e., length(input) = nPeriods.')
end

% Check the Varargin for parameter overrides
if isempty(varargin) == 0
   for ii = 1:length(varargin)
       newVarPar = varargin{1,ii};
       %eval(holding = 5)
       eval(strcat(newVarPar{1,1}, '=', newVarPar{1,2}, ';'));
   end
end


%%%%%%%%Variability%%%%%%%%%
    % Generate new streams for 
    [DemandStream, LeadTimeStream, ProductionStream] = RandStream.create('mrg32k3a', 'NumStreams', 3);

    % Set the substream to the "seed"
    DemandStream.Substream = seed;
    %LeadTimeStream.Substream = seed;
    ProductionStream.Substream = seed;

    % Generate demands
    OldStream = RandStream.setGlobalStream(DemandStream);
    %Dem = repmat(meanDemand,1,nRepetitions);
    Dem=normrnd(repmat(meanDemand, nRepetitions,1), repmat(stdevDemand,nRepetitions,1));
    
    % Generate lead times
    %RandStream.setGlobalStream(LeadTimeStream);
    %LT=poissrnd(meanLT, nRepetitions, nPeriods);
    
    %Generate Capacity: Create Variability In Capacity of Production System
    RandStream.setGlobalStream(ProductionStream);
    b = normrnd(b, varB, nRepetitions,nPeriods);
    availability = (availability(2)-availability(1))*rand(nRepetitions,nPeriods)+availability(1);
    
    RandStream.setGlobalStream(OldStream); % Restore previous stream

Output = zeros(2,nRepetitions);
Inv = zeros(nRepetitions, nPeriods);
for jj =1:nRepetitions
    
    %Vector tracks outstanding orders. Row 1: day of delivery and row 2: quantity.
    FGInv = initialFGI;
    %Variables to estimate service level constraint.
    nUnits = 0;
    nLate = 0;

    TotalProfit = 0;
    
    for ii=1:nPeriods
               
        %Receive Replenishment Orders
        
        %Adjust Workforce Levels
        if (ii > warmup) && ii > 1
            TotalProfit = TotalProfit - IncreaseWorkforce*max(Workforce(ii)-Workforce(ii-1),0) - DecreaseWorkforce*max(Workforce(ii-1)-Workforce(ii),0);
        elseif (ii > warmup) && ii == 1
            TotalProfit = TotalProfit - IncreaseWorkforce*max(Workforce(ii)-initialWorkforce,0)- DecreaseWorkforce*max(initialWorkforce-Workforce(ii),0);
        end
        
        
        %Production
        Production(ii) = min(availability(jj,ii)*(Workforce(ii)+Overtime(ii))/b(jj,ii), Production(ii));
        FGInv = FGInv +  Production(ii);
        if (ii > warmup)
            TotalProfit = TotalProfit - varLaborC*Workforce(ii) - varLaborOC*Overtime(ii);
        end
        
        %Satisfy or backorder demand
        Demand = Dem(jj,ii);
        FGInv = FGInv - Demand;
        if(ii > warmup)
            nUnits = nUnits + Demand;
            if FGInv < 0 && I_backorder == 1
                nLate = nLate + min(Demand, -FGInv);
                TotalProfit = TotalProfit + revenue*(Demand) + backorder*FGInv;
            elseif FGInv < 0 && I_backorder == 0
                nLate = nLate + min(Demand, -FGInv);
                TotalProfit = TotalProfit + revenue*(Demand+FGInv);
                FGInv = 0;
            elseif ge(FGInv,0) ==1
                TotalProfit = TotalProfit + revenue*(Demand) - holding*FGInv;
            end
        end
        
        %Record Inventory
        Inv(jj,ii) = FGInv; 
    end

Output(1,jj) = TotalProfit;%/(nPeriods-warmup);
Output(2,jj) = 1-nLate/nUnits;


end



%First row has mean cost, second has stockout rate:
meanTotalProfit = mean(Output(1,:));
varTotalProfit = var(Output(1,:))/nRepetitions;
meanServiceLevel = mean(Output(2,:)); % Constraint not satisfied if this is positive
varServiceLevel = var(Output(2,:))/nRepetitions;

end

%Multiple Resources
%meanCapacity = [40*15,40*6,40*7]'; %[Resource1, Resource2, Resource3] in hours per unit
%stdevCapacity = [4*sqrt(10),4*sqrt(6),4*sqrt(7)]'; %[Resource1, Resource2, Resource3] in hours per unit
%ProdCap = normrnd((repmat(meanProdCapReq,1,nRepetitions,nPeriods)),(repmat(stdevProdCapReq,1,nRepetitions,nPeriods)),length(meanProdCapReq),nRepetitions,nPeriods)

%meanProdCapReq = [10,3,5]'; %[Resource1, Resource2, Resource3] in hours per unit
%stdevProdCapReq = [1,0.3,0.5]'; %[Resource1, Resource2, Resource3] in hours per unit
%ProdCapReq = normrnd((repmat(meanProdCapReq,1,nRepetitions,nPeriods)),(repmat(stdevProdCapReq,1,nRepetitions,nPeriods)),length(meanProdCapReq),nRepetitions,nPeriods)

%Production = min(floor(ProdCap(:,j,i)./ProdCapReq(:,j,i)), meanDemand(j,i));
