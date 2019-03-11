addpath(genpath('dels-analysis-integration\UseCases\ProcessNetwork'))
addpath dels-analysis-integration\ClassDefs\TFN
addpath dels-analysis-integration\ClassDefs\DELS
addpath dels-analysis-integration\AnalysisLibraries\QueueingLib

%% 1) Make Random Process Network
% 1.0.0 Instance Parameters
clear
rng('default')
nProd = 5;
nProcess = 10;
lengthProcessPlan = 5; %all process plans are the same length for now
processPlanList = randi(nProcess, nProd, lengthProcessPlan);
productArrivalRate = randi([1, 10],nProd);
productArrivalRate = productArrivalRate(1:nProd,1);

serviceTime = randi([5, 25],nProcess)/100; %Make service time at process node k between 0.05 and 0.25 (between 4-20 parts/period)
serviceTime = serviceTime(1, :);

% 1.1) Instantiate Process objects & populate
productSet(nProd) = Product;
processSet(nProcess) = Process;

for ii = 1:length(processSet)
   processSet(ii).instanceID = ii;
   processSet(ii).typeID = 'Process';
   processSet(ii).name = strcat('Process_', num2str(ii));
   processSet(ii).averageServiceTime = serviceTime(ii);
   processSet(ii).storageCapacity = inf;
   %processSet(ii).canBeExecutedBy = ???
end

% 1.2) Instantiate Product objects & populate
for ii = 1:length(productSet)
    productSet(ii).instanceID = ii;
    productSet(ii).typeID = 'Product';
    productSet(ii).name = strcat('Product_', num2str(ii));
    productSet(ii).arrivalRate = productArrivalRate(ii);
end

% 1.3) Create process plan for each product
for ii = 1:length(productSet)
    % 1.3.1) Instantiate processPlan as Process object
    processPlan = Process;
    processPlan.instanceID = length(processSet) + ii;
    processPlan.typeID = 'MakeProduct';
    processPlan.name = strcat('MakeProduct_',num2str(ii));
    
    % 1.3.2) populate process plan with process steps
    processSteps = Process.empty(0);
    for jj = 1:length(processPlanList(ii,:))
       processSteps(end+1) = processSet(processPlanList(ii,jj));
    end
    processPlan.setProcessStep(processSteps);
    
    % 1.3.3) add product to each process step's commodity set/list
    for jj = 1:length(processPlan.processStep)
       for kk = 1:length(processPlan.processStep{jj})
           processStep = processPlan.processStep{jj}(kk);
           if ~any(processStep.commodityList == productSet(ii).instanceID)
               processStep.commoditySet{end+1} = productSet(ii);
               processStep.commodityList(end+1) = productSet(ii).instanceID;
               %processStep.flowAmount(end+1) = productSet(ii).arrivalRate;
           end
       end
    end
    clear processStep    
    
    % 1.3.4) create sequencing dependencies between process steps
    for jj = 1:length(processPlan.processStep)
       for kk = 1:length(processPlan.processStep{jj})-1
           seqDep = SequencingDependency;
           seqDep.instanceID = ii*kk;
           seqDep.typeID = 'SeqDep: Finish-Start';
           seqDep.sourceProcess = processPlan.processStep{jj}(kk);
           seqDep.sourceProcessID = processPlan.processStep{jj}(kk).instanceID;
           seqDep.targetProcess = processPlan.processStep{jj}(kk+1);
           seqDep.targetProcessID = processPlan.processStep{jj}(kk+1).instanceID;
           processPlan.sequenceDependencySet(end+1) = seqDep;
       end
    end
    
    % 1.3.5) set process plan objects to product
    productSet(ii).producedBy = processPlan;
    productSet(ii).processPlanList = processPlanList(ii,:);
    productSet(ii).route = processPlanList(ii,:);
    productSet(ii).producedByID = processPlan.instanceID;
end

