function [ NodeSet, EdgeSet ] = prepare_data(database)
%PREPARE_DATA bring in the external instance data and organize it into Node
%and Edge Sets, allocate the edges to Nodes, and organize the hierarchical
%nested networks

%database = 'C:\Users\tsprock3\Desktop\HubDepotModel.accdb';

NodeSet = parse_nodes(database);
EdgeSet = parse_edges(database);

allocate_edges(NodeSet, EdgeSet);

segregate_networks(0, NodeSet);
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



invoke(rs,'Close');
invoke(db,'Close');
delete(cn);

end

function [ NodeSet ] = parse_nodes(database)
%PARSE_NODES Summary of this function goes here
%   Detailed explanation goes here

sqlstring = 'SELECT * FROM NodeTable ORDER BY NodeTable.Node_ID;';


Nodes = getrecords(database, sqlstring);
NodeSet(length(Nodes.data)) = Node;

for i = 1:length(NodeSet)
   for j = 1:length(Nodes.columnnames)
       %Populate each Node with instance data from table
       NodeSet(i).(cell2mat(Nodes.columnnames(j))) = cell2mat(Nodes.(cell2mat(Nodes.columnnames(j)))(i));
   end %for each column in table
   
   for k = 1:length(NodeSet)
       if eq(NodeSet(i).Parent_ID, NodeSet(k).Node_ID) == 1
            NodeSet(i).Parent = NodeSet(k);
       end
   end
   
end %for each line item instance in table


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