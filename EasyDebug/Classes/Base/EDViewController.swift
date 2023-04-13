//
//  EDViewController.swift
//  EasyDebug
//
//  Created by zluof on 2023/3/31.
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


import UIKit

class EDViewController: EDBaseController {
    var root: EDTabBarController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        self.view.layer.borderWidth = 3
        self.view.layer.cornerRadius = view.frame.size.width / 2
        self.view.layer.masksToBounds = true
        let debugButton = UIButton(type: .custom)
        debugButton.frame = self.view.bounds
        debugButton.backgroundColor = EDCommon.dynamicColor(.white)
        debugButton.setBackgroundImage(UIImage.getBundleImage(withName: "easyDebugIcon"), for: .normal)
        debugButton.addTarget(self, action: #selector(debugAction), for: .touchUpInside)
        self.view.addSubview(debugButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reset), name: NotificationNameKeyReset, object: nil)
    }
    
    @objc func debugAction() {
        if EasyDebug.shared.visible == true {
            root?.doneBarButtonItemAction()
            return
        }
        guard let _window = UIApplication.shared.delegate?.window,
              let window = _window,
            let rootController = window.rootViewController else {
            return
        }
//        guard let edWindow = UIApplication.shared.keyWindow as? EDWindow else {
//            return
//        }
//        edWindow.isHidden = true
        self.root = EDTabBarController()
        self.root?.modalPresentationStyle = .overCurrentContext
        rootController.present(self.root!, animated: true) {
            EasyDebug.shared.visible = true
        }
    }
    
    @objc func reset() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: DispatchWorkItem.init(block: {
            self.debugAction()
        }))
        debugAction()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
