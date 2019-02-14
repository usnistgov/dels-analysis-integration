function [ flowNetworkSet ] = GenerateFlowNetworkSet( inputFlowNetwork, targetFlowNodeSet)
%GenerateFlowNetworkSet implements a leave one out heuristic
%Uses flowNetwork as template MCFN, and then resolves MCFN while leaving out each node from flowNodeSet
%targetFlowNodes are the nodes that can be selected via facility location problem
%RETURN: flowNetworkSet(1) == inputFlowNetwork

    %% Solve MCFN

    if isempty(inputFlowNetwork.FlowEdge_Solution)
        solveMultiCommodityFlowNetwork(inputFlowNetwork);
    end

    %% Replicate FlowNetwork and Solve MCFN For Each
    %'Leave one out' needs to target a capacitated flow node (targetFlowNodeSet)
    % Check if it's in the target subset, and if it's an edge created by
    % splitting capacitated nodes, i.e. in the nodeMapping list
    % RETURN: index of selected depot(s)' flowEdge in flowEdgeList
    
    inNodeMapping = ismember(inputFlowNetwork.FlowEdge_Solution(:, 3:4), inputFlowNetwork.nodeMapping, 'rows');
    inTargetNodeSet = ismember(inputFlowNetwork.FlowEdge_Solution(:,3), targetFlowNodeSet);
    isSolution = inputFlowNetwork.FlowEdge_Solution(:,1);
    
    SelectedDepot_EdgeIndex = find(inNodeMapping & inTargetNodeSet & isSolution);
    
    %For each Depot selected during the MCFN optimization: 
    %Use the FlowNetwork Constructor to create deep copies of the original flow network
    flowNetworkSet(length(SelectedDepot_EdgeIndex)) = FlowNetwork(inputFlowNetwork);

    % For each Depot selected during the MCFN optimization: 
    % Set the value of the cost of using that depot to inf and re-solve
    
    for ii = 1:length(SelectedDepot_EdgeIndex)
        flowNodeFixedCost = flowNetworkSet(ii).FlowEdgeList(SelectedDepot_EdgeIndex(ii), 5);
        % 2/24/18 -- Matlab INTLINPROG doesn't accept inf (too big), change to big M
        flowNetworkSet(ii).FlowEdgeList(SelectedDepot_EdgeIndex(ii), 5) = flowNodeFixedCost*10e10;
        solveMultiCommodityFlowNetwork(flowNetworkSet(ii));
        flowNetworkSet(ii).FlowEdgeList(SelectedDepot_EdgeIndex(ii), 5) = flowNodeFixedCost;
    end

end

