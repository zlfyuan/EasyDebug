//
//  EDFeatureShowController.swift
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

class EDFeatureShowController: EDBaseController {
    
    enum Feature: String, CaseIterable {
        typealias RawValue = String
        case log = "title.log"
        case network = "title.network"
        case sandbox = "title.sandbox"
    }
    
    var currentButton: UIButton? = nil
    
    var pageController: UIPageViewController!
    var controllers: [UIViewController] = []
    var currentControllerIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        let topView = UIView(frame: CGRect.init(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: self.view.frame.width, height: 45))
        view.addSubview(topView)
        
        let marginLeft = 10
        var width = 60
        let height = 28
        let y = (Int(topView.frame.height) - height) / 2
        
        if let maxWidth = Feature.allCases.map({ f in
            let title = String.edLocalizedString(withKey: f.rawValue)
            let _width = Int(EDCommon.widthForString(title, font: UIFont.systemFont(ofSize: 16)))
            return _width
        }).sorted().last {
            width = maxWidth + 10
            if width < 60 { width = 60 }
        }
        
        Feature.allCases.enumerated().forEach({ e in
            let title = String.edLocalizedString(withKey: e.element.rawValue)
            let button = UIButton.init(type: .system)
            button.tag = 1000 + e.offset
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(featureAction), for: .touchUpInside)
            button.layer.cornerRadius = 4
            button.layer.borderColor = button.titleLabel?.textColor.cgColor
            button.layer.borderWidth = 0.6
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            let x = marginLeft + (e.offset * marginLeft) + (e.offset * width)
            button.frame = CGRect.init(x: x, y: y, width: width, height: height)
            topView.addSubview(button)
            if e.offset == 0 { self.currentButton = button }
            
        })
        
        let logVc = EDLogController(style: .grouped)
        controllers.append(logVc)
        
        let netWorkVc = EDNetworkingController(style: .grouped)
        controllers.append(netWorkVc)
        
        let sandBoxVc = EDSandBoxController(style: .grouped)
        controllers.append(sandBoxVc)
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        addChild(pageController)
        pageController.view.frame = CGRect.init(x: 0, y: topView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topView.frame.maxY - self.tabBarController!.tabBar.frame.height)
        view.addSubview(pageController.view)
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.didMove(toParent: self)
        featureAction(self.currentButton!)
        pageController.setViewControllers([controllers[currentControllerIndex]], direction: .forward, animated: true, completion: nil)
        
        //禁用滚动
        for view in pageController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.isScrollEnabled = false
            }
        }
    }
    
    @objc func featureAction(_ button: UIButton) {
        self.currentButton?.setTitleColor(.systemBlue, for: .normal)
        self.currentButton?.backgroundColor = EDCommon.dynamicColor(.white)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        self.title = button.titleLabel?.text
        self.currentButton = button
        
        self.changePageController(with: button.tag - 1000)
    }
    
    func changePageController(with index: Int) {
        currentControllerIndex = index
        pageController.setViewControllers([controllers[currentControllerIndex]], direction: .forward, animated: false, completion: nil)
    }
}

extension EDFeatureShowController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController), index > 0 {
            return controllers[index - 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 {
            return controllers[index + 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, shouldInteractWith gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}