% 1.4) Choose the number of "servers" at each process node by solving part of the QNM
% Since we want a feasible instance, we're going to jump ahead and solve the QNM and set the 
% traffic density/utilization at each process node to ~80%
    % 1.4.1) Map the process plan and product arrival rate to the probability transition matrix
    probabilityTransitionMatrix = mapProcessPlan2ProbMatrix(processPlanList, productArrivalRate);
    % 1.4.2) Map the process plan and product arrival rate to the arrival rate to each process center
    externalArrivalRate = mapProcessPlan2ArrivalRate(processPlanList, productArrivalRate);
    % 1.4.3) Use the queueing network toolbox to pick a minimum number of servers at each process node
    avgNoVisits = qnosvisits(probabilityTransitionMatrix, externalArrivalRate); 
    concurrentProcessingCapacity = ceil(sum(externalArrivalRate) * serviceTime .* avgNoVisits / 0.80);
    % 1.4.4) Set server count as 'concurrentProcessCapacity' to each process
    for ii = 1:length(processSet)
       if concurrentProcessingCapacity(ii) ~= 0
           %Ran into an edge case where one process was not selected.
        processSet(ii).concurrentProcessingCapacity = concurrentProcessingCapacity(ii);
       else
           processSet(ii).concurrentProcessingCapacity = 1;
       end
    end

clear nProcess nProd lengthProcessPlan ii jj kk processPlan seqDep concurrentProcessingCapacity 
clear avgNoVisits externalArrivalRate processPlanList productArrivalRate serviceTime probabilityTransitionMatrix

% OUTPUT: processSet, productSet

%% 2) Create Process Network Definition
% Product has Process Plan <=> Commodity has a flow route

