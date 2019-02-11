%% 0) Generate Random Instance of Distribution Network
tic;
rng default;
dn1 = DistributionFlowNetworkGenerator;

%% 0.5) Map FlowNetwork 2 Optimization
% a) Map Class data to MCFN OPT list

dn1.mapFlowNodes2ProductionConsumptionList;
dn1.mapFlowEdges2FlowTypeAllowed;

% a) Transform capacitated flow nodes
%2/9/19 TO DO: Make this more general -- for any FlowNode that is
%capacitated, split it.

    %split depots & keep track of the mapping
    numDepot = length(dn1.depotSet);
    numCommodity = length(dn1.commoditySet);
    numEdges = length(dn1.FlowEdgeList);
    depotMapping = zeros(numDepot,2);
    depotList = dn1.depotList;
    flowEdgeList = dn1.FlowEdgeList;
    flowNodeList = dn1.FlowNodeList;
    FlowEdge_flowTypeAllowed = dn1.FlowEdge_flowTypeAllowed;
    FlowNode_ConsumptionProduction = dn1.FlowNode_ConsumptionProduction;
    gg = max(flowEdgeList(:,1))+1;
    
    % Split capacitated node, add capacity and 'cost of opening' to edge
    for ii =1:numDepot
        newIndex = depotList(end,1)+1;
        depotList(end+1,:) = [newIndex, depotList(ii,2), depotList(ii,3)];
        flowNodeList(end+1,:) = [newIndex, depotList(ii,2), depotList(ii,3)];
        depotMapping(ii,:) = [depotList(ii,1), newIndex];
        
        flowEdgeList(flowEdgeList(:,2) == depotList(ii,1),2) = depotList(end,1);
        FlowEdge_flowTypeAllowed(FlowEdge_flowTypeAllowed(:,2) == depotList(ii,1),2) = depotList(end,1);
        
        
        %2/9/19 assume all commodities can flow through all depots
        %FlowEdge_flowTypeAllowed: FlowEdgeID origin destination commodityKind flowUnitCost
        
        flowEdgeList(end+1,:) = [gg, depotList(ii,1), depotList(end,1), dn1.depotSet(ii).capacity, dn1.depotSet(ii).fixedCost];
        FlowEdge_flowTypeAllowed(end+1:end+numCommodity, :) = [repmat(flowEdgeList(end,1:3), numCommodity,1), [1:numCommodity]', zeros(numCommodity,1)];
        FlowNode_ConsumptionProduction(end+1:end+numCommodity,:) = [newIndex*ones(numCommodity,1), [1:numCommodity]', zeros(numCommodity,1)];
        
        %Add split capacitated flow node to flowTypeAllowed list
        %FlowEdge_flowTypeAllowed(end+1:end+numCommodity,:) = [repmat(flowEdgeList(end,1:3), numCommodity,1),kk*ones(numCommodity,1), zeros(numCommodity,1)];
        
        gg = gg +1;
    end
    
    dn1.FlowEdge_flowTypeAllowed = FlowEdge_flowTypeAllowed;
    dn1.FlowEdgeList = flowEdgeList;
    %2/9/19 -- The optimization algorithm is going to add flow balance
    %constraints based on consumption/production, where the flow nodes are
    %the variables. So the ConsumptionProduction data needs to be sequenced
    %by commodityKind first then NodeID.
    % -- Alternatively, could inject the new consumption/production rows
    % (associated with the split node) into the array where they belong
    % (contiguous with the other rows associated with that commodityKind)
    %FlowNode_ConsumptionProduction = FlowNode_ConsumptionProduction(any(FlowNode_ConsumptionProduction,2),:);
    [~,I] = sort(FlowNode_ConsumptionProduction(:,2));
    FlowNode_ConsumptionProduction = FlowNode_ConsumptionProduction(I,:);
    dn1.FlowNode_ConsumptionProduction = FlowNode_ConsumptionProduction;
    dn1.FlowNodeList = flowNodeList;
    dn1.depotList = depotList;
    dn1.depotMapping = depotMapping;
    
%% 0.6) Solve MCFN
toc;
solveMultiCommodityFlowNetwork(dn1)


%% 1) Build and Solve Desteriministic MCFN
%GenerateFlowNetworkSet implements a leave one out heuristic to generate a
%family of candidate MCFN solutions
flowNetworkSet = GenerateFlowNetworkSet(dn1, dn1.depotList(1:length(dn1.depotList)/2,:), dn1.depotFixedCost);

%% 2) MAP MCFN Solution to Distribution System Model
distributionNetworkSet(length(flowNetworkSet)) = DistributionNetwork(dn1);
distributionNetworkSet(1) = dn1;
clear dn1;

