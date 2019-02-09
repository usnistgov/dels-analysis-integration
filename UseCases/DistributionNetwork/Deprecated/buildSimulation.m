function [df1, cf1, tf1, ef1] = buildSimulation(Model, Library, customerSet, depotSet, transportationSet, edgeSet, commoditySet)
%Ideally, buildSimulation would take in a set of NodeFactories and
%EdgeFactories then check and construct the simulation, returning any
%errors

networkFactory = NetworkFactory;
networkFactory.Model = Model;
networkFactory.modelLibrary = Library;

tf1 = NodeFactory(transportationSet,edgeSet);

df1 = NodeFactory(depotSet, edgeSet);

cf1 = NodeFactory(customerSet, edgeSet);

ef1=EdgeFactory(edgeSet);

networkFactory.addNodeFactory([tf1,df1,cf1]);
networkFactory.addEdgeFactory(ef1);
networkFactory.buildSimulation;

end