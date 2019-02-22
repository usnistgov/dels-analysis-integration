classdef NetworkLink < NetworkElement
    %NETWORKLINK -- class for edges in a network, undirected
    
    %Assume: for each edge in a network, we can replace it with a node and
    %connect that node to the adjacent nodes with uncapacitated arcs
    
    %NOTE: endNetwork1 & endNetwork2 are functionally no different than
    % endNetwork = Network.empty(2)
    % and refering to them as endNetwork{1} & endNetwork{2}
    
    properties
        %^name
        %^instanceID
        %^typeID
        
        endNetwork1ID %instanceID of origin network
        endNetwork1@Network
        endNetwork1Port@Port
        endNetwork2ID %instanceID of destination network
        endNetwork2@Network
        endNetwork2Port@Port
        weight
    end
    
    methods
        function obj = NetworkLink(instanceID, endNetwork1ID, endNetwork2ID, typeID)
            if nargin>0
                obj.instanceID = instanceID;
                obj.endNetwork1 = endNetwork1ID;
                obj.endNetwork2 = endNetwork2ID;
                obj.typeID = typeID;
            end
            
        end
        
        function setEdgeWeight(e)
           e.weight = abs(e.endNetwork1.X - e.endNetwork2.X)^2 + abs(e.endNetwork1.Y - e.endNetwork2.Y)^2 + abs(e.endNetwork1.Z - e.endNetwork2.Z)^2;
           if eq(e.weight,0)
               e.weight = 1e-6;
           end
        end
    end
    
end

