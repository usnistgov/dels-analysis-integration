classdef Port < handle
    %Ports are points at which external entities can connect to and interact with a block
    %Derived from the SysML construct outlined in Section 9 of SysML 1.3
    
    %In this case, the Port classdef functions both as the class object and
    %the creator class at the same time. Sorry Future Tim
    
    properties
        Port_Name
        Owner@Node
        Type 
        Direction % IN or OUT
        Side % Left or Right
        Number %Port Number relative to all ports in owner
        Conn %LConn#/RConn# assignment
        Incident_Edge@Edge
        SimEventsPath
    end %properties
    
    methods        
        function Set_Position(P)
            if strcmp(P.Side, 'Right') ==1
                set_param(P.SimEventsPath, 'BlockMirror', 'on')
                position = get_param(strcat(P.Owner.SimEventsPath, '/', P.Direction, '_', P.Type), 'Position');
                count = str2num(P.Port_Name(end))-1;
                position = [position(3) + 100, position(2) + 40*count, position(3) + 130, position(2)  + 40*count+15];
                set_param(strcat(P.Owner.SimEventsPath, '/', P.Port_Name), 'Position', position);
            else
                position = get_param(strcat(P.Owner.SimEventsPath, '/', P.Direction, '_', P.Type), 'Position');
                count = str2num(P.Port_Name(end))-1;
                position = [position(1) - 130, position(2) + 40*count, position(1) - 100, position(2)  + 40*count+15];
                set_param(P.SimEventsPath, 'Position', position);
            end %left/right
        end %set_location method
        
        function Set_Side(P)
            %Decide which side the port should be on
            %Eventually should be replaced with a lookup-table
            if strcmp(P.Direction, 'IN') == 1
                P.Side = 'Left';
            else
                P.Side = 'Right';
            end %direction_if
        end %set_side
        
        
        function Set_PortNum(P)
            set_param(P.SimEventsPath, 'Port', num2str(P.Number));
            set_param(P.SimEventsPath, 'Side', P.Side);
        end
        
    end %methods
    
end %classdef

