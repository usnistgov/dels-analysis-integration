classdef Controller < handle
    %CONTROLLER class for DELS
    % To Do: Implement full functional capability
    
    properties
        DELS@DELS
        SchedulingInterface@SchedulingInterface %Abstract Strategy Class
        AssignmentInterface@AssignmentInterface %Abstract Strategy Class
        SequencingInterface@SequencingInterface %Abstract Strategy Class
    end
    
    methods
      % Scheduling Constructor: assigns strategy to interface
      function SchedulingStrategy(self, strategy)
          self.SchedulingInterface = strategy;
          strategy.Controller = self;
      end
      function Scheduling(self, TaskList, ResourceSet)
          self.SchedulingInterface.Scheduling(TaskList, ResourceSet);
      end
      
      %  Assigment Constructor: assigns strategy to interface
      function AssignmentStrategy(self, strategy)
          self.AssignmentInterface = strategy;
          strategy.Controller = self;
      end
      function resourcePartition = Assignment(self, TaskList, ResourceSet)
          resourcePartition = self.AssignmentInterface.Assignment(TaskList, ResourceSet);
      end
      
      % Sequencing Constructor: assigns strategy to interface
      function SequencingStrategy(self, strategy)
          self.SequencingInterface = strategy;
          strategy.Controller = self;
      end
      function sequenceIndex = Sequencing(self, TaskList)
          sequenceIndex = self.SequencingInterface.Sequencing(TaskList);
      end
    end
end

