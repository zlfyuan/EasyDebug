//
//  EasyDebug.swift
//  EasyDebug
//
//  Created by zluof on 2023/3/30.
//  Copyright © 2023 zlfyuan. All rights reserved.
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

public class EasyDebug {
    
    static public let shared = EasyDebug()
    
    var visibleabled: Bool = false
    
    var currentController: UIViewController? = nil
    
    public func start(_ options: (()->(EDOptions))? = nil) {
        
        EDLog.shared.config()
        
        EDURLProtocol.startMonitor()
        
        EDLocalizationSetting.setCurrentLanguage(.Chinese)
        
        
        guard let appDelegate = UIApplication.shared.delegate else {
            EDLogVerbose("appDelegate can't empty")
            return
        }
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.start(options)
            }
            return
        }
        let edWindow = EDWindow(frame: CGRect.init(x: 0, y: 100, width: 48, height: 48))
        edWindow.isHidden = false
        edWindow.windowLevel = UIWindow.Level.alert + 1
        edWindow.rootViewController = EDViewController()
        edWindow.makeKeyAndVisible()
        appDelegate.edWindow = edWindow
        
        guard let optionsfunc = options else { return }
        EDLogInfo(optionsfunc().debug)
        
    }
    
}
