classdef Product < handle
    %PRODUCT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetObservable)
        instanceID
        typeID
        processPlan%@Process
        serialNumber
        actualCompleteTime
        actualOutputCondition
    end
    
   
    methods
        function obj = Product(serialNumber)
            if nargin>0
            	obj.serialNumber = serialNumber;
                obj.instanceID = serialNumber;
            end
        end

        function processStep = currentProcessStep(self)
            processStep = self.processPlan.processSteps{self.processPlan.currentProcessStep};
        end
        
    end
end

