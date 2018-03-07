//
//  AppDelegate.swift
//  PluginHost
//
//  Created by Jarosław Pendowski on 02.04.2016.
//  Copyright © 2016 Jarosław Pendowski. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{

    @IBOutlet weak var window: NSWindow!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var pluginsMenu: NSMenu!
    
    let pluginHost = PluginHost()

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        let path = Bundle.main.bundlePath
        
        pluginsMenu.removeAllItems()

        pluginHost.loadPluginsFromPath(path + "/../")
        pluginHost.plugins.forEach {
            let menuItem = NSMenuItem(title: $0.name, action: #selector(AppDelegate.pluginItemClicked(_:)), keyEquivalent: "")
            menuItem.representedObject = $0
            
            pluginsMenu.addItem(menuItem)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
    }

    @objc func pluginItemClicked(_ sender: NSMenuItem)
    {
        let selectedRange = textView.selectedRange()
        
        if let plugin = sender.representedObject as? PluginInterface {
            let string = textView.string as NSString?
            let selectedString = string?.substring(with: selectedRange)
            if let convertedString = plugin.convert(selectedString) {
                textView.replaceCharacters(in: selectedRange, with: convertedString)
            }
        }
    }
}

