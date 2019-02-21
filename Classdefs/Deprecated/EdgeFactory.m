classdef EdgeFactory < handle
    %The EdgeFactory is used to generate arcs within a model 
    
    properties
        Model %What Model the EdgeFactory is going to operate on
        EdgeSet@Edge %A set of edge classes
        database %source of instance data
    end
    
    methods
        function obj = EdgeFactory(edgeSet)
           if isa(edgeSet, 'Edge')
              obj.EdgeSet = edgeSet; 
           end
        end
        
        function CreateEdges(EF)
            %For each edge in edgeset, use the add_line method to add a
            %connector line in the simulation
            for i = 1:length(EF.EdgeSet)
                %check nestedness: needs to be fixed somehow to allow nodes
                %to connect to their nested networks
                add_line(EF.Model, strcat(EF.EdgeSet(i).Origin_Node.Node_Name,'/', EF.EdgeSet(i).Origin_Port.Conn),...
                    strcat(EF.EdgeSet(i).Destination_Node.Node_Name,'/', EF.EdgeSet(i).Destination_Port.Conn), 'autorouting', 'on');
            end
        end %creatEdges
        
        function setEdgeSet(EF)

        end
    end
    
    methods( Access = protected)
        
        function [EdgeSet] = parse_edges(EF, sqlstring)
        %PARSE_EDGES Summary of this function goes here
        %   Detailed explanation goes here

            recordset = getrecords(EF.database, sqlstring);
            if isempty(recordset) == 1 
                %if the recordset is empty, then there are no nodes in the node table
                %return an empty array
                EdgeSet = int16.empty(0,0);
            else
                EdgeSet(length(recordset.data)) = eval('Edge');

                for i = 1:length(EdgeSet)
                   for j = 1:length(recordset.columnnames)
                       %Populate each Edge with instance data from table
                       EdgeSet(i).(cell2mat(recordset.columnnames(j))) = cell2mat(recordset.(cell2mat(recordset.columnnames(j)))(i));
                   end %for each column in table

                end %for each line item instance in table
            end %check if recordset is empty
        end %parse edges
        function recordstruct = getrecords(EF, database, sqlstring)
            %GETRECORDS(tablename) opens a connection to the MSAccess database,
            % creates a recordset from (tablename),
            % puts the columns, or fieldnames, into recordstruct.columnnames,
            % and puts the record contents into recordstruct.data.


            cn=actxserver('Access.application');
            %db=invoke(cn.DBEngine,'OpenDatabase','C:\Users\tsprock3\Desktop\DELS.accdb');
            db=invoke(cn.DBEngine,'OpenDatabase',database);

            %rs=invoke(db,'OpenRecordset',tablename);
            %s = 'SELECT * FROM NodeTable;';
            rs=invoke(db,'OpenRecordset',sqlstring);

            if get(rs,'EOF')==1
                recordstruct = int16.empty(0,0);
            else
                fieldlist=get(rs,'Fields');
                ncols=get(fieldlist,'Count');

                nrecs=0;
                while get(rs,'EOF')==0
                    nrecs=nrecs + 1;
                    for c=1:double(ncols)
                        fields{c}=get(fieldlist,'Item',c-1);
                        recordstruct.data{nrecs,c}=get(fields{c},'Value');
                    end;
                    invoke(rs,'MoveNext');
                end;

                for c=1:double(ncols)
                    recordstruct.columnnames{c}=get(fields{c},'Name');
                    %if we can discern datatypes, then we could convert them from cells at
                    %runtime: data.Weight = cell2mat(data.Weight)
                    recordstruct.(get(fields{c},'Name')) = recordstruct.data(:,c);
                end;
            end %check empty recordset



            invoke(rs,'Close');
            invoke(db,'Close');
            delete(cn);

        end 
    
    end
end

