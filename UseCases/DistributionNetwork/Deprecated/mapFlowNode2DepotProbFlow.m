function [ depotNodeSet, selectedDepotSet, FlowEdge_Solution ] = mapFlowNode2DepotProbFlow( FlowNodeSet, FlowEdge_Solution, depotMapping )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    % Isolate the Depots Selected by the Optimization
    %depotMapping = distributionNetworkSet(ii).depotMapping;
    [LIA, LOCB] = ismember(depotMapping, FlowEdge_Solution(:, 3:4), 'rows');
    selectedDepotSet = FlowEdge_Solution(LOCB(LIA), 3);
    FlowNodeSet = FlowNodeSet(ismember(FlowNodeSet(:,1), selectedDepotSet),:);
    clear LIA LOCB;
    

    for jj = 1:length(depotMapping(:,1))
        FlowEdge_Solution(FlowEdge_Solution(:,3) == depotMapping(jj,2),3) = depotMapping(jj,1);
    end
    
    numDepot = length(FlowNodeSet(:,1));
    depotNodeSet(numDepot) = Depot;
    for jj = 1:numDepot
        depotNodeSet(jj).ID = FlowNodeSet(jj,1);
        depotNodeSet(jj).Name = strcat('Depot_', num2str(FlowNodeSet(jj,1)));
        depotNodeSet(jj).Echelon = 3;
        depotNodeSet(jj).X = FlowNodeSet(jj,2);
        depotNodeSet(jj).Y = FlowNodeSet(jj,3);
        depotNodeSet(jj).Type = 'Depot_probflow';
        mappedFlowNode = depotMapping(depotMapping(:,1) == depotNodeSet(jj).ID,2);
        depotNodeSet(jj).routingProbability = FlowEdge_Solution(FlowEdge_Solution(:,3) == FlowNodeSet(jj,1) ...
                                                        & FlowEdge_Solution(:,4) ~= mappedFlowNode,8);
    end
    
    depotNodeSet = depotNodeSet(ismember([depotNodeSet.ID], selectedDepotSet));
end

