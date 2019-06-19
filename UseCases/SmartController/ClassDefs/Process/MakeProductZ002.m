classdef MakeProductZ002 < Process
    %MAKEPRODUCTX001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetObservable)
        op10@Process1
        op20@Process3
        op30@Process2
        op99@PackShipClose
    end
    
    methods
        function obj = MakeProductZ002()
            obj.typeID = 'MakeProductZ002';
            obj.op10 = Process1;
            obj.op20 = Process3;
            obj.op30 = Process2;
            obj.op99 = PackShipClose;
            obj.processSteps = {obj.op10; obj.op20; obj.op30;obj.op99};
            %%6/17/19 changed to reference to make not recursive for json
            for ii = 1:length(obj.processSteps)
                obj.processSteps{ii}.parentProcess = obj.instanceID;
            end
        end
    end
end

