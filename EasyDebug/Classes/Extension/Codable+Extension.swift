//
//  Codable+Extension.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/3.
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

// 把对象类型转化成字典类型
/// 先将需要处理的类型声明为 Codable，然后使用 JSONEncoder 将其转换为 JSON 数据，最后再从 JSON 数据中拿到对应的字典：
/// 遵守该协议的对象即可使用value 转换
protocol EDJSONEncoder : Codable{
    /// 转化后的字典
    var value : [String:Any] { get }
}

extension EDJSONEncoder {
    var value : [String:Any] {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: [])
//            print(dictionary)
            return dictionary as! [String : Any]
        } catch {
            print(error)
            return ["message":"conversion error"]
        }
    }
    static func decode(object:Any) -> Self?{
        do {
            let json = try JSONSerialization.data(withJSONObject: object,options:JSONSerialization.WritingOptions.prettyPrinted)
            let jsonDecoder = JSONDecoder()
            let m = try jsonDecoder.decode(Self.self, from: json)
            return m
        } catch {
            debugPrint("解析失败\(error)")
            return nil
        }
    }
    static func decode(listObject:Any) -> [Self]?{
        do{
            let json = try JSONSerialization.data(withJSONObject: listObject,options:JSONSerialization.WritingOptions.prettyPrinted)
            let jsonDecoder = JSONDecoder()
            let m = try jsonDecoder.decode([Self].self, from: json)
            return m
        }catch {
            debugPrint("解析失败\(error)")
            return nil
        }
    }
}

