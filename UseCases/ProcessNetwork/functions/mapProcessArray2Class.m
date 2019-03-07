function processSet = mapProcessArray2Class(P, machineCount, serviceTime)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    [nProcess, ~] = size(P);
    processSet(nProcess) = ProcessNetwork;
    for ii = 1:nProcess
       processSet(ii).instanceID = ii;
       processSet(ii).name = strcat('Process_', num2str(ii));
       processSet(ii).typeID = 'Process';
       processSet(ii).concurrentProcessingCapacity = machineCount(ii);
       processSet(ii).averageServiceTime = serviceTime(ii);
       processSet(ii).StorageCapacity = inf;
       routingProbability = P(ii,(P(ii,:)>0));
       processSet(ii).routingProbability = [routingProbability, 1-sum(routingProbability)];
    end

end

