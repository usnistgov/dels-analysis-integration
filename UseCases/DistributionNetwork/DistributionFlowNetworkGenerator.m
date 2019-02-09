function [distributionNetwork] = DistributionFlowNetworkGenerator(varargin)
% DistributionFlowNetworkGenerator generates a random 
% TO DO: Output a Distribution Network Instance that contains the
% flownetwork as a reference
import Classdefs.*

distributionNetwork = DistributionNetwork;

%% %%% Parameters %%%
    numCustomers = 10;
    numDepot = 5;
    gridSize = 240; %240 minutes square box, guarantee < 8hour RT
    intraDepotDiscount = 0.1;
    commoditydensity = 0.75;
    depotconcentration = 0.25; 
    depotFixedCost = 1e6;
    depotGrossCapacity = 1e7;

    %FlowNode = [Node_ID, X, Y]
    %% Generate Customer Set
    %CustomerList < FlowNodeList = [Node_ID, X, Y]
    customerList = zeros(numCustomers,3);
    %customerSet(numCustomers) = Customer;
    %Generate Customer Locations
    for ii = 1:numCustomers
        %[i x y]
        customerList(ii,:) = [ii, gridSize*rand(1), gridSize*rand(1)];
        customerSet(ii) = Customer(customerList(ii,:));
    end


    %% Generate Depot Set
    %depot < FlowNode = [NodeID, X, Y, fixedCost]
    depotList = zeros(numDepot,3);
    jj = numCustomers+1;
    for ii = 1:numDepot
        %[i x y]
        minLoc = depotconcentration*gridSize;
        maxLoc = (1-depotconcentration)*gridSize;
        x = (maxLoc-minLoc)*rand(1) + minLoc;
        y = (maxLoc-minLoc)*rand(1) + minLoc;
        depotList(ii,:) = [jj, x, y];
        depotSet(ii) = Depot(depotList(ii,:));
        depotSet(ii).fixedCost = depotFixedCost;
        depotSet(ii).capacity = depotGrossCapacity;
        jj = jj+1;
    end

    flowNodeList = [customerList; depotList];
    numNodes = numCustomers+numDepot;
    numCommodity = (numCustomers-1)*numCustomers;

    flowNodeList = [customerList; depotList];
    distributionNetwork.FlowNodeList = flowNodeList;
    distributionNetwork.FlowNodeSet = {customerSet, depotSet};
    numNodes = length(flowNodeList);
    
    %% Generate FlowEdge Set
    % FlowEdge = ID sourceFlowNode targetFlowNode grossCapacity flowFixedCost
    numArc = numNodes*(numNodes-1);
    flowEdgeList = zeros(numArc, 5);
    gg = 1;
    for ii = 1:numNodes
        for jj = 1:numNodes
            if eq(ii,jj)==0
                flowEdgeList(gg,:) = [gg, flowNodeList(ii,1), flowNodeList(jj,1), 1e7, 0.01];
                flowEdgeSet(gg) = FlowEdge(flowEdgeList(gg,:));
                
                %Lookup the FlowNetwork with the source/target ID
                for kk = 1:length(distributionNetwork.FlowNodeSet)
                    sourceFlowNetwork = findobj(distributionNetwork.FlowNodeSet{kk}, 'ID', ii);
                    if isempty(sourceFlowNetwork) == 0
                        flowEdgeSet(gg).sourceFlowNetwork = sourceFlowNetwork;
                    end
                    
                    targetFlowNetwork = findobj(distributionNetwork.FlowNodeSet{kk}, 'ID', jj);
                    if isempty(targetFlowNetwork) == 0
                        flowEdgeSet(gg).targetFlowNetwork = targetFlowNetwork;
                    end
                end
                
                gg=gg+1;
            end
        end
    end

    %This should be moved to a Flow Network 2 OPT translation function
    %split depots & keep track of the mapping
    depotMapping = zeros(numDepot,2);    
    for ii =1:numDepot
        newIndex = depotList(end,1)+1;
        depotList(end+1,:) = [newIndex, depotList(ii,2), depotList(ii,3)];
        depotMapping(ii,:) = [depotList(ii,1), newIndex];
        flowEdgeList(flowEdgeList(:,2) == depotList(ii,1),2) = depotList(end,1);
        flowEdgeList(end+1,:) = [gg, depotList(ii,1), depotList(end,1), depotGrossCapacity, depotFixedCost];
        gg = gg +1;
    end


    distributionNetwork.FlowEdgeList = flowEdgeList;
    distributionNetwork.FlowEdgeSet = flowEdgeSet;
    numArc = length(flowEdgeList);
    

    %% Generate Production/Consumption Data
    %FlowNode_ConsumptionProduction := FlowNodeID Commodity Production/Consumption
    FlowNode_ConsumptionProduction = zeros(numNodes*numCommodity, 3);
    %Customer < FlowNetwork -- produces, consumes, productionRate, consumptionRate
    kk = 1;
    for ii = 1:numCustomers
        for jj = 1:numCustomers
            if eq(ii,jj)==0
                if rand(1) < commoditydensity
                    supply = randi(500);
                    FlowNode_ConsumptionProduction(numNodes*(kk-1)+1:numNodes*(kk-1)+ numNodes,1) = 1:numNodes;
                    FlowNode_ConsumptionProduction(numNodes*(kk-1)+1:numNodes*(kk-1)+ numNodes,2) = kk;
                    FlowNode_ConsumptionProduction(numNodes*(kk-1)+ii,3) = supply;
                    FlowNode_ConsumptionProduction(numNodes*(kk-1)+jj,3) = -1*supply;
                    
                    newCommodity(kk) = Commodity;
                    newCommodity(kk).ID = kk;
                    newCommodity(kk).Quantity = supply;
                    newCommodity(kk).OriginID = ii;
                    newCommodity(kk).Origin = customerSet(ii);
                    customerSet(ii).produces(end+1) = newCommodity(kk);
                    customerSet(ii).productionRate(end+1) = supply;
                    newCommodity(kk).DestinationID = jj;
                    newCommodity(kk).Destination = customerSet(jj);
                    customerSet(jj).consumes(end+1) = newCommodity(kk);
                    customerSet(jj).consumptionRate(end+1) = supply;

                    kk = kk+1;
                end
            end
        end
    end
    
    distributionNetwork.commoditySet = newCommodity;
    distributionNetwork.FlowNode_ConsumptionProduction = FlowNode_ConsumptionProduction;
    numCommodity = kk;

    %% Generate flowTypeAllowed and flowUnitCost for each FlowEdge
    % FlowEdge_flowTypeAllowed: FlowEdgeID origin destination k flowUnitCost
    %flowUnitCost is the distance of the 
    FlowEdge_flowTypeAllowed = zeros(numArc*numCommodity, 5);
    for kk = 1:numCommodity
    	%FlowEdge_flowTypeAllowed((kk-1)*numArc+1:kk*numArc,:) = [flowEdgeList(:,1:3),kk*ones(numArc,1),sqrt((flowNodeList(flowEdgeList(:,2),2)-flowNodeList(flowEdgeList(:,3),2)).^2 + (flowNodeList(flowEdgeList(:,2),3)-flowNodeList(flowEdgeList(:,3),3)).^2)];
    end
    
    for ii = 1:length(distributionNetwork.FlowEdgeSet)
       distributionNetwork.FlowEdgeSet(ii).flowTypeAllowed = [1:length(distributionNetwork.commoditySet)];
       distributionNetwork.FlowEdgeSet(ii).setEdgeWeight;
       distributionNetwork.FlowEdgeSet(ii).flowUnitCost = distributionNetwork.FlowEdgeSet(ii).Weight.*ones(1,length(distributionNetwork.commoditySet));
       
       if isa(distributionNetwork.FlowEdgeSet(ii).sourceFlowNetwork, 'Depot') && isa(distributionNetwork.FlowEdgeSet(ii).targetFlowNetwork, 'Depot')
           distributionNetwork.FlowEdgeSet(ii).flowUnitCost = intraDepotDiscount.*distributionNetwork.FlowEdgeSet(ii).flowUnitCost;
       end
       
    end

    %For flows between depots: multiple flowUnitCost by intraDepotDiscount
    %FlowEdge_flowTypeAllowed(FlowEdge_flowTypeAllowed(:,2)>numCustomers & FlowEdge_flowTypeAllowed(:,3)>numCustomers,5) = intraDepotDiscount*FlowEdge_flowTypeAllowed(FlowEdge_flowTypeAllowed(:,2)>numCustomers & FlowEdge_flowTypeAllowed(:,3)>numCustomers,5);

    %% Cleanup: Remove Customer to Customer Edges

    for jj= 1:length(FlowEdge_flowTypeAllowed)
        if le(FlowEdge_flowTypeAllowed(jj,2), numCustomers) && le(FlowEdge_flowTypeAllowed(jj,3), numCustomers)
           FlowEdge_flowTypeAllowed(jj,5) = inf; 
        end
    end
    FlowEdge_flowTypeAllowed = FlowEdge_flowTypeAllowed(FlowEdge_flowTypeAllowed(:,5)<inf,:);
    
    ii= 1;
    while true
       if ii == length(distributionNetwork.FlowEdgeSet)
           break;
       elseif    isa(distributionNetwork.FlowEdgeSet(ii).sourceFlowNetwork, 'Customer') && isa(distributionNetwork.FlowEdgeSet(ii).targetFlowNetwork, 'Customer')
           distributionNetwork.FlowEdgeSet(ii) = [];
       else
           ii = ii + 1;
       end
    end 
    
    distributionNetwork.FlowEdge_flowTypeAllowed = FlowEdge_flowTypeAllowed;

    %% Display Generated Data
    %scatter([customerSet(:,2); depotList(:,2)], [customerSet(:,3); depotList(:,3)])
%     scatter(customerSet(:,2),customerSet(:,3))
%     hold on;
%     scatter(depotList(:,2),depotList(:,3), 'filled')
%     hold off;
    
    distributionNetwork.depotList = depotList;
    distributionNetwork.depotSet = depotSet;
    distributionNetwork.customerList = customerList;
    distributionNetwork.customerSet = customerSet;

    
    distributionNetwork.depotMapping = depotMapping;
    distributionNetwork.depotFixedCost = depotFixedCost;

end






