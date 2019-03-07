classdef ProcessNetworkSimEventsBuilder < FlowNetworkSimEventsBuilder
    %PROCESSNETWORKSIMEVENTSBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %^systemElement@self.systemElement
        %^simEventsPath
        
        %control behaviors
        %^routingTypeID = 'probFlow'; 
        %^routingProbability = '[1]';
    end
    
    methods
        function construct(self)
            construct@FlowNetworkSimEventsBuilder(self);
            %self.assignPorts; %@super
            %self.buildPorts; %@super
            %self.buildRoutingControl; %@local
            self.setProcessTime;
            self.setServerCount;
            self.setTimer;
            self.setStorageCapacity;
        end
        
        %function buildProbabilisticRouting(self)
        %    self.routingProbability = self.systemElement.routingProbability;
        %end
        
%         function buildRoutingControl(self)
%            %3/6/19 -- temp copy of method here until ProcessNetwork is completely implemented as a FlowNetwork
%         %Need to move the routing into a strategy class
%         
%            % 1) Build the routing probability as the ratio of outbound flows
%            self.buildProbabilisticRouting;
%            
%            % 2) Check that the probabilities sum to 1 to 5 sig fig
%            probability = round(self.routingProbability*10000);
%            error = 10000 - sum(probability);
%            [Y, I] = max(probability);
%            probability(I) = Y + error;
%            probability = probability/10000;
%             
%            % 3) Convert the array to a "string" for input to SimEvents
%            ValueVector = '[0';
%            ProbabilityVector = '[0';
%            for jj = 1:length(probability)
%                ValueVector = strcat(ValueVector, ',' , num2str(jj));
%                ProbabilityVector = strcat(ProbabilityVector, ',', num2str(probability(jj)));
%            end
%            ValueVector = strcat(ValueVector, ']');
%            ProbabilityVector = strcat(ProbabilityVector, ']');
%            
%            % 4) Set the value in the simevents block named Routing
%            %Note to Self: must set values simultaneously to avoid 'equal length' error
%            set_param(strcat(self.simEventsPath, '/Routing'), 'probVecDisc', ProbabilityVector, 'valueVecDisc', ValueVector);
%        end
        
        function setProcessTime(self)
            %Set the dialog parameters of the event-based random number generator block called ProcessTime. 
            %Needs to be extended to handle random numbers other than normal
            if ~isempty(self.systemElement.ProcessTime_Stdev)
                %Normal Processing Time
                set_param(strcat(self.simEventsPath, '/ProcessTime'), 'Distribution', 'Gaussian (normal)');
                set_param(strcat(self.simEventsPath, '/ProcessTime'), 'meanNorm', num2str(self.systemElement.averageServiceTime));
                set_param(strcat(self.simEventsPath, '/ProcessTime'), 'stdNorm', num2str(self.systemElement.ProcessTime_Stdev));
            else
                %Exponential Processing Time (Markovian Assumptions)
                set_param(strcat(self.simEventsPath, '/ProcessTime'), 'Distribution', 'Exponential');
                set_param(strcat(self.simEventsPath, '/ProcessTime'), 'meanExp', num2str(self.systemElement.averageServiceTime));
            end
        end
        
        function setServerCount(self)
            %Set the dialog parameter NumberofServers of the n-server block called ProcessServer. 
            set_param(strcat(self.simEventsPath, '/ProcessServer'), 'NumberOfServers', num2str(self.systemElement.concurrentProcessingCapacity));
        end
        
        function setTimer(self)
            %Set the dialog parameter TimerTag of the timer blocks: start_ProcessTimer & read_ProcessTimer. 
            set_param(strcat(self.simEventsPath, '/start_ProcessTimer'), 'TimerTag', strcat('T_', self.systemElement.name))
            set_param(strcat(self.simEventsPath, '/read_ProcessTimer'), 'TimerTag', strcat('T_', self.systemElement.name))
        end
        
        function setStorageCapacity(self)
            %Set the dialog parameter Capacity of the (FIFO) queue block called ProcessQueue
            set_param(strcat(self.simEventsPath, '/ProcessQueue'), 'Capacity', num2str(self.systemElement.storageCapacity));
        end
        
        %metric builders
        function buildUtilization(self)
            %Builder method for recording the utilization of the n-server block called ProcessServer  
            %Utilization of the server, which is the fraction of simulation time spent storing an entity.
            %Update the signal only after each entity departure via the OUT or TO port, and after each entity arrival.
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(self.simEventsPath, '/Utilization_Metric'));
            set_param(metric_block, 'VariableName', strcat('Utilization_', self.systemElement.name), 'Position', [800 25 900 75]);
            add_line(self.simEventsPath, 'ProcessServer/2', 'Utilization_Metric/1')
        end
        
        function buildThroughput(self)
            %Builder method for recording the throughput of the n-server block called ProcessServer
            %Number of entities that have departed from this block via the OUT port since the start of the simulation.
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(self.simEventsPath, '/Throughput_Metric'));
            set_param(metric_block, 'VariableName', strcat('Throughput_', self.systemElement.name), 'Position', [800 25 900 75]);
            add_line(self.simEventsPath, 'ProcessServer/1', 'Throughput_Metric/1')
        end
        
        function buildAverageSystemTime(self)
            %Builder method for recording the Average System Time of the Process node
            %Recorded and Output by the timer pair, start_ProcessTimer and read_ProcessTimer
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(self.simEventsPath, '/AverageSystemTime_Metric'));
            set_param(metric_block, 'VariableName', strcat('AverageSystemTime_', self.systemElement.name), 'Position', [800 25 900 75]);
            add_line(self.simEventsPath, 'read_ProcessTimer/1', 'AverageSystemTime_Metric/1')
        end
        
        function buildAverageWaitingTime(self)
            %Builder method for recording the Average Waiting Time of the Process node as output by the ProcessQueue block
            %Sample mean of the waiting times in this block for all entities that have departed via any port.
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(self.simEventsPath, '/AverageWaitingTime_Metric'));
            set_param(metric_block, 'VariableName', strcat('AverageWaitingTime_', self.systemElement.name), 'Position', [800 25 900 75]);
            add_line(self.simEventsPath, 'ProcessQueue/1', 'AverageWaitingTime_Metric/1')
        end
        
        function buildAverageQueueLength(self)
            %Builder method for recording the Average Queue Length of the Process node as output by the ProcessQueue block
            %Average number of entities in the queue over time, that is, the time average of the #n signal
            metric_block = add_block('simeventslib/SimEvents Sinks/Discrete Event Signal to Workspace', strcat(self.simEventsPath, '/AverageQueueLength_Metric'));
            set_param(metric_block, 'VariableName', strcat('AverageQueueLength_', self.systemElement.name), 'Position', [800 25 900 75]);
            add_line(self.simEventsPath, 'ProcessQueue/2', 'AverageQueueLength_Metric/1')
        end
    
    end
end

