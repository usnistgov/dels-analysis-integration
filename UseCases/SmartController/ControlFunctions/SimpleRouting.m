classdef SimpleRouting < IRouting
    %SIMPLEROUTING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function [nextNode] = Routing(self,inTask)
            %ROUTING Summary of this function goes here
            %   Detailed explanation goes here

            %1) Select next process step
            nextProcessStep = DynamicProcessPlanning(inTask);

            %2) Assign capable/available resources
                %in this example, there's only one capable resource
                %the targetResource in the process definition
            nextNode = nextProcessStep.targetResource;

            %3) Look-up "switch" destination of nextNode

        end
    end
end

