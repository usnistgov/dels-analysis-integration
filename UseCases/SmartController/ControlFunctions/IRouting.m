classdef (Abstract) IRouting
    %IROUTING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

    end
    
    methods (Abstract)
        [nextNode] = Routing(inTask)
    end
end

