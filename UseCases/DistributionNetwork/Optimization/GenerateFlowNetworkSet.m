function [ flowNetworkSet ] = GenerateFlowNetworkSet( inputFlowNetwork, targetFlowNodeSet)
%GenerateFlowNetworkSet implements a leave one out heuristic
%Uses flowNetwork as template MCFN, and then
%resolves MCFN while leaving out each node from flowNodeSet
%targetFlowNodes are the nodes that can be selected via facility location
%problem

    %% Solve MCFN

    if isempty(inputFlowNetwork.FlowEdge_Solution)
        solveMultiCommodityFlowNetwork(inputFlowNetwork);
    end

    %% Replicate FlowNetwork and Solve MCFN For Each

    %NOTE (4/25/16): Still can't figure out a reusable way to figure out
    %target flow nodes for 'leave one out'
    %Returns the instanceID of the flowEdge of the selected depot
    SelectedDepot_EdgeIndex = find(inputFlowNetwork.FlowEdge_Solution(:,1) == 1 & ismember(inputFlowNetwork.FlowEdge_Solution(:,3), targetFlowNodeSet) ==1);
    
    %Add an index indicating that the first go through didn't have any left out
    SelectedDepot_EdgeIndex = [inf, SelectedDepot_EdgeIndex];
    %For each Depot selected during the MCFN optimization: 
    %Use the FlowNetwork Constructor to create deep copies of the original
    %flow network
    flowNetworkSet(length(SelectedDepot_EdgeIndex)) = FlowNetwork(inputFlowNetwork);

    % For each Depot selected during the MCFN optimization: 
    % Set the value of the cost of using that depot to inf and resolve
    
    for ii = 2:length(SelectedDepot_EdgeIndex)
        flowNodeFixedCost = flowNetworkSet(ii).FlowEdgeList(SelectedDepot_EdgeIndex(ii), 5);
        % 2/24/18 -- Matlab INTLINPROG doesn't accept inf (too big), change to big M
        flowNetworkSet(ii).FlowEdgeList(SelectedDepot_EdgeIndex(ii), 5) = flowNodeFixedCost*10e10;
        solveMultiCommodityFlowNetwork(flowNetworkSet(ii));
        flowNetworkSet(ii).FlowEdgeList(SelectedDepot_EdgeIndex(ii), 5) = flowNodeFixedCost;
    end
end

