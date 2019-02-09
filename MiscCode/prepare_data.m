%function [EdgeSet NodeSet WorkstationSet ProcessSet ResourcePoolSet] = prepare_data(database)
function [EdgeSet NodeSet] = prepare_data(database)
%PREPARE_DATA bring in the external instance data and organize it into Node
%and Edge Sets, allocate the edges to Nodes, and organize the hierarchical
%nested networks
%[EdgeSet NodeSet WorkstationSet ProcessSet ResourcePoolSet]

%database = 'C:\Users\tsprock3\Desktop\WSProcessModel.accdb';

%I believe there should only be one edgeset
%This edgeset will always exist and should always be parsed first
%so that it can be allocated to the nodes later
EdgeSet = parse_edges(database);
%varargout{1} = {EdgeSet};

NodeSet = parse_nodes(database);
if isempty(NodeSet) == 0
    allocate_edges(NodeSet, EdgeSet);
    %varargout{end+1} = {NodeSet};
end


%WorkstationSet = parse_workstations(database);
%if isempty(WorkstationSet) == 0
%    allocate_edges(WorkstationSet, EdgeSet);
    %varargout{end+1} = {WorkstationSet};
%end

%ProcessSet = parse_process(database);
%if isempty(ProcessSet) == 0
%    allocate_edges(ProcessSet, EdgeSet);
%    allocate_processes(WorkstationSet, ProcessSet);
    %varargout{end+1} = {ProcessSet};
%end

%ResourcePoolSet = parse_resourcepool(database);
%if isempty(ResourcePoolSet) == 0
%    allocate_resourcepools(WorkstationSet, ResourcePoolSet);
    %varargout{end+1} = {ResourcePoolSet};
%end

end

function recordstruct = getrecords(database, sqlstring)
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

function [ EdgeSet ] = parse_edges(database)
%PARSE_EDGES Summary of this function goes here
%   Detailed explanation goes here

sqlstring = 'SELECT * FROM EdgeTable ORDER BY EdgeTable.Edge_ID;';


Edges = getrecords(database, sqlstring);
EdgeSet(length(Edges.data)) = Edge;

for i = 1:length(EdgeSet)
   for j = 1:length(Edges.columnnames)
       %Populate each Edge with instance data from table
       EdgeSet(i).(cell2mat(Edges.columnnames(j))) = cell2mat(Edges.(cell2mat(Edges.columnnames(j)))(i));
   end %for each column in table
    
end %for each line item instance in table

end

function [ NodeSet ] = parse_nodes(database)
%PARSE_NODES parses data from an RDB into class objects
%reads data from the NodeTable stored in Access, and constructs a
%collection of nodes from the data

sqlstring = 'SELECT * FROM NodeTable ORDER BY NodeTable.Node_ID;';
recordset = getrecords(database, sqlstring);

if isempty(recordset) == 1 
    %if the recordset is empty, then there are no nodes in the node table
    %return an empty array
    NodeSet = int16.empty(0,0);
else 
    %populate the NodeSet with Nodes, and return
    NodeSet(length(recordset.data)) = Node;

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

function [ WorkstationSet ] = parse_workstations(database)
%PARSE_NODES Summary of this function goes here
%   Detailed explanation goes here

sqlstring = 'SELECT * FROM NodeTable WHERE Type = "Workstation" ORDER BY Node_ID;';


WS = getrecords(database, sqlstring);

if isempty(WS)== 0
    WorkstationSet(length(WS.data)) = Workstation;

    for i = 1:length(WorkstationSet)
       for j = 1:length(WS.columnnames)
           %Populate each Node with instance data from table
           WorkstationSet(i).(cell2mat(WS.columnnames(j))) = cell2mat(WS.(cell2mat(WS.columnnames(j)))(i));
       end %for each column in table

       for k = 1:length(WorkstationSet)
           if eq(WorkstationSet(i).Parent_ID, WorkstationSet(k).Node_ID) == 1
                WorkstationSet(i).Parent = WorkstationSet(k);
           end
       end
   
    end %for each line item instance in table
else
    WorkstationSet = [];
end %do if WS.data is NOT empty

end

function [ ProcessSet ] = parse_process(database)
%PARSE_NODES Summary of this function goes here
%   Detailed explanation goes here

