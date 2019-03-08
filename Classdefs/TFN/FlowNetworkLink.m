classdef FlowNetworkLink < NetworkLink
    %FLOWEDGE Summary of this class goes here
    %   flow edges are directed
    
    properties
        %^instanceID
        %^typeID
        %^endNetwork1ID %ID of origin network
        %^endNetwork1@Network
        %^endNetwork2ID %ID of destination network
        %^endNetwork2@Network
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
        
        %To be private or deprecated:
        endNetwork1Port@Port
        endNetwork2Port@Port
    end
    
    methods
        function self = FlowNetworkLink(input) 
           %Input := ID sourceFlowNode targetFlowNode grossCapacity flowFixedCost
           if nargin == 0
               % default constructor
           elseif nargin ==3
               self.instanceID = input(1);
               self.sourceFlowNetworkID = input(2);
               self.targetFlowNetworkID = input(3);
           else
               self.instanceID = input(1);
               self.sourceFlowNetworkID = input(2);
               self.targetFlowNetworkID = input(3);
               self.grossCapacity = input(4);
               self.flowFixedCost = input(5);
           end
        end
        
        function setEdgeWeight(self)
           self.weight = self.calculateEdgeLength;
           if eq(self.weight,0)
               self.weight = 1e-6;
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
    end
    
end

