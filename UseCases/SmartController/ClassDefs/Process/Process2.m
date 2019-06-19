classdef Process2 < Process
    %MAKEPRODUCTX001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Process2()
            obj@Process
            obj.targetResource = 2;
            obj.typeID = 'Process2';
        end    
    end
end

