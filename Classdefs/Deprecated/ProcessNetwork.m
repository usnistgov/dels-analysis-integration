classdef ProcessNetwork < Network
    %PROCESSNETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SequenceDependencySet@SequencingDependency
        ProcessSet@Process
        %EdgeSet@Edge %Should be flow edge set
        SequenceDependencyMatrix
        
        
        probabilityTransitionMatrix
        machineCount
        serviceTime
        productArrivalRate
        processPlanSet
        processArrivalRate
    end
    
    methods
        function network2Matrix(PN)
        end
        
        function matrix2Network(PN)
            processSet = mapProcessArray2Class(PN.probabilityTransitionMatrix, PN.machineCount, PN.serviceTime);
            edgeSet = mapProbMatrix2EdgeSet(PN.probabilityTransitionMatrix);

            [arrivalProcess, arrivalEdgeSet] = mapArrivals2ArrivalProcessNode(processSet, edgeSet, PN.productArrivalRate, PN.processPlanSet);
            %Add arrivalProcess to process Set
            edgeSet(end+1:end+length(arrivalEdgeSet))= arrivalEdgeSet;
            processSet(end+1) = arrivalProcess;


            [departureProcess, departureEdgeSet] = mapDepartures2DepartureProcessNode(processSet, edgeSet, PN.probabilityTransitionMatrix);
            %Add departureProcessNode to ProcessNode Set;
            edgeSet(end+1:end+length(departureEdgeSet))= departureEdgeSet;
            processSet(end+1) = departureProcess;
            
            PN.ProcessSet = processSet;
            PN.EdgeSet = edgeSet;
        end
        
        function [varargout] = plot(PN)
            % Visualize the Process Network
            %Use Graph Toolbox to visualize graph
            A = digraph(PN.probabilityTransitionMatrix);
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

