classdef Process < FlowNetwork
    %PROCESS Process Node subclass FlowNode from TFN
    %   Captures of Analysis Semantics from M/M/1 and Factory Physics style
    %   analysis use cases
    
    properties
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
%        %function buildPorts(P)
%            if strcmp(P.Type, 'AssyProcess')
%                blockSimEventsPath = get_param(strcat(P.SimEventsPath, '/IN_Job'), 'Position');
%                delete_block(strcat(P.SimEventsPath, '/IN_Job'));
%                add_block('simeventslib/Entity Management/Entity Combiner', strcat(P.SimEventsPath, '/IN_Job'), 'Position', blockSimEventsPath, 'BackgroundColor', 'Cyan');
%            elseif strcmp(P.Type, 'SourceSinkProcess')
%                blockSimEventsPath = get_param(strcat(P.SimEventsPath, '/OUT_Job'), 'Position');
%                delete_block(strcat(P.SimEventsPath, '/OUT_Job'));
%               add_block('simeventslib/Routing/Replicate', strcat(P.SimEventsPath, '/OUT_Job'), 'Position', blockSimEventsPath, 'BackgroundColor', 'Cyan');
%            end
%             buildPorts@FlowNode(P);
%         end %redefines{Node.buildPorts}
        
        function buildTokenRouting(P)
            % Needs to be moved to a strategy class
            % Needs to be moved to the flow node/edge layer
            
                %Check that the probabilities, when converted to 5 sig fig by num2str,
                %add up to one
               probability = round(P.routingProbability*10000);
               error = 10000 - sum(probability);
               [Y, I] = max(probability);
               probability(I) = Y + error;
               probability = probability/10000;

               ValueVector = '[0';
               ProbabilityVector = '[0';
               for ii = 1:length(probability)
                   ValueVector = strcat(ValueVector, ',' , num2str(ii));
                   ProbabilityVector = strcat(ProbabilityVector, ',', num2str(probability(ii)));
               end
               
               ValueVector = strcat(ValueVector, ']');
               ProbabilityVector = strcat(ProbabilityVector, ']');

               set_param(strcat(P.SimEventsPath, '/Process/Routing'), 'probVecDisc', ProbabilityVector, 'valueVecDisc', ValueVector);
        end
        
        function decorateNode(P)
            decorateNode@FlowNetwork(P);
            P.setProcessTime;
            P.setServerCount;
            P.setTimer;
            P.setStorageCapacity;
            P.buildTokenRouting;
        end
        
        function setProcessTime(P)
            %Set the dialog parameters of the event-based random number generator block called ProcessTime. 
            %Needs to be extended to handle random numbers other than normal
            if isempty(P.ProcessTime_Stdev) == 0
                %Normal Processing Time
                set_param(strcat(P.SimEventsPath, '/Process/ProcessTime'), 'Distribution', 'Gaussian (normal)');
                set_param(strcat(P.SimEventsPath, '/Process/ProcessTime'), 'meanNorm', num2str(P.ProcessTime_Mean));
                set_param(strcat(P.SimEventsPath, '/Process/ProcessTime'), 'stdNorm', num2str(P.ProcessTime_Stdev));
            else
                %Exponential Processing Time (Markovian Assumptions)
                set_param(strcat(P.SimEventsPath, '/Process/ProcessTime'), 'Distribution', 'Exponential');
                set_param(strcat(P.SimEventsPath, '/Process/ProcessTime'), 'meanExp', num2str(P.ProcessTime_Mean));
            end
        end
        
        function setServerCount(P)
            %Set the dialog parameter NumberofServers of the n-server block called ProcessServer. 
            set_param(strcat(P.SimEventsPath, '/Process/ProcessServer'), 'NumberOfServers', num2str(P.ServerCount));
        end
        
        function setTimer(P)
            %Set the dialog parameter TimerTag of the timer blocks: start_ProcessTimer & read_ProcessTimer. 
            set_param(strcat(P.SimEventsPath, '/Process/start_ProcessTimer'), 'TimerTag', strcat('T_', P.Name))
            set_param(strcat(P.SimEventsPath, '/Process/read_ProcessTimer'), 'TimerTag', strcat('T_', P.Name))
        end
        
        function setStorageCapacity(P)
            %Set the dialog parameter Capacity of the (FIFO) queue block called ProcessQueue
            set_param(strcat(P.SimEventsPath, '/Process/ProcessQueue'), 'Capacity', num2str(P.StorageCapacity));
        end
        
        %metric builders
        function buildUtilization(P)
            %Builder method for recording the utilization of the n-server block called ProcessServer  
            %Utilization of the server, which is the fraction of simulation time spent storing an entity.
            %Update the signal only after each entity departure via the OUT or TO port, and after each entity arrival.
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(P.SimEventsPath, '/Process/Utilization_Metric'));
            set_param(metric_block, 'VariableName', strcat('Utilization_', P.Name), 'Position', [800 25 900 75]);
            add_line(strcat(P.SimEventsPath, '/Process'), 'ProcessServer/2', 'Utilization_Metric/1')
        end
        
        function buildThroughput(P)
            %Builder method for recording the throughput of the n-server block called ProcessServer
            %Number of entities that have departed from this block via the OUT port since the start of the simulation.
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(P.SimEventsPath, '/Process/Throughput_Metric'));
            set_param(metric_block, 'VariableName', strcat('Throughput_', P.Name), 'Position', [800 25 900 75]);
            add_line(strcat(P.SimEventsPath, '/Process'), 'ProcessServer/1', 'Throughput_Metric/1')
        end
        
        function buildAverageSystemTime(P)
            %Builder method for recording the Average System Time of the Process node
            %Recorded and Output by the timer pair, start_ProcessTimer and read_ProcessTimer
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(P.SimEventsPath, '/Process/AverageSystemTime_Metric'));
            set_param(metric_block, 'VariableName', strcat('AverageSystemTime_', P.Name), 'Position', [800 25 900 75]);
            add_line(strcat(P.SimEventsPath, '/Process'), 'read_ProcessTimer/1', 'AverageSystemTime_Metric/1')
        end
        
        function buildAverageWaitingTime(P)
            %Builder method for recording the Average Waiting Time of the Process node as output by the ProcessQueue block
            %Sample mean of the waiting times in this block for all entities that have departed via any port.
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(P.SimEventsPath, '/Process/AverageWaitingTime_Metric'));
            set_param(metric_block, 'VariableName', strcat('AverageWaitingTime_', P.Name), 'Position', [800 25 900 75]);
            add_line(strcat(P.SimEventsPath, '/Process'), 'ProcessQueue/1', 'AverageWaitingTime_Metric/1')
        end
        
        function buildAverageQueueLength(P)
            %Builder method for recording the Average Queue Length of the Process node as output by the ProcessQueue block
            %Average number of entities in the queue over time, that is, the time average of the #n signal
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(P.SimEventsPath, '/Process/AverageQueueLength_Metric'));
            set_param(metric_block, 'VariableName', strcat('AverageQueueLength_', P.Name), 'Position', [800 25 900 75]);
            add_line(strcat(P.SimEventsPath, '/Process'), 'ProcessQueue/2', 'AverageQueueLength_Metric/1')
        end
        
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
            P.FlowEdgeSet = edgeSet;
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

