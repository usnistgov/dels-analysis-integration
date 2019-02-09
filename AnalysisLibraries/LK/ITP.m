function [ best_partition ] = ITP( T, costMat, partitionCount )
%ITP Summary of this function goes here
%   Detailed explanation goes here

    partitions = [];
    T = T(1:end-1);
    nNodes= length(T);
    T= [T T];
    partitionsize = round(nNodes / partitionCount);
    
    
    %% Initialize first partition
    i=0;
    partition_cost = 0;
    for j = 1:partitionCount-1
    partitions(:,j) = [nNodes+1, T((j-1)*partitionsize+1+i:j*partitionsize+i), nNodes+1];
    partition_cost = partition_cost + tourLength(partitions(:,j), costMat);
    end
    partitions(:,partitionCount) = [nNodes+1, T((partitionCount-1)*partitionsize+1+i:nNodes+i), nNodes+1];
    partition_cost = partition_cost + tourLength(partitions(:,partitionCount), costMat);
    
    %Set first partition as best partition
    best_partition = partitions;
    best_partition_cost = tourLength(partitions(:,1), costMat) + tourLength(partitions(:,2), costMat) + ...
         tourLength(partitions(:,3), costMat) + tourLength(partitions(:,4), costMat) + tourLength(partitions(:,5), costMat);
    %% Iterate through remaining partitions
    for i = 1:nNodes-1
        %Create Next Partion
        partition_cost = 0;
            for j = 1:partitionCount-1
                partitions(:,j) = [nNodes+1, T((j-1)*partitionsize+1+i:j*partitionsize+i), nNodes+1];
                partition_cost = partition_cost + tourLength(partitions(:,j), costMat);
            end
            partitions(:,partitionCount) = [nNodes+1, T((partitionCount-1)*partitionsize+1+i:nNodes+i), nNodes+1];
            partition_cost = partition_cost + tourLength(partitions(:,partitionCount), costMat);
    
    
        if partition_cost < best_partition_cost
            best_partition = partitions;
            best_partition_cost = partition_cost;
        end

    end
end

