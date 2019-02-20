classdef Port < handle
    %Ports are points at which external entities can connect to and interact with a block
    %Derived from the SysML construct outlined in Section 9 of SysML 1.3
    
    %In this case, the Port classdef functions both as the class object and
    %the creator class at the same time. Sorry Future Tim
    
    properties
        name
        owner@FlowNetwork
        typeID 
        direction % IN or OUT
        side % Left or Right
        number %Port number relative to all ports in owner
        conn %LConn#/RConn# assignment
        incidentEdge%@FlowEdge
        simEventsPath
    end %properties
    
    methods        
        function setPosition(self)
            if strcmp(self.side, 'Right') ==1
                set_param(self.simEventsPath, 'BlockMirror', 'on')
                position = get_param(self.simEventsPath, 'Position');
                count = str2num(self.name(end))-1;
                position = [position(3) + 100, position(2) + 40*count, position(3) + 130, position(2)  + 40*count+15];
                set_param(self.simEventsPath, 'Position', position);
            else
                position = get_param(self.simEventsPath, 'Position');
                count = str2num(self.name(end))-1;
                position = [position(1) - 130, position(2) + 40*count, position(1) - 100, position(2)  + 40*count+15];
                set_param(self.simEventsPath, 'Position', position);
            end %left/right
        end %set_location method
        
        function setSide(self)
            %Decide which side the port should be on
            %Eventually should be replaced with a lookup-table
            if strcmp(self.direction, 'IN') == 1
                self.side = 'Left';
            else
                self.side = 'Right';
            end %direction_if
        end %set_side
        
        function setPortNum(self)
            set_param(self.simEventsPath, 'Port', num2str(self.number));
            set_param(self.simEventsPath, 'side', self.side);
        end
        
    end %methods
    
end %classdef

