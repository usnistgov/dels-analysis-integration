classdef Process1 < Process
    %MAKEPRODUCTX001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Process1()
            obj@Process
            obj.targetResource = 1;
        end
    end
end

