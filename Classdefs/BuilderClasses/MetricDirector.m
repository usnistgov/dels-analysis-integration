classdef MetricDirector
    %METRICDIRECTOR: Director Role configured with Node classes as Builders
    %Notifies the Builder class which metrics it needs to build in the
    %corresponding SimEvents node
    
    properties
    end
    
    methods
        function ConstructMetric(~, flowNodeBuilderSet, metricName)
            for ii = 1:length(flowNodeBuilderSet)
                eval(strcat('flowNodeBuilderSet(ii).build', metricName))
            end %for each node in nodeset
        end %end Construct() Method
    end %end methods

end %classdef

