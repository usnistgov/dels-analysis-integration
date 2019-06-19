classdef MakeProductY002 < Process
    %MAKEPRODUCTX001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetObservable)
        op10@Process1
        op20@Process4
        op30@Process2
        op99@PackShipClose
    end
    
    methods
        function obj = MakeProductY002()
            obj.typeID = 'MakeProductY002';
            obj.op10=Process1;
            obj.op20=Process4;
            obj.op30=Process2;
            obj.op99=PackShipClose;
            obj.processSteps = {obj.op10; obj.op20; obj.op30; obj.op99};
            for ii = 1:length(obj.processSteps)
                obj.processSteps{ii}.parentProcess = obj.instanceID;
            end
        end
    end
end

