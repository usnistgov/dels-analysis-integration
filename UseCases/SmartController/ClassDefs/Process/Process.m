classdef Process < handle
    %PROCESS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetObservable)
        instanceID
        typeID
        creates@Product
        parentProcess@Process
        currentProcessStep = 0 %should eventually point to the process itself, 
        %enabling dynamic process planning to navigate based on process network
        processSteps = {} %would prefer if this was a nx1 Process array, 
        % but matlab keeps trying to cast the specialized processes to the common superclass
        targetResource
        actualResource
        actualStartTime
        actualCompleteTime
    end

    methods
        function obj = Process(self)
            obj.instanceID = java.rmi.server.UID();
        end
    end
end

