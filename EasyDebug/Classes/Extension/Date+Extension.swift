//
//  Date+Extension.swift
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

public extension Date {

    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    func dayOfWeek() -> Int {
        let interval = self.timeIntervalSince1970;
        let days = Int(interval / 86400);
        return (days - 3) % 7;
    }
}

fileprivate let lr_currentCalendar = Calendar.current

let totalSet:Set<Calendar.Component> = [.era,.year,.month,.day,.hour,.minute,.second,.weekday,
                .weekdayOrdinal,.quarter,.weekOfMonth,
                .yearForWeekOfYear,.nanosecond,
                .calendar,.timeZone]
public let timeZone = TimeZone.init(identifier: "GM+8")
public let timeLocal = Locale(identifier: "zh_CN")
//MARK: - 日期格式
public extension Date{
   
    
    //当前时间的格式化
    func toString(format:String)->String{
        let date = Date()
        let _format = DateFormatter()
        _format.timeZone = timeZone
        _format.locale = timeLocal
        _format.dateFormat = format
        return _format.string(from: date)
    }
    
    static func dateStr(date:String,origmat:String,format:String) ->String{
        let _format = DateFormatter()
        _format.timeZone = timeZone
        _format.dateFormat = origmat
        _format.locale = timeLocal
        guard let d = _format.date(from: date) else { return date }
        _format.dateFormat = format
        return _format.string(from: d)
        
    }
    
    static func dateFromeString(date:String,origmat:String)->Date?{
        
        let _format = DateFormatter()
        _format.timeZone = timeZone
        _format.locale = timeLocal
        _format.dateFormat = origmat
        return _format.date(from: date)
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

public extension Date{
    /// 时间戳转换时间字符串
    /// - Parameters:
    ///   - timeStamp: 时间戳
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间字符串
    static func getTimeString(timeStamp: Int, dateFormat: String) -> String {
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        dfmatter.timeZone = timeZone
        dfmatter.locale = timeLocal
        //yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat = dateFormat
        return dfmatter.string(from: date as Date)
    }

    /// 时间戳转换时间字符串
    /// - Parameters:
    ///   - millisecond: 时间戳（毫秒）
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间字符串
    static func getTimeString(millisecond: Int, dateFormat: String) -> String {
        let timeSta:TimeInterval = TimeInterval(millisecond)
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        dfmatter.timeZone = timeZone
        dfmatter.locale = timeLocal
        //yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat = dateFormat
        return dfmatter.string(from: date as Date)
    }

    // 通过时间格式返回时间戳
    func getTimeStamByFormat(formatStr: String) ->Int64? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat="yyyy-MM-dd"
        let date = dateformatter.date(from: formatStr)!
        let interval = CLongLong(round(date.timeIntervalSince1970*1000))
        return interval
    }
}
