classdef MetricDirector
    %METRICDIRECTOR: Director Role configured with Node classes as Builders
    %Notifies the Builder class which metrics it needs to build in the
    %corresponding SimEvents node
    
    properties
    end
    
    methods
        function ConstructMetric(Director, NodeSet, MetricName)
            for i = 1:length(NodeSet)
                eval(strcat('NodeSet(i).build', MetricName))
            end %for each node in nodeset
        end %end Construct() Method
    end %end methods

end %classdef

