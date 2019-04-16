classdef (Abstract) ISequencing
    %ISEQUENCING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Abstract)
        [idx, availableTasks] = Sequencing(availableTasks)
    end
end

