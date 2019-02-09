classdef Network < handle
    %NETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    %For future implementation ideas:
    %http://strategic.mit.edu/downloads.php?page=matlab_networks
    %http://www.levmuchnik.net/Content/Networks/ComplexNetworksPackage.html
    %http://www.ise.ncsu.edu/kay/matlog/MatlogRef.htm
    
    properties
        Model
        NodeSet@Node
        EdgeSet@Edge
        Parent@Node
        EdgeSetList = [0 0 0 0] %[ID Origin Destination Weight]
        EdgeSetAdjList
        NodeSetList = [0, 0, 0, 0, 'Node'] %[ID, X, Y, Z, Type]
    end
    
    methods
        function allocate_edges(N)
        %ALLOCATE_EDGES Summary of this function goes here
        %   Detailed explanation goes here


            parfor j = 1:length(N.NodeSet)
                E = findobj(N.EdgeSet, 'Origin', N.NodeSet(j).Node_ID);
                for e = 1:length(E)
                    N.NodeSet(j).addEdge(E(e));
                end
                E = findobj(N.EdgeSet, 'Destination', N.NodeSet(j).Node_ID);
                for e = 1:length(E)
                    N.NodeSet(j).addEdge(E(e));
                end

                N.NodeSet(j).assignPorts;

            end %for each node
        end
        
        function setEdgeWeights(N)
            
           for e = 1:length(N.EdgeSet);
               n1 = N.EdgeSet(e).Origin_Node;
               n2 = N.EdgeSet(e).Destination_Node;
               N.EdgeSet(e).Weight = max(sqrt(abs(n1.X - n2.X)^2 + abs(n1.Y - n2.Y)^2 + abs(n1.Z - n2.Z)^2), 1e-06);
               N.EdgeSetList(e,4) = N.EdgeSet(e).Weight;
           end
        end
        
        function EdgeSetToList(N)
           EdgeSetList = [0 0 0 0];
           for i = 1:length(N.EdgeSet)
               e = N.EdgeSet(i);
               EdgeSetList = [EdgeSetList; e.Edge_ID, e.Origin, e.Destination, e.Weight];
               N.EdgeSetList = EdgeSetList(2:end, :);
           end
        end
        
        function plotNetwork(N)
            coordinates = [N.NodeSetList(:,2), N.NodeSetList(:,3)];
            %[X2, Y2] = gplot(MovementNetwork.EdgeSetAdjList, coordinates, '-*');
            %[X1,Y1] = gplot(MovementNetwork.EdgeSetAdjList, coordinates, '-*');
            gplot(N.EdgeSetAdjList, coordinates, '-*')
        end
        
    end
    
end

