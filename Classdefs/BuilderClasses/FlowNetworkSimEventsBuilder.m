classdef FlowNetworkSimEventsBuilder <IFlowNetworkBuilder
    %FLOWNETWORKSIMULATIONBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %systemElement@self.systemElement
        portSet %A set of port classes that define the node interface
        edgeTypeIDSet
        echelon = 1
        position
        simEventsPath %The associated SimEvents block identifier >> CHANGED ON 1/22/15; expect errors
        
        %control behaviors
        routingTypeID = 'probFlow'; 
        routingProbability = '[1 0]';
    end
    
    methods (Access = public)
        function construct(self)
            self.assignPorts;
            self.buildPorts;
            self.buildRoutingControl;
        end
        
       function assignPorts(self)
            %Assigns LConn and RConn port numbers to incoming/outgoing
            %edges respectively
            
            %% Create ports for IN Flow Edges
            typeID = {};
            typeCount = [];
            self.portSet = Port.empty(0);
            for ii = 1:length(self.systemElement.inFlowEdgeSet)
                self.portSet(end+1) = Port;
                self.portSet(end).owner = self.systemElement;
                self.portSet(end).incidentEdge = self.systemElement.inFlowEdgeSet(ii);
                self.portSet(end).typeID = self.systemElement.inFlowEdgeSet(ii).typeID;
                self.portSet(end).direction = 'in';
                self.portSet(end).setSide;
                self.portSet(end).number = ii;
                self.portSet(end).conn = strcat('LConn', num2str(ii));
                self.systemElement.inFlowEdgeSet(ii).endNetwork2Port = self.portSet(end);
                
                isType = ismember(typeID, self.portSet(end).typeID);
                if any(isType)
                    typeCount(isType) = typeCount(isType) + 1;
                    self.portSet(end).name = strcat('in', typeID{isType},'_', num2str(typeCount(isType)));
                else
                    typeID{end+1} = self.portSet(end).typeID;
                    typeCount(end+1) = 1;
                    self.portSet(end).name = strcat('in', typeID{end},'_1');
                end
            end
            
            %if there are no incoming edges, the i needs to be 0 instead of
            %an empty double, which f's up the indexing
            ii = length(self.systemElement.inFlowEdgeSet);
            
            %% Create ports for OUT Flow Edges
            typeCount = zeros(length(typeID),1);
            
            for jj = 1:length(self.systemElement.outFlowEdgeSet)
                self.portSet(end+1) = Port;
                self.portSet(end).owner = self.systemElement;
                self.portSet(end).incidentEdge = self.systemElement.outFlowEdgeSet(jj);
                self.portSet(end).typeID = self.systemElement.outFlowEdgeSet(jj).typeID;
                self.portSet(end).direction = 'out';
                self.portSet(end).setSide;
                self.portSet(end).number = ii + jj;
                self.portSet(end).conn = strcat('RConn', num2str(jj));
                self.systemElement.outFlowEdgeSet(jj).endNetwork1Port = self.portSet(end);
                
                isType = ismember(typeID, self.portSet(end).typeID);
                if any(isType)
                    typeCount(isType) = typeCount(isType) + 1;
                    self.portSet(end).name = strcat('out', typeID{isType},'_', num2str(typeCount(isType)));
                else
                    typeID{end+1} = self.portSet(end).typeID;
                    typeCount(end+1) = 1;
                    self.portSet(end).name = strcat('out', typeID{end},'_1');
                end
            end
            self.edgeTypeIDSet = typeID;
            
        end %assignPorts function
        
       function buildPorts(self)
            % 7/8/16 -- Fix bug to handle nodes with zero ports in or out,
            % e.g. source or sink nodes.
            
            for ii = 1:length(self.edgeTypeIDSet)
                %IN
                inPortSet = findobj(self.portSet, 'typeID', self.edgeTypeIDSet{ii}, '-and', 'direction', 'in');
                if ~isempty(inPortSet)
                        %INset = findobj(N.INEdgeSet, 'EdgeType', N.EdgeTypeSet{i});
                    set_param(strcat(self.simEventsPath, '/IN_', self.edgeTypeIDSet{ii}), 'NumberInputPorts', num2str(length(inPortSet)));
 
                    for jj = 1:length(inPortSet) %For Each edge in INset build port
                        try
                            inPortSet(jj).simEventsPath = strcat(self.simEventsPath, '/', inPortSet(jj).name);
                            add_block('simeventslib/SimEvents Ports and Subsystems/Conn', inPortSet(jj).simEventsPath);
                            set_param(inPortSet(jj).simEventsPath, 'Port', num2str(inPortSet(jj).number));
                            set_param(inPortSet(jj).simEventsPath, 'Side', inPortSet(jj).side);
                            inPortSet(jj).setPosition
                            add_line(strcat(self.model, '/', self.systemElement.name), strcat('IN_', inPortSet(jj).typeID, '/LConn', num2str(jj)), ...
                            strcat(inPortSet(jj).name,'/RConn1'), 'autorouting', 'on');
                        catch err
                            continue
                        end
                    end
                end
                
                
                %OUT
                outPortSet = findobj(self.portSet, 'typeID', self.edgeTypeIDSet{ii}, '-and', 'direction', 'out');
                if ~isempty(outPortSet)
                    set_param(strcat(self.simEventsPath, '/OUT_', self.portSet(ii).typeID), 'NumberOutputPorts', num2str(length(outPortSet)));
               
                    for jj = 1:length(outPortSet) %For Each edge in outPortSet build port
                        try
                            outPortSet(jj).simEventsPath = strcat(self.simEventsPath, '/', outPortSet(jj).name);
                            add_block('simeventslib/SimEvents Ports and Subsystems/Conn', outPortSet(jj).simEventsPath);
                            set_param(outPortSet(jj).simEventsPath, 'Port', num2str(outPortSet(jj).number));
                            set_param(outPortSet(jj).simEventsPath, 'Side', outPortSet(jj).side);
                            outPortSet(jj).setPosition
                            add_line(strcat(self.model, '/', self.systemElement.name), strcat('OUT_', outPortSet(jj).typeID, '/RConn', num2str(jj)), ...
                            strcat(outPortSet(jj).name,'/RConn1'), 'autorouting', 'on');
                        catch err
                            rethrow(err)
                            %continue
                        end
                    end 
                end %End: Check if outPortSet is empty
            end %End: For each type of Edge

        end %Role: ConcreteBuilder of Ports 
        
       function buildRoutingControl(self)
        %Need to move the routing into a strategy class
        if strcmp(self.routingTypeID, 'probFlow') ==1
           % 1) Build the routing probability as the ratio of outbound flows
           self.buildProbabilisticRouting;
           
           % 2) Check that the probabilities sum to 1 to 5 sig fig
           probability = round(self.routingProbability*10000);
           error = 10000 - sum(probability);
           [Y, I] = max(probability);
           probability(I) = Y + error;
           probability = probability/10000;
            
           % 3) Convert the array to a "string" for input to SimEvents
           ValueVector = '[0';
           ProbabilityVector = '[0';
           for jj = 1:length(probability)
               ValueVector = strcat(ValueVector, ',' , num2str(jj));
               ProbabilityVector = strcat(ProbabilityVector, ',', num2str(probability(jj)));
           end
           ValueVector = strcat(ValueVector, ']');
           ProbabilityVector = strcat(ProbabilityVector, ']');
           
           % 4) Set the value in the simevents block named Routing
           %Note to Self: must set values simultaneously to avoid 'equal length' error
           set_param(strcat(self.simEventsPath, '/Routing'), 'probVecDisc', ProbabilityVector, 'valueVecDisc', ValueVector);
        elseif strcmp(self.routingTypeID, 'equiprobable') == 1
            
            % 1) Build the routing probability equally across outbound flows
            outFlowEdgeCount = length(self.systemElement.outFlowEdgeSet);
            self.routingProbability = ones(outFlowEdgeCount,1)./outFlowEdgeCount;
            
            % 2) Check that the probabilities sum to 1 to 5 sig fig
               probability = round(self.routingProbability*10000);
               error = 10000 - sum(probability);
               [Y, I] = max(probability);
               probability(I) = Y + error;
               probability = probability/10000;
               
            % 3) Convert the array to a "string" for input to SimEvents
               ValueVector = '[0';
               ProbabilityVector = '[0';
               for jj = 1:length(probability)
                   ValueVector = strcat(ValueVector, ',' , num2str(jj));
                   ProbabilityVector = strcat(ProbabilityVector, ',', num2str(probability(jj)));
               end
               ValueVector = strcat(ValueVector, ']');
               ProbabilityVector = strcat(ProbabilityVector, ']');

           % 4) Set the value in the simevents block named Routing
           %Note to Self: must set values simultaneously to avoid 'equal length' error
               set_param(strcat(self.simEventsPath, '/Routing'), 'probVecDisc', ProbabilityVector, 'valueVecDisc', ValueVector);
            
        else %if strcmp(self.routingTypeID, 'plannedRoute')
            shipment_destination = findobj(self.systemElement.outFlowEdgeSet, 'typeID', 'Shipment');
            routingLookupTable = '[';

            for ii = 1:length(shipment_destination)
                %shipment_destination(ii).targetFlowNetwork is a transportation channel
                if eq(shipment_destination(ii).targetFlowNetwork.source.instanceID, self.systemElement.instanceID)
                    routingLookupTable = strcat(routingLookupTable,',', num2str(shipment_destination(ii).targetFlowNetwork.target));
                else
                    routingLookupTable = strcat(routingLookupTable,',', num2str(shipment_destination(ii).targetFlowNetwork.source));
                end
            end
            routingLookupTable = strcat('[',routingLookupTable(3:end), ']');

            set_param(strcat(self.simEventsPath, '/Lookup'), 'Value', routingLookupTable);
            set_param(strcat(self.simEventsPath, '/Node_ID'), 'Value', num2str(self.systemElement.instanceID));
        end
       end
       
    end
    
    methods (Access = private)
       function route = buildCommodityRoute(self, commodityflowSolution)
        %Commodity_Route is a set of arcs that the commodity flows on
        %need to assemble the arcs into a route or path
            ii = 1;
            route = commodityflowSolution(ii,1:2);
            while sum(commodityflowSolution(:,1) == commodityflowSolution(ii,2))>0
                ii = find(commodityflowSolution(:,1) == commodityflowSolution(ii,2));
                if eq(commodityflowSolution(ii,4),0)==0
                    route = [route, commodityflowSolution(ii,2)];
                end
            end
            %NOTE: Need a better solution to '10', it should be 2+numDepot
            while length(route)<6
                route = [route, 0];
            end
       end  %end build commodity route 
   
       function buildProbabilisticRouting(self)
            flowNode = self.systemElement;
            totalOutflow = 0;
            edgeflowAmount = [];
            for kk = 1:length(flowNode.outFlowEdgeSet)
                edgeflowAmount(end+1) = sum(flowNode.outFlowEdgeSet(kk).flowAmount);
                totalOutflow = totalOutflow + edgeflowAmount(end);
            end
            if totalOutflow ~= 0
                self.routingProbability = edgeflowAmount./totalOutflow; 
            elseif isempty(flowNode.outFlowEdgeSet)
                    self.routingProbability = [1 0];
            else
                %default to equiprobable case.
                self.routingProbability = ones(length(flowNode.outFlowEdgeSet),1)./length(flowNode.outFlowEdgeSet);
            end
        end
    end
end


