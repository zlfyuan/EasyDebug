//
//  EDApplication.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/6.
//  Copyright © 2023 zluof <https://github.com/zlfyuan/>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE
//

import Foundation

class EDApplication: EDPropertiesListable {
    
    var DevelopmentRegion: String = "-"
    var ApplicationName: String = "-"
    var Identifier: String = "-"
    var BundleName: String = "-"
    var Version: String = "-"
    var MinimumOSVersion: String = "-"
    var SDKName: String = "-"
    var PlatformBuild: String = "-"
    var permissionsUsageDescription: [String: String] = [:]
    
    var xcode: [String: String] = [:]
    
    init() {
        self.DevelopmentRegion = value(for: "CFBundleDevelopmentRegion")
        self.ApplicationName = value(for: "CFBundleDisplayName") == "-" ? value(for: "CFBundleIdentifier") : value(for: "CFBundleDisplayName")
        self.Identifier = value(for: "CFBundleIdentifier")
        self.BundleName = value(for: "CFBundleName")
        self.Version = value(for: "CFBundleShortVersionString") + " (\(value(for: "CFBundleVersion")))"
        self.MinimumOSVersion = value(for: "DTPlatformName") + " \(value(for: "MinimumOSVersion"))"
        self.PlatformBuild = value(for: "DTPlatformName") + " \(value(for: "DTPlatformVersion"))" + " \(value(for: "DTPlatformBuild"))"
        self.SDKName = self.PlatformBuild
        self.permissionsUsageDescription = {
            let _permission = info.filter({$0.key.hasSuffix("UsageDescription")})
            var tempDic = [String: String]()
            _permission.forEach { dic in
                tempDic[dic.key] = (dic.value as? String) ?? placeholder
            }
            return tempDic
        }()
        
        self.xcode = ["Xcode":value(for: "DTXcode"),
                      "XcodeBuild":value(for: "DTXcodeBuild")]
        
        
    }
    
    
    
    var mainBundle: Bundle {
        return Bundle.main
    }
    
    var info: [String: Any] {
        if let _info = mainBundle.infoDictionary {
            return _info
        }
        return [:]
    }
    
    var placeholder: String {
        return "-"
    }
    
    func value(for key: String) -> String {
        if let name = info[key] as? String {
            return name
        }
        return placeholder
    }
    
}

