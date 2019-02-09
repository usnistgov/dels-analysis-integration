db = 'C:\Users\tsprock3\Desktop\FRNModel.accdb'
Model = 'FRNmodel'
ef1 = EdgeFactory
ef1.Model = Model
ef1.database = db
ef1.setEdgeSet
frn1 = FRNnodeFactory
frn1.Model = Model
frn1.database = db
frn1.setNodeSet
frn1.allocate_edges(ef1.EdgeSet)
open('DELS_Library')
open('FRN_Library')
open(Model)
simeventslib
frn1.CreateNodes
ef1.CreateEdges
for j = 1:length(frn1.NodeSet)
    frn1.NodeSet(j).InitializeSubtype
    frn1.NodeSet(j).BuildFlowMetric
end