clear
open('WorkstationModel')
open('DELS_Library')
simeventslib

[ EdgeSet, NodeSet, WorkstationSet, ProcessSet, ResourcePoolSet ] = prepare_data();
Model = 'WorkstationModel';
wf1 = WorkstationFactory;
ef1 = EdgeFactory;
wf1.Model = Model;
ef1.Model = Model;
wf1.set_NodeSet(WorkstationSet);
ef1.EdgeSet = EdgeSet;
wf1.CreateNodes;
ef1.CreateEdges;
wf1.Create_ResourcePools;
wf1.Create_Processes;
