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
        
        incomingSeqDep@SequencingDependency
        outgoingSeqDep@SequencingDependency
        %Hierarchical Organization
        parentProcessNetwork@ProcessNetwork
        processStep@ProcessNetwork
        SequenceDependencySet@SequencingDependency
        
        %Behavioral Parameters %Abstraction of PPRF
        concurrentProcessingCapacity %3/3/19 -- replaces concurrentProcessingCapacity
        expectedDuration %to replace process time
        StorageCapacity
        ProcessTime_Mean
        ProcessTime_Stdev
        routingProbability
        %Performance Measures
        Utilization %Stored as Data structure, not single point
        Throughput %Stored as Data structure, not single point
        AverageSystemTime %Stored as Data structure, not single point
        AverageWaitingTime %Stored as Data structure, not single point
        AverageQueueLength %Stored as Data structure, not single point
        


        SequenceDependencyMatrix
        probabilityTransitionMatrix
        serviceTime
        
        productArrivalRate
        processPlanSet
        processArrivalRate
    end
    
    methods
       
        function matrix2Network(P)
            processStep = mapProcessArray2Class(P.probabilityTransitionMatrix, P.concurrentProcessingCapacity, P.serviceTime);
            flowEdgeSet = mapProbMatrix2EdgeSet(P.probabilityTransitionMatrix);
            
            
            %2) aggregate all arrivals to the process network into one (new) arrival process node (a source node)
            [arrivalProcess, arrivalFlowEdgeSet] = mapArrivals2ArrivalProcessNode(processStep, flowEdgeSet, P.productArrivalRate, P.processPlanSet);
            %Add arrivalProcess to process Set
            flowEdgeSet(end+1:end+length(arrivalFlowEdgeSet))= arrivalFlowEdgeSet;
            processStep(end+1) = arrivalProcess;

            
            %3) aggregate all departures from the process network into one (new) departure process node (a sink node)
            [departureProcess, departureFlowEdgeSet] = mapDepartures2DepartureProcessNode(processStep, flowEdgeSet, P.probabilityTransitionMatrix);
            %Add departureProcessNode to ProcessNode Set;
            flowEdgeSet(end+1:end+length(departureFlowEdgeSet))= departureFlowEdgeSet;
            processStep(end+1) = departureProcess;
            
            %4) With all new process steps and flow edges, create necessary connectors/references 
            for ii = 1:length(processStep)
                processStep(ii).addEdge(flowEdgeSet); 
                
                for jj = 1:length(processStep(ii).inFlowEdgeSet)
                    processStep(ii).inFlowEdgeSet(jj).targetFlowNetwork = processStep(ii);
                end
                
                for jj = 1:length(processStep(ii).outFlowEdgeSet)
                    processStep(ii).outFlowEdgeSet(jj).sourceFlowNetwork = processStep(ii);
                end
                
                processStep(ii).parentProcessNetwork = P;
            end
            
            
            P.processStep = processStep;
            P.flowNodeSet{1} = processStep;
            P.flowEdgeSet = flowEdgeSet;
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