addpath dels-analysis-integration\UseCases\ProcessNetwork\functions
    
    % 2.0.1 Instantiate new Processs Network
    % NOTE: Process (DELS) and Process Network (TFN) are different
        PN = ProcessNetwork;

    % 2.1) Recover aggregate data lists
    % An exercise to make sure we can recover the data we put in 
    % Can modify the functions below to operate on OO stored data
        processPlanList = zeros(length(productSet),length(productSet(1).processPlanList));
        productArrivalRate = zeros(length(productSet),1);
        externalArrivalRate = zeros(1,length(processSet));

        for ii = 1:length(productSet)
            processPlanList(ii,:) = productSet(ii).processPlanList;
            productArrivalRate(ii,:) = productSet(ii).arrivalRate;

            idx = productSet(ii).producedBy.processStep{1}(1).instanceID;
            qty = productSet(ii).arrivalRate;
            externalArrivalRate(idx) = externalArrivalRate(idx) + qty;
        end
        PN.externalArrivalRate = externalArrivalRate;
        PN.processPlanList = processPlanList;
        PN.productArrivalRate = productArrivalRate;
        clear idx qty;



    % 2.2) Merge individual process plans to one process network

        % 2.2.1) Aggregate all sequencing dependencies from each product's process plan
            % Add the processes to the process network's nodeSet;
            PN.setProcessNodeSet(processSet);
            % For each product, add the seq deps in its process plan to the new process network
            for ii =1:length(productSet)
                seqDep = productSet(ii).producedBy.sequenceDependencySet;
                PN.sequenceDependencySet(end+1:end+length(seqDep)) = seqDep;
            end
            PN.probabilityTransitionMatrix = mapProcessPlan2ProbMatrix(processPlanList, productArrivalRate);
        
        % 2.2.2) Create Flow Edge Set -- map seqDeps and arrivalRates to flowEdges & flowAmounts;
            flowEdgeSet = FlowNetworkLink.empty(0);
            flowEdgeList = zeros(length(processSet)^2,3);
            
            % For each product & its sequencing dependencies
            % Create a corresponding flow edge with the product in its flowTypeAllowed set
            % IF the flow edge already exists between two process nodes, just add the product to the flow type allowed
            for ii = 1:length(productSet)
                for jj = 1:length(productSet(ii).producedBy.sequenceDependencySet)
                    seqDep = productSet(ii).producedBy.sequenceDependencySet(jj);
                    % check is flow edge already exists
                    sameSource = (flowEdgeList(:,2) == seqDep.sourceProcessID);
                    sameTarget = (flowEdgeList(:,3) == seqDep.targetProcessID);
                    if ~any(sameSource & sameTarget)
                        if isempty(flowEdgeSet)
                        %If it's the first flow edge in the set, give it index 1;
                            idx = 1;
                        else
                            idx = flowEdgeSet(end).instanceID +1;
                        end
                        flowEdgeList(idx,:) = [idx, seqDep.sourceProcessID, seqDep.targetProcessID];
                        flowEdgeSet(end+1) = FlowNetworkLink;
                        flowEdgeSet(end).instanceID = idx;
                        flowEdgeSet(end).sourceFlowNetworkID = seqDep.sourceProcessID;
                        flowEdgeSet(end).targetFlowNetworkID = seqDep.targetProcessID;
                        flowEdgeSet(end).sourceFlowNetwork = seqDep.sourceProcess;
                        flowEdgeSet(end).targetFlowNetwork = seqDep.targetProcess;
                        flowEdgeSet(end).typeID = 'Job';
                    else
                    %If the flow edge exists, return it's index
                        idx = flowEdgeList(sameSource&sameTarget, 1);
                    end 
                    
                    %Find the flow edge and add the product to it's flowTypeAllowed set
                    flowEdge = findobj(flowEdgeSet, 'instanceID', idx);

                    if ~any(flowEdge.flowTypeAllowed == productSet(ii).instanceID)
                        flowEdge.flowTypeAllowed(end+1) = productSet(ii).instanceID;
                        %flowEdge.flowAmount(end+1) = productSet(ii).arrivalRate;
                    end
                end %for each seq dep in product's processplan
            end %for each product
            
            %NOTE: The flow edges need to be sorted to follow the transition probability matrix
            flowEdgeList = flowEdgeList(1:length(flowEdgeSet),:);
            [flowEdgeList, I] = sortrows(flowEdgeList, [2,3]);

            PN.flowEdgeList = flowEdgeList;
            PN.flowEdgeSet = flowEdgeSet(I);
        
        %2.2.3) aggregate all arrivals to the process network into one (new) arrival process node (a source node)
            [arrivalProcess, arrivalFlowEdgeSet] = mapArrivals2ArrivalProcessNode(PN.processNodeSet{1}, PN.flowEdgeSet, productArrivalRate, processPlanList);
        %Add arrivalProcess to process Set
            PN.setProcessNodeSet(arrivalProcess);
            PN.flowEdgeSet(end+1:end+length(arrivalFlowEdgeSet))= arrivalFlowEdgeSet;
            for ii = 1:length(arrivalFlowEdgeSet)
                PN.flowEdgeList(end+1,:) = [arrivalFlowEdgeSet(ii).instanceID, arrivalFlowEdgeSet(ii).sourceFlowNetworkID, arrivalFlowEdgeSet(ii).targetFlowNetworkID];
            end
        
        %2.2.4) aggregate all departures from the process network into one (new) departure process node (a sink node)
        [departureProcess, departureFlowEdgeSet] = mapDepartures2DepartureProcessNode(PN.processNodeSet{1}, PN.flowEdgeSet, productArrivalRate, processPlanList);
        %Add departureProcessNode to ProcessNode Set;
            PN.setProcessNodeSet(departureProcess);
            PN.flowEdgeSet(end+1:end+length(departureFlowEdgeSet))= departureFlowEdgeSet;
            for ii = 1:length(departureFlowEdgeSet)
                PN.flowEdgeList(end+1,:) = [departureFlowEdgeSet(ii).instanceID, departureFlowEdgeSet(ii).sourceFlowNetworkID, departureFlowEdgeSet(ii).targetFlowNetworkID];
            end
        
        %2.2.5) Build probabilistic routing
        P = PN.probabilityTransitionMatrix;
        for ii = 1:(length(PN.processNodeSet{1})-2) %The last two nodes are arrival/departure process
           routingProbability = P(ii,(P(ii,:)>0));
           PN.processNodeSet{1}(ii).routingProbability = [routingProbability, 1-sum(routingProbability)];
           %assert(length(PN.processNodeSet{1}(ii).routingProbability) == length(PN.processNodeSet{1}(ii).outFlowEdgeSet), 'Routing Probability doesnt match out flow edge set')
        end
        
    clear arrivalProcess arrivalFlowEdgeSet departureProcess departureFlowEdgeSet
        

    %2.5) With all new process steps and flow edges, create necessary connectors/references 

    for jj = 1:length(PN.processNodeSet)
        for ii = 1:length(PN.processNodeSet{jj})
            processNode = PN.processNodeSet{jj}(ii);
            processNode.addEdge(PN.flowEdgeSet); 

            for kk = 1:length(processNode.inFlowEdgeSet)
                processNode.inFlowEdgeSet(kk).targetFlowNetwork = processNode;
            end

            for kk = 1:length(processNode.outFlowEdgeSet)
                processNode.outFlowEdgeSet(kk).sourceFlowNetwork = processNode;
            end

           processNode.parentProcessNetwork = PN;
        end
    end

    clear processNode flowEdgeList flowEdgeSet flowEdge idx sameSource sameTarget seqDep ii jj kk
        
        
