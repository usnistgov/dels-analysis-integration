%% 0) Generate Random Instance of Distribution Network
tic;
rng default;
dn1 = DistributionFlowNetworkGenerator;

%% 1) Generate family of candidate solutions
% a) Map FlowNetwork 2 Optimization
    dn1.mapFlowNetwork2MCFNOPT;
    toc

% b) Solve MCFN and Generate Flow Network Set
    %GenerateFlowNetworkSet implements a leave one out heuristic to generate a
    %family of candidate MCFN solutions
    
    flowNetworkSet = GenerateFlowNetworkSet(dn1, dn1.depotList);

% c) map MCFN solution to Flow Network
    %TO DO: concatentate dn1 and flownetwork set somehow
    % currently having casting issues.
    
    for ii = 1:length(flowNetworkSet)
       flowNetworkSet(ii).mapMCFNSolution2FlowNetwork; 
    end
    
    clear dn1;
% TO DO: Make the MCFN optimization more robust: 
% There seems to be an issue when we take the flow network solution and then put it back into the 
% MCFNOPT. It should solve an MCFN opt where there's pretty much only one solution, which is the one we started with
% However, when all the input matrices are not sized for the complete commodity set, then you get mismatched 
% matrix input sizes. I think this points to a broader issue of the robustness of the MCFN optimization, it needs to be set up
% a really particular way. 
% Solution: Map the flow network to MCFN more robustly to accommodate flow edges that don't allow all flow kinds -- currently we would just say that 
% it has 0 flow rate of a commodity.

%% 2) MAP Flow Network to Distribution System Model
    
    %Since we copied the original distribution network, it should be a simple recast
    %2/15/19 -- i don't know if we want to cover cases in this demo where we get a pure flow network
    %input to this stage. we won't know which flow nodes are supposed to be depots and which are supposed to be customers
    distributionNetworkSet = flowNetworkSet;

    for ii = 1:length(distributionNetworkSet)
        distributionNetworkSet(ii).mapFlowNetwork2DistributionNetwork;
    end

    clear flowNetworkSet ii;

%% 3) Build and Run Low-Fidelity Simulations
flowNetworkFactorySet(length(distributionNetworkSet)) = FlowNetworkFactory;
for ii = 1:length(distributionNetworkSet)
    % Build & Run Simulations

    flowNetworkFactorySet(ii).Model = 'Distribution';
    flowNetworkFactorySet(ii).modelLibrary = 'Distribution_Library';
    
    %Instantiate and set builder helper classes for each flow network
    depotBuilder = IDepotBuilder;
    for jj = 1:length(distributionNetworkSet(ii).depotNodeSet)
        distributionNetworkSet(ii).depotNodeSet(jj).setBuilder(depotBuilder);
    end
    
    flowNetworkFactorySet(ii).addFlowNode(distributionNetworkSet(ii).transportationChannelNodeSet)
    flowNetworkFactorySet(ii).addFlowNode(distributionNetworkSet(ii).depotNodeSet)
    flowNetworkFactorySet(ii).addFlowNode(distributionNetworkSet(ii).customerNodeSet)
    flowNetworkFactorySet(ii).addFlowEdge(distributionNetworkSet(ii).edgeSet)
    flowNetworkFactorySet(ii).buildSimulation;
    
    %TO DO: Transition GA opt to a distributionNetwork based interface
    %distributionNetworkSet(ii).resourceSolution = MultiGA_Distribution(model, distributionNetworkSet(ii).customerNodeSet, distributionNetworkSet(ii).depotNodeSet, 1000*ones(length(distributionNetworkSet(ii).depotNodeSet),1), [], 'true');
    clear MultiGA_Distribution;
    strcat('complete: ', num2str(ii))
end
    clear depotBuilder ii jj;
%% 4) ReBuild Hi-Fidelity Simulation 
for ii = 1:length(distributionNetworkSet)
       
    for jj = 1:length(distributionNetworkSet(ii).customerNodeSet)
        distributionNetworkSet(ii).customerNodeSet(jj).typeID = 'Customer'; %Change Resolution from Probabilistic to Complete
        distributionNetworkSet(ii).customerNodeSet(jj).setCommoditySet(distributionNetworkSet(ii).commoditySet);
    end
    
    for jj = 1:length(distributionNetworkSet(ii).depotNodeSet)
        distributionNetworkSet(ii).depotNodeSet(jj).typeID = 'Depot';
    end
    
end 

%% 5) Build and Run High-Fidelity Simulations
for ii = 1:length(distributionNetworkSet)
    flowNetworkFactorySet(ii).buildSimulation;

    %distributionNetworkSet(ii).policySolution = Distribution_Pareto(model, distributionNetworkSet(ii).customerNodeSet, distributionNetworkSet(ii).depotNodeSet, distributionNetworkSet(ii).transportationNodeSet, distributionNetworkSet(ii).resourceSolution, 1000*ones(length(distributionNetworkSet(ii).resourceSolution(1,:)),1));
    %save GenerateFamily.mat;
    strcat('complete: ', num2str(ii))
end

%% 6) Pareto Analysis

TravelDist = [reshape(distributionNetworkSet(1).policySolution(:,:,1), [],1); reshape(distributionNetworkSet(2).policySolution(:,:,1), [],1); reshape(distributionNetworkSet(3).policySolution(:,:,1), [],1); reshape(distributionNetworkSet(4).policySolution(:,:,1), [],1); reshape(distributionNetworkSet(5).policySolution(:,:,1), [],1)];
ResourceInvestment =  [reshape(distributionNetworkSet(1).policySolution(:,:,3), [],1); reshape(distributionNetworkSet(2).policySolution(:,:,3), [],1); reshape(distributionNetworkSet(3).policySolution(:,:,3), [],1); reshape(distributionNetworkSet(4).policySolution(:,:,3), [],1); reshape(distributionNetworkSet(5).policySolution(:,:,3), [],1)];
ServiceLevel =  1.-[reshape(distributionNetworkSet(1).policySolution(:,:,2), [],1); reshape(distributionNetworkSet(2).policySolution(:,:,2), [],1); reshape(distributionNetworkSet(3).policySolution(:,:,2), [],1); reshape(distributionNetworkSet(4).policySolution(:,:,2), [],1); reshape(distributionNetworkSet(5).policySolution(:,:,2), [],1)];
paretoI = paretoGroup([TravelDist, ResourceInvestment, ServiceLevel]);

scatter3( TravelDist(paretoI), ResourceInvestment(paretoI), 1.-ServiceLevel(paretoI));

warning('on','all');
