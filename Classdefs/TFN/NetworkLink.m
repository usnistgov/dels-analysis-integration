classdef NetworkLink < NetworkElement
    %NETWORKLINK -- class for edges in a network, undirected
    
    %Assume: for each edge in a network, we can replace it with a node and
    %connect that node to the adjacent nodes with uncapacitated arcs
    
    %NOTE: linkEnd1 & linkEnd2 are functionally no different than
    % linkEnd = Network.empty(2)
    % and refering to them as linkEnd{1} & linkEnd{2}
    
    properties
        %^name
        %^instanceID
        %^typeID
        linkEnd1ID %instanceID of network at end of link
        linkEnd1@Network
        linkEnd2ID %instanceID of network at end of link
        linkEnd2@Network
        weight
        
    end
    
    methods
        function obj = NetworkLink(instanceID, linkEnd1ID, linkEnd2ID, typeID)
            if nargin>0
                obj.instanceID = instanceID;
                obj.linkEnd1 = linkEnd1ID;
                obj.linkEnd2 = linkEnd2ID;
                obj.typeID = typeID;
            end
            
        end
        
        function setEdgeWeight(e)
           e.weight = abs(e.linkEnd1.X - e.linkEnd2.X)^2 + abs(e.linkEnd1.Y - e.linkEnd2.Y)^2 + abs(e.linkEnd1.Z - e.linkEnd2.Z)^2;
           if eq(e.weight,0)
               e.weight = 1e-6;
           end
        end
    end
    
end

