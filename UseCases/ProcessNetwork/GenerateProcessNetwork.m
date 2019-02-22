
%% Make Random Process Network
%Instance Parameters
rng('default')
nProd = 15;
nProcess = 50;
lengthProcessPlan = 20;

PN = Process;

PN.processPlanSet = randi(nProcess, nProd, lengthProcessPlan);
productArrivalRate = randi([1, 10],nProd);
PN.productArrivalRate = productArrivalRate(1:nProd,1);
clear productArrivalRate

%Map the process plan and product arrival rate to the probability
%transition matrix
PN.probabilityTransitionMatrix = mapProcessPlan2ProbMatrix(PN.processPlanSet, PN.productArrivalRate);

%Map the process plan and product arrival rate to the arrival rate to each
%process center
PN.processArrivalRate = mapProcessPlan2ArrivalRate(PN.processPlanSet, PN.productArrivalRate);

%Make service time at process node k between 0.05 and 0.25
serviceTime = randi([5, 25],nProcess)/100;
PN.serviceTime = serviceTime(1, :);
clear serviceTime

addpath dels-analysis-integration\AnalysisLibraries\QueueingLib
try
    avgNoVisits = qnosvisits(PN.probabilityTransitionMatrix, PN.processArrivalRate);   
    %Set Number of machines at each workstation
    PN.ServerCount = ceil(sum(PN.processArrivalRate) * PN.serviceTime .* avgNoVisits / 0.95);
    [Util, avgResponseTime, avgNoRequests, Throughput] = qnopen(sum(PN.processArrivalRate), PN.serviceTime, avgNoVisits, PN.ServerCount);
catch err
    rethrow(err)
end

%% Visualize the Process Network
PN.plot;
%% Create ProcessNetwork Representation
clear NF PF EF
PN.matrix2Network;

FNF = SimEventsFactory;
FNF.model = 'ProcessNetworkSimulation';
FNF.modelLibrary = 'DELS_Library';

FNF.inputFlowNetwork = PN;

    builderSet = ProcessNetworkSimEventsBuilder.empty(0);
    for jj = 1:length(PN.ProcessStep)
        builderSet(jj) = ProcessNetworkSimEventsBuilder;
        builderSet(jj).analysisTypeID = PN.ProcessStep(jj).typeID;
        if strcmp(builderSet(jj).analysisTypeID, 'ArrivalProcess')
            builderSet(jj).echelon = 1;
        elseif strcmp(builderSet(jj).analysisTypeID,'DepartureProcess')
            builderSet(jj).echelon = 10;
        else
            builderSet(jj).echelon = mod(jj,10)+1;
        end
        builderSet(jj).setSystemElement(PN.ProcessStep(jj));
    end

FNF.buildAnalysisModel;

%utilDirector = MetricDirector;
%utilDirector.ConstructMetric(processSet, 'Utilization');