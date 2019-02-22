classdef Network < NetworkElement
    %NETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    %For future implementation ideas:
    %http://strategic.mit.edu/downloads.php?page=matlab_networks
    %http://www.levmuchnik.net/Content/Networks/ComplexNetworksPackage.html
    %http://www.ise.ncsu.edu/kay/matlog/MatlogRef.htm
    %http://www.mathworks.com/help/matlab/graph-and-network-algorithms.html
    
    properties
        %^name
        %^instanceID
        %^typeID
        nodeSet@Network
        edgeSet@NetworkLink
        parentID %From the instance data
        parentNetwork@Network
        edgeSetList = [0 0 0 0] %[instanceID Origin Destination Weight]
        edgeSetAdjList
        nodeSetList = [0, 0, 0, 0] %[instanceID, X, Y, Z] %2/7/19 Removed "Type = 'Node'"
        
        %inEdgeSet@NetworkLink %A set of edge classes incoming to the node
        %outEdgeSet@NetworkLink %A set of edge classes outgoing to the node

        %Spacial Properties
        X
        Y
        Z
    end
    
    methods
        function obj = Network(instanceID, X, Y, Z, typeID)
            if nargin>0
                obj.instanceID = instanceID;
                obj.X = X;
                obj.Y = Y;
                obj.Z = Z;
                obj.typeID = typeID;
            end
            
        end
        
        function allocate_edges(N)
        %ALLOCATE_EDGES Summary of this function goes here
        %   Detailed explanation goes here

            parfor jj = 1:length(N.NodeSet)
                E = findobj(N.EdgeSet, 'OriginID', N.NodeSet(jj).instanceID);
                for e = 1:length(E)
                    N.NodeSet(jj).addEdge(E(e));
                end
                E = findobj(N.EdgeSet, 'DestinationID', N.NodeSet(jj).instanceID);
                for e = 1:length(E)
                    N.NodeSet(jj).addEdge(E(e));
                end

                N.NodeSet(jj).assignPorts;
            end %for each node
        end
        
        function setEdgeWeights(self)
            
           for e = 1:length(self.edgeSet)
               n1 = self.edgeSet(e).endNetwork1;
               n2 = self.edgeSet(e).endNetwork2;
               self.edgeSet(e).weight = max(sqrt(abs(n1.X - n2.X)^2 + abs(n1.Y - n2.Y)^2 + abs(n1.Z - n2.Z)^2), 1e-06);
               self.edgeSetList(e,4) = self.edgeSet(e).weight;
           end
        end
        
         function addEdge(self, edgeSet)
            self.edgeSet = findobj(edgeSet, 'endNetwork1', self.instanceID, '-or', 'endNetwork2', self.instanceID);
        end
        
        function edgeSetToList(self)
           edgeSetList = [0 0 0 0];
           for ii = 1:length(self.edgeSet)
               e = self.edgeSet(ii);
               edgeSetList = [edgeSetList; e.instanceID, e.endNetwork1, e.endNetwork2, e.weight];
               self.edgeSetList = edgeSetList(2:end, :);
           end
        end
        
        function plotNetwork(self)
            coordinates = [self.nodeSetList(:,2), self.nodeSetList(:,3)];
            gplot(self.edgeSetAdjList, coordinates, '-*')
        end
        
    end
    
  
    
end

