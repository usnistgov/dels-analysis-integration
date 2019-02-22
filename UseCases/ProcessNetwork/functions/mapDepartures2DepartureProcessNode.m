function [departureProcess, departureEdgeSet] = mapDepartures2DepartureProcessNode(processSet, edgeSet, P)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

[nProcess,~] = size(P);
departureProcess = Process;
departureProcess.instanceID = nProcess+2;
departureProcess.name = 'Departure_Process';
departureProcess.typeID = 'DepartureProcess';
departureProcess.ServerCount = inf;
departureProcess.ProcessTime_Mean = 0.05;
departureProcess.ProcessTime_Stdev = eps;
departureProcess.StorageCapacity = inf;
departureProcess.routingProbability = [0 0];

rowSum = sum(P,2);
I = find(rowSum < 1);
departureEdgeSet(length(I)) = FlowNetworkLink;
for ii = 1:length(I)
    departureEdgeSet(ii).instanceID = length(edgeSet) + ii;
    departureEdgeSet(ii).sourceFlowNetworkID =  processSet(I(ii)).instanceID;
    departureEdgeSet(ii).typeID = 'Job';
    departureEdgeSet(ii).targetFlowNetworkID = departureProcess.instanceID;
end

end

