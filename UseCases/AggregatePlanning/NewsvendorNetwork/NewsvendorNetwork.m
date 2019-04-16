function [ varargout ] = NewsvendorNetwork( ProductSet, ProcessSet, ConsumableResourceSet, RenewableResourceSet )
%NewsvendorNetwork( ProductSet, ProcessSet, ConsumableResourceSet, RenewableResourceSet )
%Newsvendor Network: 

rng default;
seed = 1;

%% Add the CPLEX solver and APIs to the MATLAB working directory
%addpath(genpath('C:\ILOG\CPLEX_Studio124\cplex\matlab'))
%addpath(genpath('C:\ILOG\CPLEX_Studio126\cplex\matlab')) %ISYE2014 Vlab
addpath(genpath('C:\ILOG\CPLEX_Enterprise_Server1262\CPLEX_Studio\cplex\matlab')) %ISYE2015 Vlab


%% %%%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%
%nPeriods = 12;                                                            %Number of Periods in Planning Horizon
nRepetitions = 10;                                                        %Number of Repetitions

%Map Product to Product
nProducts = length(ProductSet);                                            %Number of Products
meanDemand = [ProductSet.meanDemand];                                      %Expected Demand per Product
stdevDemand = [ProductSet.stdevDemand];                                    %Standard Deviation of Demand per product

%Map Process Set to Activity Set
nActivities = length(ProcessSet);                                          %Number of Activities
revenue =   [ProcessSet.Revenue];                                          %Net profit per unit of activity i

%Map Product & Process to Production
Output = zeros(nProducts, nActivities);                                  %Amount of product n produces per unit of activity i 
for ii = 1:nProducts
   Output(ii, [ProductSet(ii).canBeCreatedBy.ID]) = 1;
end

%Map Renewable Resource Set to Resource Set
nResources = length(RenewableResourceSet);                                 %Number of Renewable Resources
varResourceCost = [RenewableResourceSet.variableCost];                     %Variable Cost of Each unit of Renewable Resource
ResourceCapacityReq = zeros(nResources,nActivities);                      %Amount of Capacity of Renewable Resource j Required for Activity i

%Map Process & RenewableResource to ResourceCapacityReq
for ii = 1:nActivities
    ResourceCapacityReq([ProcessSet(ii).RenewableResourceSet.ID],ii) = [ProcessSet(ii).RenewableResourceCapReq];
end

%Map Consumable Resource Set to Stock Input Set
nStockInputs = length(ConsumableResourceSet);                              %Number of Consumable Resources
varStockCost = [ConsumableResourceSet.variableCost];                       %Variable Cost of Each unit of Stock Input: Purchase and Holding                                                        
StockCapacityReq =  zeros(nStockInputs,nActivities);                      %Amount of Capacity of Consumable Resource j Required for Activity i

%Map Process & ConsumableResource to StockCapacityReq
for ii = 1:nActivities
    StockCapacityReq([ProcessSet(ii).ConsumableResourceSet.ID],ii) = [ProcessSet(ii).ConsumableResourceCapReq];
end   

%Variables
%S_j                        %Amount of Consumable Resource j
%K_j                        %Amount of Renewable Resource j
%X_i                        %Amount of Activity i

%%%%%%%%Variability%%%%%%%%%
    % Generate new streams for 
    [DemandStream, LeadTimeStream, ProductionStream] = RandStream.create('mrg32k3a', 'NumStreams', 3);

    % Set the substream to the "seed"
    DemandStream.Substream = seed;
    %LeadTimeStream.Substream = seed;
    %ProductionStream.Substream = seed;

    % Generate demands
    OldStream = RandStream.setGlobalStream(DemandStream);
    %Dem = repmat(meanDemand,1,nRepetitions);
    Dem=normrnd(repmat(meanDemand, nRepetitions,1), repmat(stdevDemand,nRepetitions,1));
    
    % Generate lead times
    %RandStream.setGlobalStream(LeadTimeStream);
    %LT=poissrnd(meanLT, nRepetitions, nPeriods);
    
    %Generate Capacity: Create Variability In Capacity of Production System
    %RandStream.setGlobalStream(ProductionStream);
    %b = normrnd(b, varB, nRepetitions,nPeriods);
    %availability = (availability(2)-availability(1))*rand(nRepetitions,nPeriods)+availability(1);
    
    RandStream.setGlobalStream(OldStream); % Restore previous stream


