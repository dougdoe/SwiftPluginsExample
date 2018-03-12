//
//  PluginHost.swift
//  PluginHost
//
//  Created by Jarosław Pendowski on 02.04.2016.
//  Copyright © 2016 Jarosław Pendowski. All rights reserved.
//

import Cocoa

class PluginHost
{
    var plugins: [PluginInterface] = []
    
    func loadPluginsFromPath(_ path: String, outputView: NSTextView)
    {
        let fileManager = FileManager.default
        
        guard let enumerator = fileManager.enumerator(at: URL(fileURLWithPath: path), includingPropertiesForKeys: [ URLResourceKey.nameKey, URLResourceKey.isDirectoryKey ], options: [ .skipsHiddenFiles, .skipsSubdirectoryDescendants ], errorHandler: nil) else {
            
            return
        }
        
        while let item = enumerator.nextObject() as? URL {
            do {
                var isDirectory: AnyObject?
                try (item as NSURL).getResourceValue(&isDirectory, forKey: URLResourceKey.isDirectoryKey)
                
                if item.path.hasSuffix("bundle"), let isDirectory = isDirectory as? NSNumber, isDirectory.boolValue, let bundle = Bundle(url: item), bundle.load() {
                    
                    if let cls = bundle.principalClass as? NSObject.Type, let plugin = cls.init() as? PluginInterface {
                        plugins.append(plugin)
                        let selectedRange = outputView.selectedRange()
                        outputView.replaceCharacters(in: selectedRange, with: "> Plugin Loaded: \(plugin.name)\n")
                    }
                }
                
            } catch _ { }
        }
    }
}