% 2.3) Solve the Queuing Network Problem 
    %2.3.1) Extract service time and server count from process definition.
    concurrentProcessingCapacity = zeros(1, length(processSet));
    serviceTime = zeros(1, length(processSet));
    for ii = 1:length(processSet)
        concurrentProcessingCapacity(ii) = processSet(ii).concurrentProcessingCapacity;
        serviceTime(ii) = processSet(ii).averageServiceTime;
    end

    % 2.3.2) Solve.
    try
        avgNoVisits = qnosvisits(PN.probabilityTransitionMatrix, externalArrivalRate); 
        [utilization, avgResponseTime, avgNoRequests, throughput] = qnopen(sum(externalArrivalRate), serviceTime, avgNoVisits, concurrentProcessingCapacity);
    catch err
        rethrow(err)
    end
    
    % 2.4) Flow Amount from Process i to Process j
    %flowAmount = PN.probabilityTransitionMatrix .* throughput';
    
    PN.utilization = utilization;
    PN.throughput = throughput;
    PN.averageWaitingTime = avgResponseTime;

clear ii I P externalArrivalRate seqDep concurrentProcessingCapacity processPlanList productArrivalRate routingProbability processSteps  
    
%Future work -- Implement multi-class queueing networks. The processing time at each process step/node
% can be different for each kind of commodity.

%% 3) Visualize the Process Network
PN.plot;
%% 4) Create ProcessNetwork Representation
addpath dels-analysis-integration\ClassDefs\FactoryClasses
addpath dels-analysis-integration\ClassDefs\BuilderClasses
%PN.matrix2Network;

simFac = SimEventsFactory;
simFac.model = 'ProcessNetworkSimulation';
simFac.modelLibrary = 'DELS_Library';

simFac.inputFlowNetwork = PN;

    builderSet = ProcessNetworkSimEventsBuilder.empty(0);
    for ii = 1:length(PN.processNodeSet)
        for jj = 1:length(PN.processNodeSet{ii})
            builderSet(end+1) = ProcessNetworkSimEventsBuilder;
            builderSet(end).analysisTypeID = PN.processNodeSet{ii}(jj).typeID;
            builderSet(end).routingTypeID = 'probFlow';
            if strcmp(builderSet(end).analysisTypeID, 'ArrivalProcess')
                builderSet(end).echelon = 1;
            elseif strcmp(builderSet(end).analysisTypeID,'DepartureProcess')
                builderSet(end).echelon = 10;
            else
                builderSet(end).echelon = mod(jj,10)+1;
            end
            builderSet(end).setSystemElement(PN.processNodeSet{ii}(jj));
        end
    end
simFac.flowNodeBuilders{1} = builderSet;
simFac.buildAnalysisModel;

%% 5) Validate Simulation Against QNM
open(simFac.model);
utilDirector = MetricDirector;
try
    utilDirector.ConstructMetric(simFac.flowNodeBuilders{1}, 'Utilization');
end
warning ('off','all');
simResults = sim(simFac.model, 'StopTime', '2000','SaveOutput','on');simResults
warning ('on','all');

assert(abs(simResults.Utilization_Process_1.signals.values(end) - utilization(1))< 0.01)