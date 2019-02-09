classdef Scheduling_CLK_ITP < SchedulingInterface
    %Implements SCHEDULING_STRATEGY
    %Using Iterative Tour Partition on Chained-LK TSP solution
    
    properties
    end
    
    methods
        function Scheduling(self, TaskList, ResourceSet)
            %Using Iterative Tour Partition on Chained-LK TSP solution
            %% 1. Make Cost Matrix
            nNodes = length(TaskList);
            %Build Cost Matrix: there are other ways to handle large instances but this works well enough
            costMat = zeros(nNodes, nNodes);
            for i = 1:nNodes
                for j = 1:nNodes
                    costMat(i,j) = self.Context.DELS.Facility.TravelDistance(TaskList(i).RequiredResourceState,TaskList(j).RequiredResourceState);
                end
            end
            costMat = costMat + diag( ones(nNodes,1)*NaN , 0 );
            %% 2. Initialize with Nearest Neighbor Heuristic
            % Or just a list (sometimes poor solutions are better initial solutions)
            T = nearestNeighbor(costMat);
            %T = [1:nNodes,1];
            %% 3. Call chained_lin_kernighan
            %output_tour = chained_lk(input_tour, cost_matrix, numberOfneighbors)
            T = chained_lk(T, costMat, 5);
            %% 4. Add Depot
            for i = 1:nNodes
                costMat(i,nNodes +1 ) = self.Context.DELS.Facility.TravelDistance(TaskList(i).RequiredResourceState,[50, 50]);
                costMat(nNodes+1 ,i ) = self.Context.DELS.Facility.TravelDistance(TaskList(i).RequiredResourceState,[50, 50]);
            end
            %% 5. Partition the TSP tour
            partitions = ITP(T, costMat, length(ResourceSet));
            %% 6.Assign ordered tasklists to resources
            for j = 1:length(self.Controller.DELS.ResourceSet)
                ResourceSet(j).TaskList = TaskList(partitions(2:end-1,j));
            end
        end
    end
end