%% Build Model
    NN = Cplex('NN');
    NN.Model.sense = 'maximize';

    nbVar = nActivities*nRepetitions+nResources+nStockInputs;

%% Add Variables

%addCols (obj, A, lb, ub, ctype, colname)
    %Add Activity Variables
    ActivityVarIndex = 0;
    for ii =1:nActivities
        for kk = 1:nRepetitions
            NN.addCols(revenue(ii)/nRepetitions,[],0,[], 'C', strcat('X_', num2str(ii), '^', num2str(kk)));
        end
    end
    
    %Add Consumable Variables
    ConsumableVarIndex = ActivityVarIndex+nActivities*nRepetitions;
    for ii =1:nStockInputs
        NN.addCols(-varStockCost(ii),[],0,[], 'C', strcat('S_', num2str(ii)));
    end
    
    %Add Renewable Variables
    RenewableVarIndex = ConsumableVarIndex+nStockInputs;
    for ii =1:nResources
        NN.addCols(-varResourceCost(ii),[],0,[], 'C', strcat('K_', num2str(ii)));
    end
        
%% Add Constraints
%addRows (lhs, A, rhs, rowname)

for kk = 1:nRepetitions
    % Add Resource Capacity Constraints
    %Ax leq K
    for ii =1:nResources
        A = zeros(1,nbVar);
        for jj = 1:nActivities
            A(ActivityVarIndex+(jj-1)*nRepetitions+kk) = ResourceCapacityReq(ii,jj);
        end
        A(RenewableVarIndex+ii) = -1;
        NN.addRows(-inf, A, 0, strcat('ResourceBal_', num2str(ii), '^', num2str(kk)));
    end
    
    % Add Stock Input Capacity Constraints
    %Rs*x leq S
    for ii =1:nStockInputs
        A = zeros(1,nbVar);
        for jj = 1:nActivities
            A(ActivityVarIndex+(jj-1)*nRepetitions+kk) = StockCapacityReq(ii,jj);
        end
        A(ConsumableVarIndex+ii) = -1;
        NN.addRows(-inf, A, 0, strcat('StockBal_', num2str(ii), '^', num2str(kk)));
    end
    
    % Add Demand Constraints
    %Rd*x leq D
    for ii =1:nProducts
        A = zeros(1,nbVar);
        for jj = 1:nActivities
            A(ActivityVarIndex+(jj-1)*nRepetitions+kk) = Output(ii,jj);
        end
        NN.addRows(0, A, Dem(kk,ii), strcat('DemandBal_', num2str(ii), '^', num2str(kk)));
    end
end
  
%% Solve Model    
%disp(PP.Model.A);
NN.solve();
NN.writeModel('NN.mps');

disp (' - Solution:');
for ii = 1:nActivities
    fprintf(strcat('\n Activity ', num2str(ii),'  = %f\n'), mean(NN.Solution.x(ActivityVarIndex+(ii-1)*nRepetitions+1: ActivityVarIndex+ii*nRepetitions)));
end
fprintf('\n   Renewable Resources = %f\n', NN.Solution.x(RenewableVarIndex+1 : RenewableVarIndex+ nResources));  
fprintf('\n   Consumable Resources = %f\n', NN.Solution.x(ConsumableVarIndex+1 : ConsumableVarIndex+ nStockInputs));  
fprintf('\n   Profit = %f\n', NN.Solution.objval);    

  
end


