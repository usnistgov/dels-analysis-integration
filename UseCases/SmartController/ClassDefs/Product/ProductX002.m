classdef ProductX002 < Product
    %PRODUCTX001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %processPlan@MakeProductX001
    end
    
    methods
        function obj = ProductX002(serialNumber)
            if nargin>0
            	obj.serialNumber = serialNumber;
            end
            obj.instanceID = string(java.rmi.server.UID().toString());
            obj.typeID = 'ProductX002';
            obj.processPlan = MakeProductX002;
            obj.processPlan.creates = obj.instanceID;
        end

    end
end

