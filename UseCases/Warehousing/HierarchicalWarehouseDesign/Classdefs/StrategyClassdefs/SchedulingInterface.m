classdef SchedulingInterface < handle
    %SCHEDULING_STRATEGY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       Controller@Controller
    end
    
    methods (Abstract)
        Scheduling(self, TaskList)
    end
    
end

