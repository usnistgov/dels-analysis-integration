
function [ flowNetworkSet ] = GenerateFlowNetworkSet( inputFlowNetwork, targetFlowNodeSet)
%GenerateFlowNetworkSet implements a leave one out heuristic
%Uses flowNetwork as template MCFN, and then resolves MCFN while leaving out each node from flowNodeSet
%targetFlowNodes are the nodes that can be selected via facility location problem
%RETURN: flowNetworkSet(1) == inputFlowNetwork
addpath dels-analysis-integration\AnalysisLibraries\MCFN
    %% Solve MCFN

    if isempty(inputFlowNetwork.flowEdge_Solution)
        solveMultiCommodityFlowNetwork(inputFlowNetwork);
    end

    %% Replicate FlowNetwork and Solve MCFN For Each
    %'Leave one out' needs to target a capacitated flow node (targetFlowNodeSet)
    % Check if it's in the target subset, and if it's an edge created by
    % splitting capacitated nodes, i.e. in the nodeMapping list
    % RETURN: index of selected depot(s)' flowEdge in flowEdgeList
    
    inNodeMapping = ismember(inputFlowNetwork.flowEdge_Solution(:, 3:4), inputFlowNetwork.nodeMapping, 'rows');
    inTargetNodeSet = ismember(inputFlowNetwork.flowEdge_Solution(:,3), targetFlowNodeSet);
    isSolution = inputFlowNetwork.flowEdge_Solution(:,1);
    
    SelectedDepot_EdgeIndex = find(inNodeMapping & inTargetNodeSet & isSolution);
    
    %For each Depot selected during the MCFN optimization: 
    %Create deep copies of the original flow network using save/load
    %TO DO 2/15/19 -- implement better deep copy
    save(strcat(fileparts(which('GenerateFlowNetworkSet')),'/inputFlowNetwork'), 'inputFlowNetwork');
    for ii = 1:length(SelectedDepot_EdgeIndex)
         copyOfInputFlowNetworkAsStruct = load(strcat(fileparts('GenerateFlowNetworkSet'),'inputFlowNetwork'));%loaded as struct
         flowNetworkSet(ii) = copyOfInputFlowNetworkAsStruct.inputFlowNetwork;
         flowNetworkSet(ii).instanceID = ii+1;
    end
    delete(strcat(fileparts(which('GenerateFlowNetworkSet')),'/inputFlowNetwork.mat'))

    % For each Depot selected during the MCFN optimization: 
    % Set the value of the cost of using that depot to inf and re-solve
    
    for ii = 1:length(SelectedDepot_EdgeIndex)
        flowNodeFixedCost = flowNetworkSet(ii).flowEdgeList(SelectedDepot_EdgeIndex(ii), 5);
        % 2/24/18 -- Matlab INTLINPROG doesn't accept inf (too big), change to big M
        flowNetworkSet(ii).flowEdgeList(SelectedDepot_EdgeIndex(ii), 5) = flowNodeFixedCost*10e10;
        solveMultiCommodityFlowNetwork(flowNetworkSet(ii));
        flowNetworkSet(ii).flowEdgeList(SelectedDepot_EdgeIndex(ii), 5) = flowNodeFixedCost;
    end
    flowNetworkSet = [inputFlowNetwork, flowNetworkSet];
end

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

