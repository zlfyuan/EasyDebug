//
//  UIimage+Extension.swift
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

extension UIImage {
  
    static func getBundleImage(withName name: String) -> UIImage? {
        
        // 获取当前Bundle
        let currentBundle = Bundle(for: type(of: EasyDebug()))
        let dict = currentBundle.infoDictionary
        // 获取Bundle的名称
        let bundleName = dict?["CFBundleExecutable"] as? String ?? ""
        // 获取屏幕比例
        let scale = UIScreen.main.scale
        // 拼接图片名称
        let imageName = "\(name)"
        let bundleNamePath = "\(bundleName).bundle"
        // 获取Bundle路径
        let bundlepath = Bundle(for: type(of: EasyDebug())).resourcePath! + "/" + "\(bundleNamePath)"
        let resource_bundle = Bundle(path: bundlepath)
        let image = UIImage(named: imageName, in: resource_bundle, compatibleWith: nil)
        return image
    }
}
