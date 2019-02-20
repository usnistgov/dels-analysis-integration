classdef FlowEdge < Edge
    %FLOWEDGE Summary of this class goes here
    %   flow edges are directed
    
    properties
        %EdgeID
        %OriginID %ID of origin network
        %Origin@Network
        %DestinationID %ID of destination network
        %Destination@Network
        sourceFlowNetworkID
        targetFlowNetworkID
        sourceFlowNetwork
        targetFlowNetwork
        flowTypeAllowed %{ordered} %Array of Commodities' typeID allowed to flow
        flowCapacity %{ordered} %Capacity (upper bound) for each commodity flow
        grossCapacity = Inf;
        flowFixedCost = 0; %Fixed cost to use flow edge
        flowUnitCost %{ordered}  %Cost per unit for each commodity to flow 
        flowAmount %{ordered} %Amount of each commodity that does flow
    end
    
    methods
        function self = FlowEdge(input) 
           %Input := ID sourceFlowNode targetFlowNode grossCapacity flowFixedCost
           if nargin == 0
               % default constructor
           else
               self.instanceID = input(1);
               self.sourceFlowNetworkID = input(2);
               self.targetFlowNetworkID = input(3);
               self.grossCapacity = input(4);
               self.flowFixedCost = input(5);
           end
        end
        
        function setEdgeWeight(self)
           self.Weight = self.calculateEdgeLength;
           if eq(self.Weight,0)
               self.Weight = 1e-6;
           end
        end
        
        function distance = calculateEdgeLength(self)
            if (isempty(self.sourceFlowNetwork.Z) || isempty(self.targetFlowNetwork.Z))
                distance = sqrt(abs(self.sourceFlowNetwork.X - self.targetFlowNetwork.X)^2 + abs(self.sourceFlowNetwork.Y - self.targetFlowNetwork.Y)^2);
            else
                distance = sqrt(abs(self.sourceFlowNetwork.X - self.targetFlowNetwork.X)^2 + abs(self.sourceFlowNetwork.Y - self.targetFlowNetwork.Y)^2 + ...
                    abs(self.sourceFlowNetwork.Z - self.targetFlowNetwork.Z)^2);
            end
            
        end
      
        function flowEdgeStruct = Class2Struct(self)
               flowEdgeStruct = Struct;
        end
    end
    
end

