function solveMultiCommodityFlowNetwork(FlowNetwork)
    assert(isa(FlowNetwork, 'FlowNetwork') == 1, 'Input must be a Flow Network')
    addpath dels-analysis-integration\AnalysisLibraries\MCFN
    
    MCFNsolution = MultiCommodityFlowNetwork(FlowNetwork.flowEdge_flowTypeAllowed(:, 2:end), FlowNetwork.flowEdgeList(:,2:end), FlowNetwork.flowNode_ConsumptionProduction);
    MCFNsolution = round(MCFNsolution); %NOTE: distribution network requires it 4/25/16
    FlowNetwork.flowEdge_Solution = [MCFNsolution(length(FlowNetwork.flowEdge_flowTypeAllowed)+1 : end), FlowNetwork.flowEdgeList]; %Should reduce to only selected edges
    %TO DO: Get Rid of FlowEdge_Solution and just push solution
    %into flow network definition.
    FlowNetwork.commodityFlow_Solution = [FlowNetwork.flowEdge_flowTypeAllowed(MCFNsolution(1:length(FlowNetwork.flowEdge_flowTypeAllowed))>0,1:5),...
        MCFNsolution(MCFNsolution(1:length(FlowNetwork.flowEdge_flowTypeAllowed))>0)];
end