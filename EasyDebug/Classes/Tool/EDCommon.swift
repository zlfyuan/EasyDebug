//
//  EDCommon.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/4.
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

class EDCommon {
    
    static var placeholder: String = "-"
    
    static func heightForString(_ string: String, font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = [NSAttributedString.Key.font: font]
        let rect = NSString(string: string).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return rect.height
    }
    
    static func widthForString(_ string: String, font: UIFont) -> CGFloat {
        let text = string
        let font = font

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        let size = (text as NSString).size(withAttributes: attributes)
        let width = ceil(size.width)
        return width
    }
    
    static func share(_ content: Any, in conttroller: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = conttroller.view
            popoverPresentationController.sourceRect = conttroller.view.bounds
        }
        conttroller.present(activityViewController, animated: true, completion: nil)
    }
    
    static func getJsonString(rawValue:Any) -> String? {
        do{
            let d = try JSONSerialization.data(withJSONObject: rawValue, options: JSONSerialization.WritingOptions.prettyPrinted)
            let s = String.init(data: d, encoding: .utf8)
            return s
        }catch let error{
            debugPrint(error)
            return nil
        }
    }
    
    static func getObject(jsonString: String) -> AnyObject? {
        do {
            guard let data = jsonString.data(using: .utf8) else { return nil }
            let objcet = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed)
            return objcet as AnyObject
        } catch let error{
            debugPrint(error)
            return nil
        }
    }
    
    static func formatFileSize(_ fileSize: UInt64) -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB, .useTB, .usePB]
        byteCountFormatter.countStyle = .file

        return byteCountFormatter.string(fromByteCount: Int64(fileSize))
    }
    
    static var easyDebugBundle: Bundle {
        let bundleNamePath = "EasyDebug.bundle"
        let bundlepath = Bundle(for: type(of: EasyDebug())).resourcePath! + "/" + "\(bundleNamePath)"
        guard let resource_bundle = Bundle(path: bundlepath) else {
            debugPrint("easyDebugBundle get empty")
            return Bundle.main
        }
        return resource_bundle
    }
    
    static func dynamicColor(_ lightColor: UIColor, darkColor: UIColor? = UIColor.white)  -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return lightColor
                }else{
                    return .systemBackground
                }
            }
        } else {
            return lightColor
        }
    }
}
