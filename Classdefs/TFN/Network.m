classdef Network < NetworkElement
    %NETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    %For future implementation ideas:
    %http://strategic.mit.edu/downloads.php?page=matlab_networks
    %http://www.levmuchnik.net/Content/Networks/ComplexNetworksPackage.html
    %http://www.ise.ncsu.edu/kay/matlog/MatlogRef.htm
    %http://www.mathworks.com/help/matlab/graph-and-network-algorithms.html
    
    %NOTE: endNetwork1 & endNetwork2 are functionally no different than
    % endNetwork = Network.empty(2) and refering to them as endNetwork{1} & endNetwork{2}
    
    properties
        %^name
        %^instanceID
        %^typeID
        nodeSet@Network
        edgeSet@NetworkLink
        endNetwork1
        endNetwork2
        parentID %From the instance data
        parentNetwork@Network
        edgeSetList = [0 0 0 0] %[instanceID Origin Destination Weight]
        nodeSetList = [0, 0, 0, 0] %[instanceID, X, Y, Z] %2/7/19 Removed "Type = 'Node'"
        edgeSetAdjList
        
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
        
        function setEdgeWeights(self)
            
           for e = 1:length(self.edgeSet)
               n1 = self.edgeSet(e).linkEnd1;
               n2 = self.edgeSet(e).linkEnd2;
               self.edgeSet(e).weight = max(sqrt(abs(n1.X - n2.X)^2 + abs(n1.Y - n2.Y)^2 + abs(n1.Z - n2.Z)^2), 1e-06);
               self.edgeSetList(e,4) = self.edgeSet(e).weight;
           end
        end
        
         function addEdge(self, edgeSet)
            self.edgeSet = findobj(edgeSet, 'linkEnd1', self.instanceID, '-or', 'linkEnd2', self.instanceID);
        end
        
        function edgeSetToList(self)
           edgeSetList = [0 0 0 0];
           for ii = 1:length(self.edgeSet)
               e = self.edgeSet(ii);
               edgeSetList = [edgeSetList; e.instanceID, e.linkEnd1, e.linkEnd2, e.weight];
               self.edgeSetList = edgeSetList(2:end, :);
           end
        end
        
        function plotNetwork(self)
            coordinates = [self.nodeSetList(:,2), self.nodeSetList(:,3)];
            gplot(self.edgeSetAdjList, coordinates, '-*')
        end
        
    end
    
  
    
end

