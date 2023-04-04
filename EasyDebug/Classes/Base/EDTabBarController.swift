//
//  EDTabBarController.swift
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

class EDTabBarController: UITabBarController {
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // 创建3个视图控制器
        let viewController1 = EDFeatureShowController()
        viewController1.tabBarItem = UITabBarItem(title: String.edLocalizedString(withKey: "title.feature"),
                                                  image: UIImage.getBundleImage(withName: "lasso.and.sparkles@2x"),
                                                  selectedImage: UIImage.getBundleImage(withName: "s_lasso.and.sparkles@2x"))
        viewController1.title = viewController1.tabBarItem.title

        let viewController2 = EDConfigController()
        viewController2.tabBarItem = UITabBarItem(title: String.edLocalizedString(withKey: "title.config"),
                                                  image: UIImage.getBundleImage(withName: "gear@2x"),
                                                  selectedImage: UIImage.getBundleImage(withName: "s_gear@2x"))
        viewController2.title = viewController2.tabBarItem.title

        let viewController3 = EDAppInfoController()
        viewController3.tabBarItem = UITabBarItem(title: String.edLocalizedString(withKey: "title.info"),
                                                  image: UIImage.getBundleImage(withName: "info.circle@2x"),
                                                  selectedImage: UIImage.getBundleImage(withName: "s_info.circle@2x"))
        viewController3.title = viewController3.tabBarItem.title

        self.viewControllers = [
            EDNavigationController(rootViewController: viewController1),
            EDNavigationController(rootViewController: viewController2),
            EDNavigationController(rootViewController: viewController3)
        ]

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
