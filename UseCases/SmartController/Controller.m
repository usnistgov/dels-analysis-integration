classdef Controller < handle
    %CONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Sequencing@ISequencing
        ProcessPlanning@IDynamicProcessPlanning
        Routing@IRouting
        processListener
        AssetBuffer = {}
    end
    
    methods
        function obj = Controller()
            %CONTROLLER Construct an instance of this class
        end
        
        function asset = publishAsset(self, obj)
            asset = struct(obj);
            asset = rmfield(asset, 'AutoListeners__');
            asset.timeStamp = datestr(now);
            asset.uuid = java.rmi.server.UID();
            asset.type = class(obj)
            
            self.AssetBuffer{end+1} = asset;
        end
        
        function createProcessListener(self, process)
            mc = metaclass(process);
            metaprops = [mc(:).PropertyList];
            addlistener(process, metaprops, 'PostSet', ...
                @(src,evt)self.publishAsset(process));
            
            for ii = 1:length(process.processSteps)
                self.createProcessListener(process.processSteps{ii});
            end
        end
        
        function createProductListener(self, product)
            mc = metaclass(product);
            metaprops = [mc(:).PropertyList];
            addlistener(product, metaprops, 'PostSet', ...
                @(src,evt)self.publishAsset(product));
            self.createProcessListener(product.processPlan);
        end
        
    end
end

