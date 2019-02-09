classdef Scheduling_CLK_ITP < SchedulingInterface
    %SCHEDULING_STRATEGY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function Scheduling(self, TaskList)
            %Using Iterative Tour Partition on Chained-LK TSP solution

            %% Make Cost Matrix
            nNodes = length(TaskList);
            %Build Cost Matrix: there are other ways to handle large instances but this works well enough
            costMat = zeros(nNodes, nNodes);
            for i = 1:nNodes
                for j = 1:nNodes
                    costMat(i,j) = self.Controller.DELS.Facility.TravelDistance(TaskList(i).RequiredResourceState,TaskList(j).RequiredResourceState);
                end
            end
            costMat = costMat + diag( ones(nNodes,1)*NaN , 0 );

            %% Initialize with Nearest Neighbor Heuristic
            % Or just a list (sometimes poor solutions are better initial solutions)
            T = nearestNeighbor(costMat);
            %T = [1:nNodes,1];

            %% Call chained_lin_kernighan
            %output_tour = chained_lk(input_tour, cost_matrix, numberOfneighbors)
            T = chained_lk(T, costMat, 5);

            %% Add Depot
            for i = 1:nNodes
                costMat(i,nNodes +1 ) = self.Controller.DELS.Facility.TravelDistance(TaskList(i).RequiredResourceState,[50, 50]);
                costMat(nNodes+1 ,i ) = self.Controller.DELS.Facility.TravelDistance(TaskList(i).RequiredResourceState,[50, 50]);
            end
            
            %% Partition the TSP tour
            partitions = ITP(T, costMat, length(self.DELS.ResourceSet));
            
            %% Assign ordered tasklists to resources
            for j = 1:length(self.Controller.DELS.ResourceSet)
                self.Controller.DELS.ResourceSet(j).TaskList = TaskList(partitions(2:end-1,j));
            end
            
        end
    end
    
end

