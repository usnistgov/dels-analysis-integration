classdef SchedulingInterface < handle
    %SCHEDULING_STRATEGY: abstract strategy interface for scheduling
    % *should* inherit from sequencing and assignment interfaces
    
    properties
       Context@Controller
    end
    
    methods (Abstract)
        Scheduling(self, TaskList, ResourceSet)
    end
    
end

