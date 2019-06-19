classdef ProductY002 < Product
    %PRODUCTY001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %processPlan@MakeProductY001
    end
    
    methods
        function obj = ProductY002(serialNumber)
            if nargin>0
            	obj.serialNumber = serialNumber;
            end
            
            obj.instanceID = string(java.rmi.server.UID().toString());
            obj.typeID = 'ProductY002';
            obj.processPlan = MakeProductY002;
            obj.processPlan.creates = obj.instanceID;
        end
        

    end
end

