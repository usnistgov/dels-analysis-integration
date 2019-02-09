classdef Edge < handle
    %EDGE is a connector object to link the SimEvents blocks with a type and direction
    
    %Assume: for each edge in a network, we can replace it with a node and
    %connect that node to the adjacent nodes with uncapacitated arcs
    
    properties
        ID
        OriginID %ID of origin network
        Origin@Network
        OriginPort@Port
        DestinationID %ID of destination network
        Destination@Network
        DestinationPort@Port
        EdgeType
        Weight
    end
    
    methods
        function obj = Edge(EdgeID, OriginID, DestinationID, EdgeType)
            if nargin>0
                obj.ID = EdgeID;
                obj.Origin = OriginID;
                obj.Destination = DestinationID;
                obj.EdgeType = EdgeType;
            end
            
        end
        
        function setEdgeWeight(E)
           E.Weight = abs(E.Origin.X - E.Destination.X)^2 + abs(E.Origin.Y - E.Destination.Y)^2 + abs(E.Origin.Z - E.Destination.Z)^2;
           if eq(E.Weight,0)
               E.Weight = 1e-6;
           end
        end
    end
    
end

