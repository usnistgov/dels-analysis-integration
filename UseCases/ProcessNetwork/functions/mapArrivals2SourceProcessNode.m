function [arrivalProcess, arrivalEdgeSet] = mapArrivals2SourceProcessNode(processSet, edgeSet, productArrivalRate, processPlanSet)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

nProcess = length(processSet);
nProd = length(productArrivalRate);
totalArrivalRate = sum(productArrivalRate);
Parrival = zeros(nProcess, 1);

for ii = 1:nProd
    Parrival(processPlanSet(ii,1)) = Parrival(processPlanSet(ii,1)) + productArrivalRate(ii);
end

arrivalProcess = Process;
arrivalProcess.Node_ID = nProcess+1;
arrivalProcess.Node_Name = 'Arrival_Process';
arrivalProcess.Type = 'ArrivalProcess';
arrivalProcess.ServerCount = inf;
arrivalProcess.ProcessTime_Mean = 1/totalArrivalRate;
arrivalProcess.StorageCapacity = inf;
arrivalProcess.Echelon = 1;
arrivalProcess.routingProbability = Parrival ./ totalArrivalRate;

arrivalEdgeSet(nProcess) = Edge;
for ii = 1:nProcess
    arrivalEdgeSet(ii).Edge_ID = length(edgeSet)+ ii;
    arrivalEdgeSet(ii).Origin = arrivalProcess.Node_ID;
    arrivalEdgeSet(ii).EdgeType = 'Job';
    arrivalEdgeSet(ii).Destination = processSet(ii).Node_ID;
end

end

