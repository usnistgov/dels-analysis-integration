function [distributionNetwork] = DistributionFlowNetworkGenerator(varargin)
% DistributionFlowNetworkGenerator generates a random 
% TO DO: Output a Distribution Network Instance that contains the
% flownetwork as a reference
addpath dels-analysis-integration\Classdefs\TFN

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
        customerSet(ii).grossCapacity = inf;
        customerSet(ii).flowFixedCost = 0;
        customerSet(ii).typeID = 'Customer';
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
        depotSet(ii).flowFixedCost = depotFixedCost;
        depotSet(ii).grossCapacity = depotGrossCapacity;
        depotSet(ii).name = strcat('Depot', num2str(ii));
        depotSet(ii).typeID = 'Depot';
        jj = jj+1;
    end

    flowNodeList = [customerList; depotList];
    distributionNetwork.flowNodeList = flowNodeList;
    distributionNetwork.flowNodeSet = {customerSet, depotSet};
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
                flowEdgeSet(gg) = FlowNetworkLink(flowEdgeList(gg,:));
                
                %Lookup the FlowNetwork with the source/target instanceID
                for kk = 1:length(distributionNetwork.flowNodeSet)
                    sourceFlowNetwork = findobj(distributionNetwork.flowNodeSet{kk}, 'instanceID', ii);
                    if isempty(sourceFlowNetwork) == 0
                        flowEdgeSet(gg).sourceFlowNetwork = sourceFlowNetwork;
                    end
                    
                    targetFlowNetwork = findobj(distributionNetwork.flowNodeSet{kk}, 'instanceID', jj);
                    if isempty(targetFlowNetwork) == 0
                        flowEdgeSet(gg).targetFlowNetwork = targetFlowNetwork;
                    end
                end
                
                gg=gg+1;
            end
        end
    end

    distributionNetwork.flowEdgeList = flowEdgeList;
    distributionNetwork.flowEdgeSet = flowEdgeSet;
   

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
                    newCommodity(kk).typeID = 'Commodity';
                    newCommodity(kk).name = strcat('Commodity_', num2str(kk));
                    newCommodity(kk).quantity = supply;
                    newCommodity(kk).producedByID = ii;
                    newCommodity(kk).producedBy = customerSet(ii);
                    newCommodity(kk).consumedByID = jj;
                    newCommodity(kk).consumedBy = customerSet(jj);
                    
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

    %% Generate flowTypeAllowed and flowUnitCost for each FlowEdge
    % FlowEdge_flowTypeAllowed: FlowEdgeID origin destination commodityKind flowUnitCost

    for ii = 1:length(distributionNetwork.flowEdgeSet)
       distributionNetwork.flowEdgeSet(ii).flowTypeAllowed = [1:length(distributionNetwork.commoditySet)];
       distributionNetwork.flowEdgeSet(ii).setEdgeWeight;
       distributionNetwork.flowEdgeSet(ii).flowUnitCost = distributionNetwork.flowEdgeSet(ii).weight.*ones(1,length(distributionNetwork.commoditySet));
       
       %For flows between depots: multiple flowUnitCost by intraDepotDiscount
       if isa(distributionNetwork.flowEdgeSet(ii).sourceFlowNetwork, 'Depot') && isa(distributionNetwork.flowEdgeSet(ii).targetFlowNetwork, 'Depot')
           distributionNetwork.flowEdgeSet(ii).flowUnitCost = intraDepotDiscount.*distributionNetwork.flowEdgeSet(ii).flowUnitCost;
       end
       
    end
    
    %% Cleanup: Remove Customer to Customer Edges
    ii= 1;
    while true
       if ii == length(distributionNetwork.flowEdgeSet)
           break;
       elseif    isa(distributionNetwork.flowEdgeSet(ii).sourceFlowNetwork, 'Customer') && isa(distributionNetwork.flowEdgeSet(ii).targetFlowNetwork, 'Customer')
           distributionNetwork.flowEdgeSet(ii) = [];
           distributionNetwork.flowEdgeList(ii,:) = [];
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

end






