classdef ProcessNetwork < FlowNetwork
    %PROCESS Process Node subclass FlowNode from TFN
    %   Captures of Analysis Semantics from M/M/1 and Factory Physics style
    %   analysis use cases
    
    properties
        %^name
        %^instanceID
        %^X
        %^Y
        %^Z
        %flowNodeList % [instanceID, X, Y]
        %flowNodeSet  %NodeSet@flowNetwork %Use set method to "override" and type check for flow Network
        %flowEdgeList %[instanceID sourceflowNode targetflowNode grossCapacity flowFixedCost]
        %flowEdgeSet % flow edges within the flow network
        %inFlowEdgeSet@FlowNetworkLink %A set of flow edges incoming to the flow network
        %outFlowEdgeSet@FlowNetworkLink %A set of flow edges outgoing to the flow network
        %builder %lightweight delegate to builderClass for constructing simulation 
        
        %^produces
        %^consumes
        %^productionRate
        %^consumptionRate
        
        incomingSeqDep@SequencingDependency %{subset edges}
        outgoingSeqDep@SequencingDependency %{subset edges}
        sequenceDependencySet@SequencingDependency %(internal between owned processNodes)
        %Hierarchical Organization
        parentProcessNetwork@ProcessNetwork
        processNodeSet %= {@ProcessNetwork} 
        routingProbability
        
        
        %Behavioral Parameters %Abstraction of PPRF
        concurrentProcessingCapacity %3/3/19 -- replaces ServerCount
        averageServiceTime %expected service time
        storageCapacity
        ProcessTime_Mean
        ProcessTime_Stdev
        
        %Performance Measures
        utilization %Stored as Data structure, not single point
        throughput %Stored as Data structure, not single point
        averageSystemTime %Stored as Data structure, not single point
        averageWaitingTime %Stored as Data structure, not single point
        averageQueueLength %Stored as Data structure, not single point
        
        %Queuing Network Representation
        probabilityTransitionMatrix
        externalArrivalRate
        processPlanList
        productArrivalRate
    end
    
    methods
        
        function setProcessNodeSet(self, input)
            if isa(input, 'ProcessNetwork')
               % processNodes are a subset of flowNodes; we have enforce subsetting 
               % via set methods.
               successFlag = 0;
               for ii = 1:length(self.processNodeSet)
                    if strcmp(class(self.processNodeSet{ii}), class(input))
                        self.processNodeSet{ii}(end+1) = input;
                        successFlag = 1;
                        break;
                    end
               end
               if successFlag ==0
                   self.processNodeSet{end+1} = input;
               end
               
               self.setFlowNodeSet(input);
            end
        end
       
        function matrix2Network(self)
            %1)
            processNodeSet = self.processNodeSet{1};
            flowEdgeSet = self.flowEdgeSet;
            
            
            %2) aggregate all arrivals to the process network into one (new) arrival process node (a source node)
            [arrivalProcess, arrivalFlowEdgeSet] = mapArrivals2ArrivalProcessNode(processNodeSet, flowEdgeSet, self.productArrivalRate, self.processPlanList);
            %Add arrivalProcess to process Set
            flowEdgeSet(end+1:end+length(arrivalFlowEdgeSet))= arrivalFlowEdgeSet;
            processNodeSet(end+1) = arrivalProcess;

            
            %3) aggregate all departures from the process network into one (new) departure process node (a sink node)
            [departureProcess, departureFlowEdgeSet] = mapDepartures2DepartureProcessNode(processNodeSet, flowEdgeSet, self.probabilityTransitionMatrix);
            %Add departureProcessNode to ProcessNode Set;
            flowEdgeSet(end+1:end+length(departureFlowEdgeSet))= departureFlowEdgeSet;
            processNodeSet(end+1) = departureProcess;
                        
            %4) With all new process steps and flow edges, create necessary connectors/references 
            
            for ii = 1:length(processNodeSet)
                processNodeSet(ii).addEdge(flowEdgeSet); 
                
                for jj = 1:length(processNodeSet(ii).inFlowEdgeSet)
                    processNodeSet(ii).inFlowEdgeSet(jj).targetFlowNetwork = processNodeSet(ii);
                end
                
                for jj = 1:length(processNodeSet(ii).outFlowEdgeSet)
                    processNodeSet(ii).outFlowEdgeSet(jj).sourceFlowNetwork = processNodeSet(ii);
                end
                
                processNodeSet(ii).parentProcessNetwork = self;
            end
            
            self.processNodeSet{1} = processNodeSet;
            self.flowNodeSet{1} = processNodeSet;
            self.flowEdgeSet = flowEdgeSet;
        end
        
        function [varargout] = plot(P)
            % Visualize the Process Network
            %Use Graph Toolbox to visualize graph
            A = digraph(P.probabilityTransitionMatrix);
            plot(A);
            h = gcf;
            axesObjs = get(h, 'Children');
            dataObjs = get(axesObjs, 'Children');
            xdata = get(dataObjs, 'XData');
            ydata = get(dataObjs, 'YData');
            label = get(dataObjs, 'NodeLabel'); 
            varargout = [xdata, ydata, label];
        end
    end

end

