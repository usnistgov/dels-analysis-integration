classdef SequencingDependency < NetworkLink
    %SEQUENCINGDEPENDENCY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %^name
        %^instanceID
        %^typeID
        %^weight
        dependencyTypeID
        sourceProcess@ProcessNetwork
        sourceProcessID
        targetProcess@ProcessNetwork
        targetProcessID
        
    end
    
    methods
    end
    
end

