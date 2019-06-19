classdef Process1 < Process
    %Process1 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Process1()
            obj@Process
            obj.targetResource = 1;
            obj.typeID = 'Process1';
        end
    end
end

