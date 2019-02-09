function [ ServerCount ] = TH_ff( Model, ProcessSet )
%TH_FF Summary of this function goes here
%   Detailed explanation goes here
        

        try
            d1 = MetricDirector;
            d1.ConstructMetric(ProcessSet, 'Throughput');
            d1.ConstructMetric(ProcessSet, 'Utilization');
        end

        for j = 1:length(ProcessSet)
            ProcessSet(j).ServerCount = 100;
            ProcessSet(j).setServerCount;
        end
        se_randomizeseeds('ProcessModel', 'Mode', 'All', 'Verbose', 'off');
        simOut = sim(Model, 'SaveOutput', 'on');
        
        for j = 1:length(ProcessSet)
            ProcessSet(j).Throughput = simOut.get(strcat('Throughput_', ProcessSet(j).Node_Name));
            TH = ProcessSet(j).Throughput.signals.values(end)/ProcessSet(j).Throughput.time(end);
            %m = \frac{\lambda}{\rho * \mu)
            ProcessSet(j).ServerCount = ceil((TH*ProcessSet(j).ProcessTime_Mean) / (0.975));
            ProcessSet(j).setServerCount;
        end
        
     
        simOut = sim(Model, 'SaveOutput', 'on');
        ServerCount = [];
        for j = 1:length(ProcessSet)
            ProcessSet(j).Utilization = simOut.get(strcat('Utilization_', ProcessSet(j).Node_Name));
            ServerCount(end+1) = ProcessSet(j).ServerCount;
        end
        
        ServerCount
end

