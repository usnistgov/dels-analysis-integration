function flowEdgeSet = mapProbMatrix2EdgeSet(P)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    %This code has the same effect without using the Graph tools
    [nProcess, ~] = size(P);
    edgeAdjList = zeros(nProcess^2,3);
    for ii = 1:nProcess
       I = find(P(ii,:));
       edgeAdjList((ii-1)*nProcess+1:(ii-1)*nProcess+length(I),:) = [ii*ones(length(I),1), I', P(ii,I)'];
    end
    edgeAdjList = edgeAdjList(edgeAdjList(:,1)~=0,:);

    %Adjacency List to EdgeSet
    flowEdgeSet(length(edgeAdjList)) = FlowEdge;

    for ii = 1:length(edgeAdjList)
        flowEdgeSet(ii).EdgeID = ii;
        flowEdgeSet(ii).OriginID = edgeAdjList(ii,1);
        flowEdgeSet(ii).EdgeType = 'Job';
        flowEdgeSet(ii).DestinationID = edgeAdjList(ii,2);
    end

end

