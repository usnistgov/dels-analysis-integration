%% Build & Run Simulations
model = 'Distribution_v3';
open(model);
warning('off','all');
%MCGA_solution = 4*ones(1,5);

for k = 1:length(MCFN_solution(1,:))
    delete_model(model);
    
    solution = MCFN_solution(:,k);
    solution=round(solution);
    FlowEdge_solution = [solution(length(FlowEdge_CommoditySet)+1: end), FlowEdgeSet];
    transportation_channel_sol = FlowEdge_solution(FlowEdge_solution(:,1) ==1,:);
    commodity_set = buildCommoditySet(FlowEdge_CommoditySet,FlowNode_CommoditySet,solution);
    
    [df1, cf1, tf1, ef1] = buildSimulation(model, depotSet, customerSet, transportation_channel_sol, commodity_set);
    se_randomizeseeds(model, 'Mode', 'All', 'Verbose', 'off');
    %simOut = sim(model, 'StopTime', '1000', 'SaveOutput', 'on');
    save_system(model);
    
    solution = MultiGA_Distribution(model, cf1.NodeSet, df1.NodeSet, 1000*ones(length(df1.NodeSet),1), unique(MCGA_solution(:, 1:length(df1.NodeSet)), 'rows'), 'true');
    MCGA_solution = [MCGA_solution; solution, 4*ones(length(solution(:,1)),5-length(solution(1,:)))];
    delete_model(model);
    strcat('complete: ', num2str(k))
end

warning('on','all');