classdef ProcessNetworkSimEventsBuilder < FlowNetworkSimEventsBuilder
    %PROCESSNETWORKSIMEVENTSBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %^systemElement@self.systemElement
        %^simEventsPath
    end
    
    methods
        function construct(self)
            construct@FlowNetworkSimEventsBuilder;
            self.setProcessTime;
            self.setServerCount;
            self.setTimer;
            self.setStorageCapacity;
        end
        
        function setProcessTime(self)
            %Set the dialog parameters of the event-based random number generator block called ProcessTime. 
            %Needs to be extended to handle random numbers other than normal
            if ~isempty(self.systemElement.ProcessTime_Stdev)
                %Normal Processing Time
                set_param(strcat(self.simEventsPath, '/Process/ProcessTime'), 'Distribution', 'Gaussian (normal)');
                set_param(strcat(self.simEventsPath, '/Process/ProcessTime'), 'meanNorm', num2str(self.systemElement.ProcessTime_Mean));
                set_param(strcat(self.simEventsPath, '/Process/ProcessTime'), 'stdNorm', num2str(self.systemElement.ProcessTime_Stdev));
            else
                %Exponential Processing Time (Markovian Assumptions)
                set_param(strcat(self.simEventsPath, '/Process/ProcessTime'), 'Distribution', 'Exponential');
                set_param(strcat(self.simEventsPath, '/Process/ProcessTime'), 'meanExp', num2str(self.systemElement.ProcessTime_Mean));
            end
        end
        
        function setServerCount(P)
            %Set the dialog parameter NumberofServers of the n-server block called ProcessServer. 
            set_param(strcat(self.simEventsPath, '/Process/ProcessServer'), 'NumberOfServers', num2str(self.systemElement.ServerCount));
        end
        
        function setTimer(P)
            %Set the dialog parameter TimerTag of the timer blocks: start_ProcessTimer & read_ProcessTimer. 
            set_param(strcat(self.simEventsPath, '/Process/start_ProcessTimer'), 'TimerTag', strcat('T_', self.systemElement.name))
            set_param(strcat(self.simEventsPath, '/Process/read_ProcessTimer'), 'TimerTag', strcat('T_', self.systemElement.name))
        end
        
        function setStorageCapacity(P)
            %Set the dialog parameter Capacity of the (FIFO) queue block called ProcessQueue
            set_param(strcat(self.simEventsPath, '/Process/ProcessQueue'), 'Capacity', num2str(self.systemElement.StorageCapacity));
        end
        
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
        
        %metric builders
        function buildUtilization(P)
            %Builder method for recording the utilization of the n-server block called ProcessServer  
            %Utilization of the server, which is the fraction of simulation time spent storing an entity.
            %Update the signal only after each entity departure via the OUT or TO port, and after each entity arrival.
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(self.simEventsPath, '/Process/Utilization_Metric'));
            set_param(metric_block, 'VariableName', strcat('Utilization_', self.systemElement.name), 'Position', [800 25 900 75]);
            add_line(strcat(self.simEventsPath, '/Process'), 'ProcessServer/2', 'Utilization_Metric/1')
        end
        
        function buildThroughput(P)
            %Builder method for recording the throughput of the n-server block called ProcessServer
            %Number of entities that have departed from this block via the OUT port since the start of the simulation.
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(self.simEventsPath, '/Process/Throughput_Metric'));
            set_param(metric_block, 'VariableName', strcat('Throughput_', self.systemElement.name), 'Position', [800 25 900 75]);
            add_line(strcat(self.simEventsPath, '/Process'), 'ProcessServer/1', 'Throughput_Metric/1')
        end
        
        function buildAverageSystemTime(P)
            %Builder method for recording the Average System Time of the Process node
            %Recorded and Output by the timer pair, start_ProcessTimer and read_ProcessTimer
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(self.simEventsPath, '/Process/AverageSystemTime_Metric'));
            set_param(metric_block, 'VariableName', strcat('AverageSystemTime_', self.systemElement.name), 'Position', [800 25 900 75]);
            add_line(strcat(self.simEventsPath, '/Process'), 'read_ProcessTimer/1', 'AverageSystemTime_Metric/1')
        end
        
        function buildAverageWaitingTime(P)
            %Builder method for recording the Average Waiting Time of the Process node as output by the ProcessQueue block
            %Sample mean of the waiting times in this block for all entities that have departed via any port.
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(self.simEventsPath, '/Process/AverageWaitingTime_Metric'));
            set_param(metric_block, 'VariableName', strcat('AverageWaitingTime_', self.systemElement.name), 'Position', [800 25 900 75]);
            add_line(strcat(self.simEventsPath, '/Process'), 'ProcessQueue/1', 'AverageWaitingTime_Metric/1')
        end
        
        function buildAverageQueueLength(P)
            %Builder method for recording the Average Queue Length of the Process node as output by the ProcessQueue block
            %Average number of entities in the queue over time, that is, the time average of the #n signal
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(self.simEventsPath, '/Process/AverageQueueLength_Metric'));
            set_param(metric_block, 'VariableName', strcat('AverageQueueLength_', self.systemElement.name), 'Position', [800 25 900 75]);
            add_line(strcat(self.simEventsPath, '/Process'), 'ProcessQueue/2', 'AverageQueueLength_Metric/1')
        end
    
    end
end

