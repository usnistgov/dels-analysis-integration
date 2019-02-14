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
        customerSet(ii).name = strcat('Customer', num2str(ii));
        customerSet(ii).capacity = inf;
        customerSet(ii).fixedCost = 0;
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
        depotSet(ii).name = strcat('Depot', num2str(ii));
        jj = jj+1;
    end

    flowNodeList = [customerList; depotList];
    distributionNetwork.FlowNodeList = flowNodeList;
    distributionNetwork.FlowNodeSet = {customerSet, depotSet};
    numNodes = length(flowNodeList);
    
    %% Generate FlowEdge Set
    % FlowEdge = instanceID sourceFlowNode targetFlowNode grossCapacity flowFixedCost
    numArc = numNodes*(numNodes-1);
    flowEdgeList = zeros(numArc, 5);
    gg = 1;
    for ii = 1:numNodes
        for jj = 1:numNodes
            if eq(ii,jj)==0
                flowEdgeList(gg,:) = [gg, flowNodeList(ii,1), flowNodeList(jj,1), 1e7, 0.01];
                flowEdgeSet(gg) = FlowEdge(flowEdgeList(gg,:));
                
                %Lookup the FlowNetwork with the source/target instanceID
                for kk = 1:length(distributionNetwork.FlowNodeSet)
                    sourceFlowNetwork = findobj(distributionNetwork.FlowNodeSet{kk}, 'instanceID', ii);
                    if isempty(sourceFlowNetwork) == 0
                        flowEdgeSet(gg).sourceFlowNetwork = sourceFlowNetwork;
                    end
                    
                    targetFlowNetwork = findobj(distributionNetwork.FlowNodeSet{kk}, 'instanceID', jj);
                    if isempty(targetFlowNetwork) == 0
                        flowEdgeSet(gg).targetFlowNetwork = targetFlowNetwork;
                    end
                end
                
                gg=gg+1;
            end
        end
    end

    distributionNetwork.FlowEdgeList = flowEdgeList;
    distributionNetwork.FlowEdgeSet = flowEdgeSet;
   

    %% Generate Production/Consumption Data
    %Customer < FlowNetwork -- produces, consumes, productionRate, consumptionRate
    kk = 1;
    for ii = 1:numCustomers
        for jj = 1:numCustomers
            if eq(ii,jj)==0
                if rand(1) < commoditydensity
                    supply = randi(500);
                    
                    newCommodity(kk) = Commodity;
                    newCommodity(kk).instanceID = kk;
                    newCommodity(kk).Quantity = supply;
                    newCommodity(kk).OriginID = ii;
                    newCommodity(kk).Origin = customerSet(ii);
                    newCommodity(kk).DestinationID = jj;
                    newCommodity(kk).Destination = customerSet(jj);
                    
                    customerSet(ii).produces(end+1) = newCommodity(kk);
                    customerSet(ii).productionRate(end+1) = supply;
                    customerSet(jj).consumes(end+1) = newCommodity(kk);
                    customerSet(jj).consumptionRate(end+1) = supply;

                    kk = kk+1;
                end
            end
        end
    end
    
    distributionNetwork.commoditySet = newCommodity;
    distributionNetwork.numCommodity = kk-1;

    %% Generate flowTypeAllowed and flowUnitCost for each FlowEdge
    % FlowEdge_flowTypeAllowed: FlowEdgeID origin destination commodityKind flowUnitCost

    for ii = 1:length(distributionNetwork.FlowEdgeSet)
       distributionNetwork.FlowEdgeSet(ii).flowTypeAllowed = [1:length(distributionNetwork.commoditySet)];
       distributionNetwork.FlowEdgeSet(ii).setEdgeWeight;
       distributionNetwork.FlowEdgeSet(ii).flowUnitCost = distributionNetwork.FlowEdgeSet(ii).Weight.*ones(1,length(distributionNetwork.commoditySet));
       
       %For flows between depots: multiple flowUnitCost by intraDepotDiscount
       if isa(distributionNetwork.FlowEdgeSet(ii).sourceFlowNetwork, 'Depot') && isa(distributionNetwork.FlowEdgeSet(ii).targetFlowNetwork, 'Depot')
           distributionNetwork.FlowEdgeSet(ii).flowUnitCost = intraDepotDiscount.*distributionNetwork.FlowEdgeSet(ii).flowUnitCost;
       end
       
    end
    
    %% Cleanup: Remove Customer to Customer Edges
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
    distributionNetwork.depotFixedCost = depotFixedCost;

end






