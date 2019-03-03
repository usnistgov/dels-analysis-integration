classdef Commodity < NetworkElement
    
    %COMMODITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %^instanceID
        %^typeID
        %^name
        producedBy@FlowNetwork
        producedByID
        productionRate  % 
        consumedBy@FlowNetwork
        consumedByID
        consumptionRate %
        quantity
        value %{subsets measure}
        route = []
    end
    
    methods
        
    end
    
end

