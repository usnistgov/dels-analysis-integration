classdef Customer < FlowNetwork
    %CUSTOMER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        routingProbability %Placeholder for value until move routing to stategy class
    end
    
    methods (Access = public)
        function self = Customer(input)
            %Input := instanceID X Y
           if nargin == 0
               % default constructor
           else
               self.instanceID = input(1);
               self.X = input(2);
               self.Y = input(3);
           end
        end
    end
   
end

