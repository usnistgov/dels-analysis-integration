classdef Scheduling_ClarkWrightVRP < SchedulingInterface
    %implements SCHEDULING_STRATEGY
    %using Clark Wright VRP algorithm
    
    properties
    end
    
    methods
        function Scheduling(self, TaskList, ResourceSet)

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
            for j = 1:min(length(ResourceSet), length(loc))
                ResourceSet(j).TaskList = TaskList(loc{j});
                ResourceSet(j).TaskListCapacityRequirement = TC(j);
            end   
      end
    end
    
end

