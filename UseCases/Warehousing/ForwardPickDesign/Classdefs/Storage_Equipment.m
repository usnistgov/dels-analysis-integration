classdef Storage_Equipment < handle
    %STORAGE_EQUIPMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID
        storage_height % in openings
        opening_width = 3.33; % in feet
        opening_length = 4; % in feet
        opening_height = 4; % in feet
        fixed_cost = 75; % in $ per opening (from "Rules of Thumb" - Standard Selective Pallet Rack)
    end
    
    methods
        function [seqSet,idx]=sort(seqSet,varargin)
            [~,idx]=sort([seqSet.storage_height],varargin{:});
            seqSet=seqSet(idx);
        end
        
        function newSE = Copy(SE)
        % Make a copy of a handle object.    
            
            % Instantiate new object of the same class.
            newSE = feval(class(SE));
 
            % Copy all non-hidden properties.
            p = properties(SE);
            for i = 1:length(p)
                newSE.(p{i}) = SE.(p{i});
            end
        end
        
    end
    
end

