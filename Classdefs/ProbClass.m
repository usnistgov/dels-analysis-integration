classdef ProbClass < handle
    %PROBCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        meanCost
        stdevCost
    end
    
    methods
        function C = Cost(self)
            C = normrnd(self.meanCost, self.stdevCost);
        end
    end
    
end

