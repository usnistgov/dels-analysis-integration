classdef Process < FlowNetwork
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
        ProcessStep@Process
        SequenceDependencySet@SequencingDependency
        
        %Behavioral Parameters %Abstraction of PPRF
        ServerCount
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
            ProcessStep = mapProcessArray2Class(P.probabilityTransitionMatrix, P.ServerCount, P.serviceTime);
            edgeSet = mapProbMatrix2EdgeSet(P.probabilityTransitionMatrix);

            [arrivalProcess, arrivalEdgeSet] = mapArrivals2ArrivalProcessNode(ProcessStep, edgeSet, P.productArrivalRate, P.processPlanSet);
            %Add arrivalProcess to process Set
            edgeSet(end+1:end+length(arrivalEdgeSet))= arrivalEdgeSet;
            ProcessStep(end+1) = arrivalProcess;


            [departureProcess, departureEdgeSet] = mapDepartures2DepartureProcessNode(ProcessStep, edgeSet, P.probabilityTransitionMatrix);
            %Add departureProcessNode to ProcessNode Set;
            edgeSet(end+1:end+length(departureEdgeSet))= departureEdgeSet;
            ProcessStep(end+1) = departureProcess;
            
            P.ProcessStep = ProcessStep;
            P.flowEdgeSet = edgeSet;
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

