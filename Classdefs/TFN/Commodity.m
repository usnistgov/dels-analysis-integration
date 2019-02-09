classdef Commodity < handle
    
    %COMMODITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID
        Origin@FlowNetwork
        OriginID
        Destination@FlowNetwork
        DestinationID
        Quantity
        Route = []
    end
    
    methods
        
    end
    
end

