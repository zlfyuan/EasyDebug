//
//  EDDate+Extension.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/2.
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

public let timeZone = TimeZone.init(identifier: "GM+8")
public let timeLocal = Locale(identifier: "zh_CN")

public extension Date{

    func toString(format:String)->String{
        let date = Date()
        let _format = DateFormatter()
        _format.timeZone = timeZone
        _format.locale = timeLocal
        _format.dateFormat = format
        return _format.string(from: date)
    }
    
    static func dateToString(date:Date?,formatter:String) -> String {
        guard let date2 = date else {
            return ""
        }
        let formatter2 = DateFormatter()
        formatter2.timeZone = timeZone
        formatter2.locale = timeLocal
        formatter2.dateFormat = formatter
        let dateString2 = formatter2.string(from: date2)
        return dateString2
    }
    
}
