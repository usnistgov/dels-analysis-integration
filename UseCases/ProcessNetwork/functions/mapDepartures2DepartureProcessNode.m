function [departureProcess, departureEdgeSet] = mapDepartures2DepartureProcessNode(processSet, edgeSet, productArrivalRate, processPlanList)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

nProcess = max(max(processPlanList));
departureProcess = Process;
departureProcess.instanceID = nProcess+2;
departureProcess.name = 'Departure_Process';
departureProcess.typeID = 'DepartureProcess';
departureProcess.concurrentProcessingCapacity = inf;
departureProcess.averageServiceTime = 0.05;
departureProcess.ProcessTime_Stdev = eps;
departureProcess.storageCapacity = inf;
departureProcess.routingProbability = [1 0];


probMatrix = mapProcessPlan2ProbMatrix( processPlanList, productArrivalRate);
rowSum = sum(probMatrix,2);
idx = find(rowSum < 1);
departureEdgeSet(length(idx)) = FlowNetworkLink;
for ii = 1:length(idx)
    departureEdgeSet(ii).instanceID = length(edgeSet) + ii;
    departureEdgeSet(ii).sourceFlowNetworkID =  processSet(idx(ii)).instanceID;
    departureEdgeSet(ii).sourceFlowNetwork = processSet(idx(ii));
    departureEdgeSet(ii).targetFlowNetworkID = departureProcess.instanceID;
    departureEdgeSet(ii).targetFlowNetwork = departureProcess;
    departureEdgeSet(ii).typeID = 'Job';

    %Find product's who's last process step is process ii (this)
    idx2 = find(processPlanList(:,end) == processSet(idx(ii)).instanceID); 
    departureEdgeSet(ii).flowTypeAllowed = idx2;
    departureEdgeSet(ii).flowAmount = productArrivalRate;
end

end

