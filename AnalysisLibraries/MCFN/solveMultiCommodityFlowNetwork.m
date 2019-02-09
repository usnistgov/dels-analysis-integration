function solveMultiCommodityFlowNetwork(FlowNetwork)
    assert(isa(FlowNetwork, 'FlowNetwork') == 1, 'Input must be a Flow Network')
    import AnalysisLibraries/MCFN.*
    
    %MCFNsolution = MultiCommodityFlowNetwork(FlowNetwork.FlowEdge_flowTypeAllowed(:, 2:end), FlowNetwork.FlowEdgeSet(:,2:end), FlowNetwork.FlowNode_ConsumptionProduction);
    MCFNsolution = MultiCommodityFlowNetwork(FlowNetwork.FlowEdge_flowTypeAllowed(:, 2:end), FlowNetwork.FlowEdgeList(:,2:end), FlowNetwork.FlowNode_ConsumptionProduction);
    %MCFNsolution := [flowVariables; fixedVariables]
    %flowVariables := length(FN.FlowEdge_flowTypeAllowed), ...
        %amount of commodity k flowing on edge e
    %fixedVariables := length(FN.FlowEdgeSet), ...
        %1 if edge e is used.
    MCFNsolution = round(MCFNsolution); %NOTE: distribution network requires it 4/25/16
    FlowNetwork.FlowEdge_Solution = [MCFNsolution(length(FlowNetwork.FlowEdge_flowTypeAllowed)+1 : end), FlowNetwork.FlowEdgeList]; %Should reduce to only selected edges
    %TO DO: Get Ride of FlowEdge_Solution and just push solution
    %into flow network definition.
    FlowNetwork.commodityFlow_Solution = [FlowNetwork.FlowEdge_flowTypeAllowed(MCFNsolution(1:length(FlowNetwork.FlowEdge_flowTypeAllowed))>0,1:5),...
        MCFNsolution(MCFNsolution(1:length(FlowNetwork.FlowEdge_flowTypeAllowed))>0)];
end