addpath dels-analysis-integration\UseCases\DistributionNetwork
addpath dels-analysis-integration\ClassDefs\TFN
%% 0) Generate Random Instance of Distribution Network
rng default;
dn1 = DistributionFlowNetworkGenerator;

%% 1) Generate family of candidate solutions
% a) Map FlowNetwork 2 Optimization
    dn1.mapFlowNetwork2MCFNOPT;

% b) Solve MCFN and Generate Flow Network Set
    %GenerateFlowNetworkSet implements a leave one out heuristic to generate a
    %family of candidate MCFN solutions
    
    flowNetworkSet = GenerateFlowNetworkSet(dn1, dn1.depotList);

% c) map MCFN solution to Flow Network
    
    for ii = 1:length(flowNetworkSet)
       flowNetworkSet(ii).mapMCFNSolution2FlowNetwork; 
    end
    
    clear dn1 ii;
% TO DO: Make the MCFN optimization more robust: 
% There seems to be an issue when we take the flow network solution and then put it back into the 
% MCFNOPT. It should solve an MCFN opt where there's pretty much only one solution, which is the one we started with
% However, when all the input matrices are not sized for the complete commodity set, then you get mismatched 
% matrix input sizes. I think this points to a broader issue of the robustness of the MCFN optimization, it needs to be set up
% a really particular way. 
% Solution: Map the flow network to MCFN more robustly to accommodate flow edges that don't allow all flow kinds -- currently we would just say that 
% it has 0 flow rate of a commodity.

%TO DO: Refactor this section into a MCFNFactory class

%% 2) MAP Flow Network to Distribution System Model
load('flowNetworkSet.mat'); %checkpoint demo above    
    %Since we copied the original distribution network, it should be a simple recast
    %2/15/19 -- i don't know if we want to cover cases in this demo where we get a pure flow network
    %input to this stage. we won't know which flow nodes are supposed to be depots and which are supposed to be customers
    distributionNetworkSet = flowNetworkSet;

    for ii = 1:length(distributionNetworkSet)
        distributionNetworkSet(ii).mapFlowNetwork2DistributionNetwork;
    end

    clear flowNetworkSet ii;

%% 3) Build and Run Low-Fidelity Simulations

% a) Instantiate new Factory objects
flowNetworkFactorySet(length(distributionNetworkSet)) = SimEventsFactory;
for ii = 1:length(distributionNetworkSet)
    
    %b) Set the model where the factory will operate and model library that it 
    %   will clone analysis objects from
    flowNetworkFactorySet(ii).model = 'Distribution';
    flowNetworkFactorySet(ii).modelLibrary = 'Distribution_Library';
    flowNetworkFactorySet(ii).inputFlowNetwork = distributionNetworkSet(ii);
    
    %c) Instantiate and set builder helper classes for each kind of flow node
    builderSet = DepotSimEventsBuilder.empty(0);
    for jj = 1:length(distributionNetworkSet(ii).depotSet)
        builderSet(jj) = DepotSimEventsBuilder;
        builderSet(jj).analysisTypeID = 'Depot_probflow';
        builderSet(jj).echelon = 3;
        builderSet(jj).setSystemElement(distributionNetworkSet(ii).depotSet(jj));
    end
    flowNetworkFactorySet(ii).flowNodeBuilders{1} = builderSet;
    
    builderSet = CustomerSimEventsBuilder.empty(0);
    for jj = 1:length(distributionNetworkSet(ii).customerSet)
        builderSet(jj) = CustomerSimEventsBuilder;
        builderSet(jj).analysisTypeID = 'Customer_probflow';
        builderSet(jj).echelon = 1;
        builderSet(jj).setSystemElement(distributionNetworkSet(ii).customerSet(jj));
    end
    flowNetworkFactorySet(ii).flowNodeBuilders{2} = builderSet;
    
    builderSet = TransportationChannelSimEventsBuilder.empty(0);
    for jj = 1:length(distributionNetworkSet(ii).transportationChannelSet)
        builderSet(jj) = TransportationChannelSimEventsBuilder;
        builderSet(jj).analysisTypeID = 'TransportationChannel';
        builderSet(jj).echelon = 2;
        builderSet(jj).setSystemElement(distributionNetworkSet(ii).transportationChannelSet(jj));
    end
    flowNetworkFactorySet(ii).flowNodeBuilders{3} = builderSet;
    
    %d) Call Factory method to build the simulation
    flowNetworkFactorySet(ii).buildAnalysisModel;
    
    %e) Call GA to optimize Resources
    %TO DO: Transition GA opt to a distributionNetwork based interface
    %TO DO: Implement open source GA??
    %TO DO: Implement GA-opt Factory
    %distributionNetworkSet(ii).resourceSolution = MultiGA_Distribution(model, distributionNetworkSet(ii).customerNodeSet, distributionNetworkSet(ii).depotNodeSet, 1000*ones(length(distributionNetworkSet(ii).depotNodeSet),1), [], 'true');
    clear MultiGA_Distribution;
    strcat('complete: ', num2str(ii))
end
    clear builderSet ii jj ans;
%% 4) ReBuild Hi-Fidelity Simulation 

for ii = 1:length(flowNetworkFactorySet)
    for jj = 1:length(flowNetworkFactorySet(ii).flowNodeBuilders)
        if isa(flowNetworkFactorySet(ii).flowNodeBuilders{jj}, 'DepotSimEventsBuilder')
            for kk = 1:length(flowNetworkFactorySet(ii).flowNodeBuilders{jj})
                flowNetworkFactorySet(ii).flowNodeBuilders{jj}(kk).analysisTypeID = 'Depot';
            end
        elseif isa(flowNetworkFactorySet(ii).flowNodeBuilders{jj}, 'CustomerSimEventsBuilder')
            for ll = 1:length(flowNetworkFactorySet(ii).flowNodeBuilders{jj})
                flowNetworkFactorySet(ii).flowNodeBuilders{jj}(kk).analysisTypeID = 'Customer';
            end
        elseif isa(flowNetworkFactorySet(ii).flowNodeBuilders{jj}, 'TransportationChannelSimEventsBuilder')
            %do nothing
            %for ll = 1:length(factoryNetworkSet(ii).flowNodeBuilders{jj})
            %    factoryNetworkSet(ii).flowNodeBuilders{jj}(kk).analysisTypeID = 'TransportationChannel';
            %end
        end
    end
end 

clear ii jj kk;

%% 5) Build and Run High-Fidelity Simulations
for ii = 1:length(distributionNetworkSet)
    flowNetworkFactorySet(ii).buildAnalysisModel;

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
