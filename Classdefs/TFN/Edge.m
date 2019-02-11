classdef Edge < NetworkElement
    %EDGE is a connector object to link the SimEvents blocks with a type and direction
    
    %Assume: for each edge in a network, we can replace it with a node and
    %connect that node to the adjacent nodes with uncapacitated arcs
    
    properties
        %ID %Replaced with instanceID
        OriginID %instanceID of origin network
        Origin@Network
        OriginPort@Port
        DestinationID %instanceID of destination network
        Destination@Network
        DestinationPort@Port
        %EdgeType %replaced with typeID
        Weight
    end
    
    methods
        function obj = Edge(EdgeID, OriginID, DestinationID, EdgeType)
            if nargin>0
                obj.instanceID = EdgeID;
                obj.Origin = OriginID;
                obj.Destination = DestinationID;
                obj.typeID = EdgeType;
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

