classdef Controller < handle
    %CONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DELS@DELS
        SchedulingInterface@SchedulingInterface %Abstract Strategy Class
    end
    
    methods
      %Constructor: assigns strategy to interface
      function SchedulingStrategy(self, strategy)
          self.SchedulingInterface = strategy;
          strategy.Controller = self;
      end
      function Scheduling(self, TaskList)
          self.SchedulingInterface.Scheduling(TaskList);
      end
    end
    
end

