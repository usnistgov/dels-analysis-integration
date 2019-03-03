function [arrivalProcess, arrivalEdgeSet] = mapArrivals2ArrivalProcessNode(processSet, edgeSet, productArrivalRate, processPlanSet)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

nProcess = length(processSet);
nProd = length(productArrivalRate);
totalArrivalRate = sum(productArrivalRate);
Parrival = zeros(nProcess, 1);

for ii = 1:nProd
    Parrival(processPlanSet(ii,1)) = Parrival(processPlanSet(ii,1)) + productArrivalRate(ii);
end

arrivalProcess = ProcessNetwork;
arrivalProcess.instanceID = nProcess+1;
arrivalProcess.name = 'Arrival_Process';
arrivalProcess.typeID = 'ArrivalProcess';
arrivalProcess.concurrentProcessingCapacity = inf;
arrivalProcess.ProcessTime_Mean = 1/totalArrivalRate;
arrivalProcess.StorageCapacity = inf;
arrivalProcess.routingProbability = Parrival ./ totalArrivalRate;

arrivalEdgeSet(nProcess) = FlowNetworkLink;
for ii = 1:nProcess
    arrivalEdgeSet(ii).instanceID = length(edgeSet)+ ii;
    arrivalEdgeSet(ii).sourceFlowNetworkID = arrivalProcess.instanceID;
    arrivalEdgeSet(ii).typeID = 'Job';
    arrivalEdgeSet(ii).targetFlowNetworkID = processSet(ii).instanceID;
end

end

