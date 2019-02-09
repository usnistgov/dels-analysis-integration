classdef NodeFactory < handle
    %NODEFACTORY class is a creator class implemented to generate arbitrary
    %SimEvents objects corresponding to the nodes in the NodeSet within a specified model
    
    %note: hardcoded a max of 10 echelons
    
    properties
        Model %Where is the NodeFactory to operate
        Library
        NodeSet@Node %Set of nodes to be generated
    end
    
    methods (Access = public)
        function obj = NodeFactory(nodeSet, varargin)
           if isa(nodeSet, 'Node')
                obj.NodeSet = nodeSet;
                
                %Need to handle cases where multiple edgeSets are input
                if ~isempty(varargin) && isa(varargin{1}, 'Edge')
                    obj.allocate_edges(varargin{1})
                end
                
            end
        end %Constructor
        
        function CreateNodes(NF)
           echelon_position = [0 0 0 0 0 0 0 0 0 0]; %[1 2 3 4 5 6 7 8 9 10]
           for ii = 1:length(NF.NodeSet)
               
               %set position of new block relative to its echelon and
               %previous blocks in that echelon
               position = [350*(NF.NodeSet(ii).Echelon-1) echelon_position(NF.NodeSet(ii).Echelon)  ...
                   200+350*(NF.NodeSet(ii).Echelon-1) echelon_position(NF.NodeSet(ii).Echelon)+65+ 10*max(length(NF.NodeSet(ii).INEdgeSet), length(NF.NodeSet(ii).OUTEdgeSet))];
               echelon_position(NF.NodeSet(ii).Echelon) = echelon_position(NF.NodeSet(ii).Echelon) + ...
                   100+65+ 10*max(length(NF.NodeSet(ii).INEdgeSet), length(NF.NodeSet(ii).OUTEdgeSet));
               
               NF.NodeSet(ii).SimEventsPath = strcat(NF.Model, '/', NF.NodeSet(ii).Node_Name);
               NF.NodeSet(ii).Model = NF.Model;
               
               %add the block
               add_block(strcat(NF.Library, '/', NF.NodeSet(ii).Type), NF.NodeSet(ii).SimEventsPath, 'Position', position);
               set_param(NF.NodeSet(ii).SimEventsPath, 'LinkStatus', 'none');
               
               %NodeFactory is the Director
               %Node acts as a ConcreteBuilder
               NF.Construct(NF.NodeSet(ii));
         
           end
           
        end %Role: ConcreteFactory
        
        function Construct(NF,N)
            N.buildPorts;
            N.decorateNode;
        end %Role: Director
        
        
        function setNodeSet(NF, nodeSet)

        end %set Node Set
         
        function allocate_edges(NF, EdgeSet )
            %ALLOCATE_EDGES Summary of this function goes here
            %   Detailed explanation goes here

                for jj = 1:length(NF.NodeSet)

                    for ii = 1:length(EdgeSet)
                        NF.NodeSet(jj).addEdge(EdgeSet(ii));
                    end %for each edge
                    
                    NF.NodeSet(jj).assignPorts;

                end %for each node

        end
        
    end %Methods
    
    methods (Access = protected)
        function [ NodeSet ] = parse_nodes(NF, sqlstring)
            %PARSE_NODES parses data from an RDB into class objects
            %reads data from the NodeTable stored in Access, and constructs a
            %collection of nodes from the data

            %sqlstring = 'SELECT * FROM NodeTable ORDER BY NodeTable.Node_ID;';
            recordset = getrecords(NF.database, sqlstring);

            if isempty(recordset) == 1 
                %if the recordset is empty, then there are no nodes in the node table
                %return an empty array
                NodeSet = int16.empty(0,0);
            else 
                %populate the NodeSet with Nodes, and return
                NodeSet(length(recordset.data)) = eval(NF.Type);% Node;

                for i = 1:length(NodeSet)
                   for j = 1:length(recordset.columnnames)
                       %Populate each Node with instance data from table
                       NodeSet(i).(cell2mat(recordset.columnnames(j))) = cell2mat(recordset.(cell2mat(recordset.columnnames(j)))(i));
                   end %for each column in table

                   for k = 1:length(NodeSet)
                       if eq(NodeSet(i).Parent_ID, NodeSet(k).Node_ID) == 1
                            NodeSet(i).Parent = NodeSet(k);
                       end
                   end

                end %for each line item instance in table
            end %if recordset is empty

        end %end parse nodes
        
        function recordstruct = getrecords(NF, database, sqlstring)
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
    
end %NodeFactory