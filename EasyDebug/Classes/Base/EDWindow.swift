//
//  EDWindow.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/10.
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

private struct AssociatedKeys {
    static var edWindowKey = "easy.edWindowKey"
}

extension UIApplicationDelegate {
    
    var edWindow: EDWindow? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.edWindowKey) as? EDWindow
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.edWindowKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

class EDWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureRecognizerAction(pan:)))
        pan.delaysTouchesBegan = false
        self.addGestureRecognizer(pan)
    }
    
    @objc func panGestureRecognizerAction(pan: UIPanGestureRecognizer) {
        let panView = self
        let tranp = pan.translation(in: panView)

        // Reset the starting point of dragging to the last point,
        // similar to resetting the position after each change of dragging,
        // zooming, and rotating
        pan.setTranslation(CGPoint.zero, in: panView)

        let newX = panView.center.x + tranp.x
        let newY = panView.center.y + tranp.y
        let safeBottom: CGFloat = self.safeAreaInsets.bottom

        var afterX = panView.center.x + tranp.x
        var afterY = panView.center.y + tranp.y

        // When the x value is less than half the screen,
        // move to the left, otherwise move to the right
        if afterX < UIScreen.main.bounds.size.width / 2 {
            afterX = self.bounds.size.width / 2
        } else {
            afterX = UIScreen.main.bounds.size.width - (self.bounds.size.width / 2)
        }

        // Prevent the y coordinate from sliding beyond the safe area
        // If it exceeds the safe area, reset it to inside the safe area
        if afterY > UIScreen.main.bounds.maxY - safeBottom {
            afterY = UIScreen.main.bounds.maxY - safeBottom
        }

        if afterY < UIApplication.shared.statusBarFrame.size.height {
            afterY = UIApplication.shared.statusBarFrame.size.height
        }
        
        if pan.state == .changed {
            // When the state is in the middle of sliding, update the center of the view based on the translation
            self.center = CGPoint(x: newX, y: newY)
        } else if pan.state == .ended {
            // When the state is at the end of sliding, animate the view to snap to the edge of the screen
            UIView.animate(withDuration: 0.2) {
                self.center = CGPoint(x: afterX, y: afterY)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
