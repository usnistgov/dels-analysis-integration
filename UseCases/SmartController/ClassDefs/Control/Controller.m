classdef Controller < handle
    %CONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Sequencing@ISequencing
        ProcessPlanning@IDynamicProcessPlanning
        Routing@IRouting
        processListener
        AssetBuffer = {}
        sequenceNo = 1;
    end
    
    methods
        function obj = Controller()
            %CONTROLLER Construct an instance of this class
        end
        
        function asset = publishAsset(self, obj)
            asset = struct(obj);
            asset = rmfield(asset, 'AutoListeners__');
            asset.timeStamp = datestr(now);
            asset.uuid = string(java.rmi.server.UID().toString());
            asset.typeID = class(obj);
            asset.sequence = self.sequenceNo %no ; to allow visual streaming
            self.sequenceNo = self.sequenceNo + 1;
            
            self.AssetBuffer{end+1} = asset;
        end
        
        function createProcessListener(self, process)
            % Creates a listener for any changes to the any property of the input Process
            %   The listener will invoke the "publishAsset()" method which just turns the class
            %   into a struct and writes it to the "Asset Buffer" or some blackboard tbd 
            mc = metaclass(process);
            metaprops = [mc(:).PropertyList]; %for every property of input Process
            
            addlistener(process, metaprops, 'PostSet', ...
                @(src,evt)self.publishAsset(process));
            
            % Recursively create listeners for each processStep of Process
            for ii = 1:length(process.processSteps)
                self.createProcessListener(process.processSteps{ii});
            end
        end
        
        function createProductListener(self, product)
            % Creates a listener for any changes to the any property of the input Product
            %   The listener will invoke the "publishAsset()" method which just turns the class
            %   into a struct and writes it to the "Asset Buffer" or some blackboard tbd 
            mc = metaclass(product);
            metaprops = [mc(:).PropertyList]; %for every property of input Product
            addlistener(product, metaprops, 'PostSet', ...
                @(src,evt)self.publishAsset(product));
            
            %call method to create listeners for the product's process plan too
            self.createProcessListener(product.processPlan);
        end
        
        function createResourceListener(self, resource)
            % Creates a listener for any changes to the any property of the input Resource
            %   The listener will invoke the "publishAsset()" method which just turns the class
            %   into a struct and writes it to the "Asset Buffer" or some blackboard tbd 
            mc = metaclass(resource);
            metaprops = [mc(:).PropertyList]; %for every property of input Resource
            
            addlistener(resource, metaprops, 'PostSet', ...
                @(src,evt)self.publishAsset(resource));
            
        end
        
    end
end

