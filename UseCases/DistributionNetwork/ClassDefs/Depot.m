classdef Depot < FlowNetwork
    %DEPOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        routingProbability %Placeholder for value until move routing to stategy class
        resourceAssignment
    end
    
    methods
        function self = Depot(input)
            %Input := ID X Y
           if nargin == 0
               % default constructor
           else
               self.instanceID = input(1);
               self.X = input(2);
               self.Y = input(3);
           end
        end
        
        function decorateNode(self)
            self.builder.Construct(self);
        end
    end
end

