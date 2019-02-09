classdef Scheduling_ClarkWrightVRP < SchedulingInterface
    %SCHEDULING_STRATEGY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function Scheduling(self, TaskList)

         %% 1. Add Depot
            depot = Task;
            depot.Task_ID = 0;
            depot.RequiredResourceState = [50, 50];
            depot.CapacityRequirement= 0;
            TaskList = [depot, TaskList];
            nNodes = length(TaskList);
         %% 2. Make Cost Matrix & Capacity Array
            %Build Cost Matrix: there are other ways to handle large instances but this works well enough
            costMat = zeros(nNodes, nNodes);
            capacityReqts = zeros(nNodes,1);

            for i = 1:nNodes
                capacityReqts(i) = TaskList(i).CapacityRequirement;
                for j = 1:nNodes
                    costMat(i,j) = self.Controller.DELS.Facility.TravelDistance(TaskList(i).RequiredResourceState,TaskList(j).RequiredResourceState);
                end
            end
         %% 3. Call Clark Wright Savings  
            [loc, TC] = vrpsavings(costMat, {capacityReqts, 1000});
         %% 4. Assign ordered tasklists to resources
            for j = 1:min(length(self.Controller.DELS.ResourceSet), length(loc))
                self.Controller.DELS.ResourceSet(j).TaskList = TaskList(loc{j});
                self.Controller.DELS.ResourceSet(j).TaskListCapacityRequirement = TC(j);
            end   
      end
    end
    
end

