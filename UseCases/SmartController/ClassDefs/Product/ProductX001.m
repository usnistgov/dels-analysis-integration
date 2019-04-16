classdef ProductX001 < Product
    %PRODUCTX001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %processPlan@MakeProductX001
    end
    
    methods
        function obj = ProductX001(serialNumber)
            if nargin>0
            	obj.serialNumber = serialNumber;
                obj.instanceID = serialNumber;
            end
            obj.typeID = 'ProductX001';
            obj.processPlan = MakeProductX001;
            obj.processPlan.creates = obj;
        end

    end
end

