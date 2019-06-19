classdef MakeProductY001 < Process
    %MAKEPRODUCTX001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetObservable)
        op10@Process3
        op20@Process2
        op30@Process4
        op99@PackShipClose
    end
    
    methods
        function obj = MakeProductY001()
            obj.typeID = 'MakeProductY001';
            obj.op10=Process3;
            obj.op20=Process2;
            obj.op30=Process4;
            obj.op99=PackShipClose;
            obj.processSteps = {obj.op10; obj.op20; obj.op30; obj.op99};
            for ii = 1:length(obj.processSteps)
                obj.processSteps{ii}.parentProcess = obj.instanceID;
            end
        end
    end
end

