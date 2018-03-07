//
//  Base64Plugin.swift
//  PluginHost
//
//  Created by Jarosław Pendowski on 02.04.2016.
//  Copyright © 2016 Jarosław Pendowski. All rights reserved.
//

import Foundation


class Base64Plugin : NSObject, PluginInterface
{
    var name = "Text to Base64"
    
    func convert(_ string: String?) -> String?
    {
        if let string = string, let stringData = string.data(using: String.Encoding.utf8) {
            return stringData.base64EncodedString(options: .lineLength64Characters)
        }
        
        return string
    }
}
