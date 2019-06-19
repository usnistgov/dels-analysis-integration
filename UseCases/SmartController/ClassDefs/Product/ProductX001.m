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
            end
            obj.instanceID = string(java.rmi.server.UID().toString());
            obj.typeID = 'ProductX001';
            obj.processPlan = MakeProductX001;
            obj.processPlan.creates = obj.instanceID;
        end

    end
end

