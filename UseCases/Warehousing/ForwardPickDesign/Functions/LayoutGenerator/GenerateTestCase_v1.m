aisles = 15;
PD_aisle = 6;
slot_width = 10;
aisle_width = 30;
slots = 25;
cross_aisle = [25];
full = 0;

%% Initialize Layout Procedure
N = 1;
E = 1;
NodeSet = Node(0,0,0,0,'P&D');
NodeSetList = [0, 0,0,0]; %[ID, X, Y, Z]
EdgeSet = Edge;
EdgeSet(1).Edge_ID = 0;
EdgeSetList = [0 0 0 0];
cross_aisle_width = 3*slot_width;

%% Generate Aisles (Columns) of Travel Nodes
for aisle_count = 0:aisles-1
    %Generate the Bottom Cross Aisle    
    n1 = Node(N, 0.5*aisle_width+aisle_count*aisle_width, 0.25*cross_aisle_width, 0, 'Transport');
    NodeSetList = [NodeSetList; N, 0.5*aisle_width+aisle_count*aisle_width, 0.25*cross_aisle_width, 0];
     
    eO = Edge(E, N, N+1, 'UoH');
    eD = Edge(E+1, N+1, N, 'UoH');
    if eq(full, 1)
        n1.addEdge(eO);
        n1.addEdge(eD);
    else
        last_xyz = [0.5*aisle_width+aisle_count*aisle_width, 0.25*cross_aisle_width, 0];
    end
    
    EdgeSetList = [EdgeSetList; E, N, N+1, 0; E+1, N+1, N, 0];
    
    NodeSet(end+1) = n1;
    EdgeSet(end+1) = eO;
    EdgeSet(end+1) = eD;
    N= N+1;
    E = E+2;
    for slot_count = 0:slots-1
        
        n1 = Node(N, 0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0, 'Transport');
        
        if eq(full,0)
            EdgeSetList(end-1, 4) = max(1e-6,sqrt(sum((last_xyz - [0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0]).^2)));
            EdgeSetList(end, 4) = max(1e-6,sqrt(sum((last_xyz - [0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0]).^2)));
            last_xyz = [0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0];
        end
        
        NodeSetList = [NodeSetList; N, 0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0];
        
        if eq(full, 1)
            n1.addEdge(eO);
            n1.addEdge(eD);
        end
                
        eD = Edge(E+1, N+1, N, 'UoH');
        eO = Edge(E, N, N+1, 'UoH');
        if eq(full, 1)
            n1.addEdge(eO);
            n1.addEdge(eD);
        end
        
        EdgeSetList = [EdgeSetList; E, N, N+1, 0; E+1, N+1, N, 0];
        
        NodeSet(end+1) = n1;
        EdgeSet(end+1) = eO;
        EdgeSet(end+1) = eD;
        
        N = N+1;
        E = E+2;
    end
    %Generate the Top Cross Aisle
    n1 = Node(N, 0.5*aisle_width+aisle_count*aisle_width, slots*slot_width + 0.5*cross_aisle_width,0, 'Transport');
    if eq(full,0)
        EdgeSetList(end-1, 4) = max(1e-6,sqrt(sum((last_xyz - [0.5*aisle_width+aisle_count*aisle_width, slots*slot_width + 0.5*cross_aisle_width,0]).^2)));
        EdgeSetList(end, 4) = max(1e-6,sqrt(sum((last_xyz - [0.5*aisle_width+aisle_count*aisle_width, slots*slot_width + 0.5*cross_aisle_width,0]).^2)));
    end
    NodeSetList = [NodeSetList;N, 0.5*aisle_width+aisle_count*aisle_width, slots*slot_width + 0.5*cross_aisle_width,0];
    if eq(full, 1)
        n1.addEdge(eO);
        n1.addEdge(eD);
    end
    
    NodeSet(end+1) = n1;
    N= N+1;
end

