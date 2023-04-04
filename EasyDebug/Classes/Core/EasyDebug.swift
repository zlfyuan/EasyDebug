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
    
    var currentController: UIViewController? = nil
    
    public func start(_ options: (()->(EDOptions))? = nil) {
        EDURLProtocol.startMonitor()
        guard let window = UIApplication.shared.delegate?.window else {
            print("windwo can't empty")
            return
        }
        let btn = UIButton(type: .system)
        btn.backgroundColor = .orange
        btn.setTitle("debug", for: .normal)
        btn.frame = CGRect.init(x: 100, y: 100, width: 60, height: 30)
        btn.addTarget(self, action: #selector(debugAction), for: .touchUpInside)
        window?.rootViewController?.view.addSubview(btn)
        EasyDebug.shared.currentController = window?.rootViewController
        guard let optionsfunc = options else { return }
        print(optionsfunc().debug)
    }
    
    @objc func debugAction() {
        let rootViewController = EDTabBarController()
//        rootViewController.modalPresentationStyle = .overCurrentContext
        EasyDebug.shared.currentController?.present(rootViewController, animated: true)
    }
    
}
