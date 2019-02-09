classdef Pick_Equipment < handle
    %PICK_EQUIPMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID
        reachable_height % in openings
        req_aisle_width = 10; % in feet
        capacity = 3 % max number of batches
        vertical_velocity = 65/60; % in f.p.s.
        vertical_acc = 6; % in f.p.s^2
        horizontal_velocity = 300/60; % in f.p.s.
        horizontal_acc = 10; % in f.p.s^2
        fixed_cost = 39000; % in $ per equipment (from "Rules of Thumb" - Order Picker Truck)
        variable_cost = 12 * 1.5; % loaded cost, in $/hr
    end
    
    methods
        function [peqSet,idx]=sort(peqSet,varargin)
            %[~,idx]=sort([peqSet.horizontal_velocity], varargin{:});
            %peqSet=peqSet(idx);
            %[~,idx]=sort([peqSet.req_aisle_width], varargin{:});
            %peqSet=peqSet(idx);
            [~,idx]=sort([peqSet.capacity], varargin{:});
            peqSet=peqSet(idx);
        end
        
        function newPE = Copy(PE)
        % Make a copy of a handle object.    
            
            % Instantiate new object of the same class.
            newPE = feval(class(PE));
 
            % Copy all non-hidden properties.
            p = properties(PE);
            for i = 1:length(p)
                newPE.(p{i}) = PE.(p{i});
            end
        end
        
    end
    
end