%% Addition of the Cross Aisles on Top, Middle, and Bottom
% Can generalize to arbitrary number of cross aisles (perhaps with the mild
% condition that the aisle node was already placed in previous section
Cross_Aisle_Set = [0.25*cross_aisle_width, slots*slot_width + 0.5*cross_aisle_width, 0.5*slot_width + cross_aisle*slot_width + 0.25*cross_aisle_width];

for j = 1:length(Cross_Aisle_Set)

    Cross_Aisle = findobj(NodeSet, 'Y', Cross_Aisle_Set(j));

    for i = 1:length(Cross_Aisle)-1
        eO = Edge(E, Cross_Aisle(i).Node_ID, Cross_Aisle(i+1).Node_ID, 'UoH');
        eD = Edge(E+1, Cross_Aisle(i+1).Node_ID, Cross_Aisle(i).Node_ID, 'UoH');
        
        if eq(full,0)
            distance = max(1e-06, sqrt(sum([Cross_Aisle(i).X Cross_Aisle(i).Y Cross_Aisle(i).Z] - [Cross_Aisle(i+1).X Cross_Aisle(i+1).Y Cross_Aisle(i+1).Z]).^2));
            EdgeSetList = [EdgeSetList; E, Cross_Aisle(i).Node_ID, Cross_Aisle(i+1).Node_ID, distance; E+1, Cross_Aisle(i+1).Node_ID, Cross_Aisle(i).Node_ID, distance];
        else
            EdgeSetList = [EdgeSetList; E, Cross_Aisle(i).Node_ID, Cross_Aisle(i+1).Node_ID, 0; E+1, Cross_Aisle(i+1).Node_ID, Cross_Aisle(i).Node_ID, 0];
        end
        
        if eq(full, 1)
            Cross_Aisle(i).addEdge(eO);
            Cross_Aisle(i).addEdge(eD);
            Cross_Aisle(i+1).addEdge(eO);
            Cross_Aisle(i+1).addEdge(eD);
        end
        
        EdgeSet(end+1) = eO;
        EdgeSet(end+1) = eD;
        E = E+2;
    end
end

%% Insert Pickup & Drop-off Point(s)
PD = Node(N, 0.5*aisle_width+PD_aisle*aisle_width, 0, 0, 'P&D');
NodeSetList = [NodeSetList;length(NodeSet), 0.5*aisle_width+PD_aisle*aisle_width, 0, 0];

n1 = findobj(findobj(NodeSet, 'X', 0.5*aisle_width+PD_aisle*aisle_width), 'Y', 0.25*cross_aisle_width);


eO = Edge(E+1, n1.Node_ID, PD.Node_ID, 'UoH');
eD = Edge(E, PD.Node_ID, n1.Node_ID, 'UoH');
if eq(full,0)
    EdgeSetList = [EdgeSetList; E, PD.Node_ID, n1.Node_ID, 0.25*cross_aisle_width; E+1, n1.Node_ID, PD.Node_ID, 0.25*cross_aisle_width];
else
    EdgeSetList = [EdgeSetList; E, PD.Node_ID, n1.Node_ID, 0; E+1, n1.Node_ID, PD.Node_ID, 0];
end

N= N+1;
NodeSet(end+1) = PD;
if eq(full, 1)
    n1.addEdge(eO);
    n1.addEdge(eD);
    PD.addEdge(eO);
    PD.addEdge(eD);
end
    
EdgeSet(end+1) = eO;
EdgeSet(end+1) = eD;

%% Commit Data to Network Structure
MovementNetwork = Network;
MovementNetwork.NodeSet = NodeSet(2:end);
MovementNetwork.NodeSetList = NodeSetList(2:end, :);
MovementNetwork.EdgeSet = EdgeSet(2:end);
MovementNetwork.EdgeSetList = EdgeSetList(2:end , : );
if eq(full,1)
    %MovementNetwork.setEdgeWeights;
end

MovementNetwork.EdgeSetAdjList = list2adj(MovementNetwork.EdgeSetList(:, 2:end));


%% Generate Storage Network 
%(two storage nodes for each travel node in an aisle)
NodeSet = Node(0,0,0,0,'P&D');
NodeSetList = [0, 0,0,0];
EdgeSet = Edge;
EdgeSet(1).Edge_ID = 0;
EdgeSetList = [0 0 0 0];

for i = 1:length(MovementNetwork.NodeSet)
    travelNode = MovementNetwork.NodeSet(i);

    if eq(any(travelNode.Y  == [0, 0.25*cross_aisle_width, 0.5*slot_width +slot_width*[cross_aisle-1, cross_aisle, cross_aisle+1]]),1)
        continue
    else
        tnID = travelNode.Node_ID;
        X = travelNode.X;
        Y = travelNode.Y;
        Z = travelNode.Z;
        for j = 1:2
        %Create Two Storage Nodes in the Same Location as the Transport
            %Node
            n1 = Node(N, X, Y, Z, 'Storage');
            NodeSetList = [NodeSetList; N, X, Y, Z];

            eO = Edge(E+1, tnID, N, 'UoH');
            eD = Edge(E, N, tnID, 'UoH');
            %Fudge the distance to make the shortest path alg work.
            EdgeSetList = [EdgeSetList; E, N, tnID, 1e-6; E+1, tnID, N, 1e-6];

            if eq(full, 1)
                n1.addEdge(eO);
                n1.addEdge(eD);
                travelNode.addEdge(eO);
                travelNode.addEdge(eD);
            end
            
            NodeSet(end+1) = n1;
            EdgeSet(end+1) = eO;    
            EdgeSet(end+1) = eD;
            N = N+1;
            E = E+2;
        end

    end
end

%% Commit Data to Network Structure
StorageNetwork = Network;
StorageNetwork.NodeSet = NodeSet(2:end);
StorageNetwork.NodeSetList = NodeSetList(2:end, :);
StorageNetwork.EdgeSet = EdgeSet(2:end);
StorageNetwork.EdgeSetList = EdgeSetList(2:end , : );
StorageNetwork.EdgeSetAdjList = list2adj(StorageNetwork.EdgeSetList(:, 2:end));
if eq(full,1)
    %StorageNetwork.setEdgeWeights;
end

%% Calculate Relative Value of Each Storage Location.
%A = list2adj([MovementNetwork.EdgeSetList(:, 2:end); StorageNetwork.EdgeSetList(:, 2:end)]);
%tic
%D = dijk(A, PD.Node_ID, StorageNetwork.NodeSetList(:,1));
%toc