sqlstring = 'SELECT * FROM ProcessTable;';


PS = getrecords(database, sqlstring);

if isempty(PS) == 0
    ProcessSet(length(PS.data)) = Process;

    for i = 1:length(ProcessSet)
       for j = 1:length(PS.columnnames)
           %Populate each Node with instance data from table
           ProcessSet(i).(cell2mat(PS.columnnames(j))) = cell2mat(PS.(cell2mat(PS.columnnames(j)))(i));
       end %for each column in table

       ProcessSet(i).Workstation_ID = ProcessSet(i).Parent_ID;


    end %for each line item instance in table
else
    ProcessSet = [];
end %Check that RecordSet is NOT empty


end

function [ ResourcePoolSet ] = parse_resourcepool(database)
%PARSE_NODES Summary of this function goes here
%   Detailed explanation goes here

sqlstring = 'SELECT * FROM ResourcePool_table;';

RP = getrecords(database, sqlstring);
if isempty(RP)==0
    ResourcePoolSet(length(RP.data)) = ResourcePool;

    for i = 1:length(ResourcePoolSet)
       for j = 1:length(RP.columnnames)
           %Populate each Node with instance data from table
           ResourcePoolSet(i).(cell2mat(RP.columnnames(j))) = cell2mat(RP.(cell2mat(RP.columnnames(j)))(i));
       end %for each column in table

    end %for each line item instance in table
else
    ResourcePoolSet = [];
end %Check that RecordSet is NOT empty

end

function allocate_edges( NodeSet, EdgeSet )
%ALLOCATE_EDGES Summary of this function goes here
%   Detailed explanation goes here


for j = 1:length(NodeSet)

    for i = 1:length(EdgeSet)
    
        NodeSet(j).addEdge(EdgeSet(i));
           
    end %for each edge
    NodeSet(j).assignPorts;
    
end %for each node

end

function allocate_resourcepools( WorkstationSet, ResourcePoolSet )
%ALLOCATE_EDGES Summary of this function goes here
%   Detailed explanation goes here


    for j = 1:length(WorkstationSet)

        for i = 1:length(ResourcePoolSet)

            WorkstationSet(j).addResourcePool(ResourcePoolSet(i));

        end %for each edge

    end %for each node

end

function allocate_processes( WorkstationSet, ProcessSet )
%ALLOCATE_EDGES Summary of this function goes here
%   Detailed explanation goes here


    for j = 1:length(WorkstationSet)

        for i = 1:length(ProcessSet)

            WorkstationSet(j).addProcess(ProcessSet(i));

        end %for each edge

    end %for each node

end

function segregate_networks( Node_ID, NodeSet )
%SEGREGATE_NETWORKS Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(NodeSet)
%Look for the node in the nodeset that matches the node_id

    if eq(NodeSet(i).Node_ID, Node_ID) ==1
       %add a new nested network
       NodeSet(i).NestedNetwork = Network;
       NodeSet(i).NestedNetwork.Parent = NodeSet(i);
        
       %look for nodes belonging in nested network
       for j = 1:length(NodeSet)
            if eq(NodeSet(j).Parent_ID,NodeSet(i).Node_ID) ==1
               %if the node belongs in the nested network, add it
               NodeSet(i).NestedNetwork.NodeSet(end+1) = NodeSet(j);
               %then recursively exploit that node
               segregate_networks(NodeSet(j).Node_ID, NodeSet);
            end 
       end %end look for nodes belonging in nested network
       
       %check to see if the nested network was populated with anything
       if eq(length(NodeSet(i).NestedNetwork.NodeSet), 0) ==1
           %if not, delete the nested network
           %clear NodeSet(i).NestedNetwork;
       else
           %if yes, add edges to nested networks edgeset
           for k= 1:length(NodeSet(i).NestedNetwork.NodeSet)
               NodeSet(i).NestedNetwork.EdgeSet = ...
                   [NodeSet(i).NestedNetwork.EdgeSet NodeSet(i).NestedNetwork.NodeSet(k).INEdgeSet];
           end%end for each node in nested network
       end %end check empty nested network
        
    end%end match node_id to a node
end%end for each node


end