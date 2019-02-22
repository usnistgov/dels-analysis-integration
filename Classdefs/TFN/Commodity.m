classdef Commodity < NetworkElement
    
    %COMMODITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %^instanceID
        %^typeID
        %^name
        origin@FlowNetwork
        originID
        destination@FlowNetwork
        destinationID
        quantity
        route = []
    end
    
    methods
        
    end
    
end

