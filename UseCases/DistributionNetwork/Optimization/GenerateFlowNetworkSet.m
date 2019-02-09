function [ flowNetworkSet ] = GenerateFlowNetworkSet( inputFlowNetwork, targetFlowNodeSet, flowNodeFixedCost )
%GenerateFlowNetworkSet implements a leave one out heuristic
%Uses flowNetwork as template MCFN, and then
%resolves MCFN while leaving out each node from flowNodeSet

    if isempty(inputFlowNetwork.FlowEdge_Solution)
        solveMultiCommodityFlowNetwork(inputFlowNetwork);
    end

    %% Replicate FlowNetwork and Solve MCFN For Each

    %NOTE (4/25/16): Still can't figure out a reusable way to figure out
    %target flow nodes for 'leave one out'
    SelectedDepotSetIndex = find(inputFlowNetwork.FlowEdge_Solution(:,1) == 1 & ismember(inputFlowNetwork.FlowEdge_Solution(:,3), targetFlowNodeSet) ==1);

    %For each Depot selected during the MCFN optimization: 
    %Use the FlowNetwork Constructor to create deep copies of the original
    %flow network
    flowNetworkSet(length(SelectedDepotSetIndex)) = FlowNetwork(inputFlowNetwork);

    % For each Depot selected during the MCFN optimization: 
    % Set the value of the cost of using that depot to inf and resolve
    for ii = 1:length(SelectedDepotSetIndex)
        %flowNetworkSet(1) is the original
        flowNetworkSet(ii+1) = FlowNetwork(inputFlowNetwork);
        flowNetworkSet(ii+1).FlowEdgeSet(SelectedDepotSetIndex(:), 5) = flowNodeFixedCost;
        % 2/24/18 -- Matlab INTLINPROG doesn't accept inf (too big), change to big M
        %flowNetworkSet(ii+1).FlowEdgeSet(SelectedDepotSetIndex(ii), 5) = inf;
        flowNetworkSet(ii+1).FlowEdgeSet(SelectedDepotSetIndex(ii), 5) = flowNodeFixedCost*10e10;
        solveMultiCommodityFlowNetwork(flowNetworkSet(ii+1));
        %fprintf('Complete %d of %d', ii+1, length(SelectedDepotSetIndex)+1);
    end
end

