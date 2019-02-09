classdef Network < handle
    %NETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    %For future implementation ideas:
    %http://strategic.mit.edu/downloads.php?page=matlab_networks
    %http://www.levmuchnik.net/Content/Networks/ComplexNetworksPackage.html
    %http://www.ise.ncsu.edu/kay/matlog/MatlogRef.htm
    %http://www.mathworks.com/help/matlab/graph-and-network-algorithms.html
    
    properties
        Name
        ID 
        NodeSet@Network
        EdgeSet@Edge
        ParentID %From the instance data
        Parent@Network
        EdgeSetList = [0 0 0 0] %[ID Origin Destination Weight]
        EdgeSetAdjList
        NodeSetList = [0, 0, 0, 0] %[ID, X, Y, Z] %2/7/19 Removed "Type = 'Node'"
        
        
        Type %Designation of type of node to be instantiated in simulation
        INEdgeSet@Edge %A set of edge classes incoming to the node
        OUTEdgeSet@Edge %A set of edge classes outgoing to the node
        NestedNetwork@Network
        EdgeTypeSet = {} %Collection of types of edges incident to the node (should be private)
        PortSet@Port %A set of port classes that define the node interface
        
        Model
        SimEventsPath %The associated SimEvents block identifier >> CHANGED ON 1/22/15; expect errors
        Echelon = 1 %A parameter currently used for aesthetic organization purposes
        
        %Spacial Properties
        X
        Y
        Z
    end
    
    methods
        function obj = Network(NetworkID, X, Y, Z, Type)
            if nargin>0
                obj.ID = NetworkID;
                obj.X = X;
                obj.Y = Y;
                obj.Z = Z;
                obj.Type = Type;
            end
            
        end
        
        function allocate_edges(N)
        %ALLOCATE_EDGES Summary of this function goes here
        %   Detailed explanation goes here

            parfor jj = 1:length(N.NodeSet)
                E = findobj(N.EdgeSet, 'OriginID', N.NodeSet(jj).ID);
                for e = 1:length(E)
                    N.NodeSet(jj).addEdge(E(e));
                end
                E = findobj(N.EdgeSet, 'DestinationID', N.NodeSet(jj).ID);
                for e = 1:length(E)
                    N.NodeSet(jj).addEdge(E(e));
                end

                N.NodeSet(jj).assignPorts;
            end %for each node
        end
        
        function setEdgeWeights(N)
            
           for e = 1:length(N.EdgeSet)
               n1 = N.EdgeSet(e).Origin;
               n2 = N.EdgeSet(e).Destination;
               N.EdgeSet(e).Weight = max(sqrt(abs(n1.X - n2.X)^2 + abs(n1.Y - n2.Y)^2 + abs(n1.Z - n2.Z)^2), 1e-06);
               N.EdgeSetList(e,4) = N.EdgeSet(e).Weight;
           end
        end
        
        function addEdge(N, e)
            %Add edges incident to the Node to one of the two sets
            %7/5/16: Switched from If/Elseif to if/if to accomodate self-edges
            if eq(e.DestinationID, N.ID) == 1
            %if e.Destination == N.Node_ID
                N.INEdgeSet(end+1) = e;
                e.Destination = N;
                N.EdgeTypeSet{end+1} = e.EdgeType;
            end
            if eq(e.OriginID, N.ID) == 1
            %if e.Origin == N.Node_ID
                N.OUTEdgeSet(end+1) = e;
                e.Origin = N;
                N.EdgeTypeSet{end+1} = e.EdgeType;
            end
            N.EdgeTypeSet = unique(N.EdgeTypeSet);
        end %add (incident) edges function
        
        function edgeSetToList(N)
           EdgeSetList = [0 0 0 0];
           for i = 1:length(N.EdgeSet)
               e = N.EdgeSet(i);
               EdgeSetList = [EdgeSetList; e.EdgeID, e.OriginID, e.DestinationID, e.Weight];
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
    
    methods (Abstract = true)
        decorateNode(N) %Add additional functionality based on the specific subclass
            %e.g. make a normal node a customer node
            %Can be re-called to change the decoration of a simulation node
        assignPorts(N)
        buildPorts(N)
    end
    
    
end

