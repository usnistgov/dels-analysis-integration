classdef Edge < handle
    %EDGE is a connector object to link the SimEvents blocks with a type and direction
    
    %Assume: for each edge in a network, we can replace it with a node and
    %connect that node to the adjacent nodes with uncapacitated arcs
    
    properties
        Edge_ID
        Origin %ID of origin node
        Origin_Node@Node
        Origin_Port@Port
        Destination %ID of destination node
        Destination_Node@Node
        Destination_Port@Port
        EdgeType
        Weight
    end
    
    methods
        function obj = Edge(Edge_ID, Origin, Destination, EdgeType)
            if nargin>0
                obj.Edge_ID = Edge_ID;
                obj.Origin = Origin;
                obj.Destination = Destination;
                obj.EdgeType = EdgeType;
            end
            
        end
        
        function setEdgeWeight(E)
           E.Weight = abs(E.Origin_Node.X - E.Destination_Node.X)^2 + abs(E.Origin_Node.Y - E.Destination_Node.Y)^2 + abs(E.Origin_Node.Z - E.Destination_Node.Z)^2;
           if eq(E.Weight,0)
               E.Weight = 1e-6;
           end
        end
    end
    
end