for ii = 1:length(distributionNetworkSet)
    distributionNetworkSet(ii).mapFlowNetwork2DistributionNetwork;
end

clear flowNetworkSet ii;

%% 3) Build and Run Low-Fidelity Simulations
flowNetworkFactorySet(length(distributionNetworkSet)) = FlowNetworkFactory;
for ii = 1:length(distributionNetworkSet)
    % Build & Run Simulations

    flowNetworkFactorySet(ii).Model = 'Distribution';
    flowNetworkFactorySet(ii).modelLibrary = 'Distribution_Library';
    
    %Instantiate and set builder helper classes for each flow network
    depotBuilder = IDepotBuilder;
    for jj = 1:length(distributionNetworkSet(ii).depotNodeSet)
        distributionNetworkSet(ii).depotNodeSet(jj).setBuilder(depotBuilder);
    end
    
    flowNetworkFactorySet(ii).addFlowNode(distributionNetworkSet(ii).transportationChannelNodeSet)
    flowNetworkFactorySet(ii).addFlowNode(distributionNetworkSet(ii).depotNodeSet)
    flowNetworkFactorySet(ii).addFlowNode(distributionNetworkSet(ii).customerNodeSet)
    flowNetworkFactorySet(ii).addFlowEdge(distributionNetworkSet(ii).edgeSet)
    flowNetworkFactorySet(ii).buildSimulation;
    
    %TO DO: Transition GA opt to a distributionNetwork based interface
    %distributionNetworkSet(ii).resourceSolution = MultiGA_Distribution(model, distributionNetworkSet(ii).customerNodeSet, distributionNetworkSet(ii).depotNodeSet, 1000*ones(length(distributionNetworkSet(ii).depotNodeSet),1), [], 'true');
    clear MultiGA_Distribution;
    strcat('complete: ', num2str(ii))
end
    clear depotBuilder ii jj;
%% 4) ReBuild Hi-Fidelity Simulation 
for ii = 1:length(distributionNetworkSet)
       
    for jj = 1:length(distributionNetworkSet(ii).customerNodeSet)
        distributionNetworkSet(ii).customerNodeSet(jj).typeID = 'Customer'; %Change Resolution from Probabilistic to Complete
        distributionNetworkSet(ii).customerNodeSet(jj).setCommoditySet(distributionNetworkSet(ii).commoditySet);
    end
    
    for jj = 1:length(distributionNetworkSet(ii).depotNodeSet)
        distributionNetworkSet(ii).depotNodeSet(jj).typeID = 'Depot';
    end
    
end 

%% 5) Build and Run High-Fidelity Simulations
for ii = 1:length(distributionNetworkSet)
    flowNetworkFactorySet(ii).buildSimulation;

    %distributionNetworkSet(ii).policySolution = Distribution_Pareto(model, distributionNetworkSet(ii).customerNodeSet, distributionNetworkSet(ii).depotNodeSet, distributionNetworkSet(ii).transportationNodeSet, distributionNetworkSet(ii).resourceSolution, 1000*ones(length(distributionNetworkSet(ii).resourceSolution(1,:)),1));
    %save GenerateFamily.mat;
    strcat('complete: ', num2str(ii))
end

%% Pareto Analysis

TravelDist = [reshape(distributionNetworkSet(1).policySolution(:,:,1), [],1); reshape(distributionNetworkSet(2).policySolution(:,:,1), [],1); reshape(distributionNetworkSet(3).policySolution(:,:,1), [],1); reshape(distributionNetworkSet(4).policySolution(:,:,1), [],1); reshape(distributionNetworkSet(5).policySolution(:,:,1), [],1)];
ResourceInvestment =  [reshape(distributionNetworkSet(1).policySolution(:,:,3), [],1); reshape(distributionNetworkSet(2).policySolution(:,:,3), [],1); reshape(distributionNetworkSet(3).policySolution(:,:,3), [],1); reshape(distributionNetworkSet(4).policySolution(:,:,3), [],1); reshape(distributionNetworkSet(5).policySolution(:,:,3), [],1)];
ServiceLevel =  1.-[reshape(distributionNetworkSet(1).policySolution(:,:,2), [],1); reshape(distributionNetworkSet(2).policySolution(:,:,2), [],1); reshape(distributionNetworkSet(3).policySolution(:,:,2), [],1); reshape(distributionNetworkSet(4).policySolution(:,:,2), [],1); reshape(distributionNetworkSet(5).policySolution(:,:,2), [],1)];
paretoI = paretoGroup([TravelDist, ResourceInvestment, ServiceLevel]);

scatter3( TravelDist(paretoI), ResourceInvestment(paretoI), 1.-ServiceLevel(paretoI));

warning('on','all');
