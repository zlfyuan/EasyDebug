//
//  EDLog.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/11.
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

class EDLogData {
    
    var date: Date
    var fileName: String
    var line: String
    var message: String
    var level: EDLogLevel
    
    init(date: Date, fileName: String, line: String, message: String, level: EDLogLevel) {
        self.date = date
        self.fileName = fileName
        self.line = line
        self.message = message
        self.level = level
    }
}

class EDLog {
    
    static let shared = EDLog()
    
    var logInfo:[EDLogData] = [EDLogData]()
    
    func getLocalDate() -> Date {
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        let localDate = Date(timeInterval: TimeInterval(interval), since: date)
        return localDate
    }
    
    func log(_ message: @autoclosure () -> Any,
                    level: EDLogLevel = .default,
                    file: StaticString = #file,
                    function: StaticString = #function,
                    line: UInt = #line,
                    tag: Any? = nil) {
        let _message = message()
        let date = getLocalDate()
        let fileName = file.description.components(separatedBy: "/").last ?? file.description
        let formatLog = "\(date.toString(format: "yyyy-MM-dd-HH:mm.ss.SSSS")) [\(fileName)] line:\(line) \(level.rawValue) \(_message)"
        print(formatLog)
        
        let log = EDLogData(date: date, fileName: fileName, line: "\(line)", message: "\(_message)", level: level)
        logInfo.insert(log, at: 0)
    }

}


public func EDLogDebug(_ message: @autoclosure () -> Any,
                       context: Int = 0,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line,
                       tag: Any? = nil) {
    EDLog.shared.log(message(),
                     level: .debug,
                     file: file,
                     function: function,
                     line: line,
                     tag: tag)
}

public func EDLogInfo(_ message: @autoclosure () -> Any,
                      context: Int = 0,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line,
                      tag: Any? = nil){
    EDLog.shared.log(message(),
                     level: .info,
                     file: file,
                     function: function,
                     line: line,
                     tag: tag)
}


public func EDLogWarn(_ message: @autoclosure () -> Any,
                      context: Int = 0,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line,
                      tag: Any? = nil) {
    EDLog.shared.log(message(),
                     level: .warning,
                     file: file,
                     function: function,
                     line: line,
                     tag: tag)
}

public func EDLogVerbose(_ message: @autoclosure () -> Any,
                         context: Int = 0,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line,
                         tag: Any? = nil) {
    EDLog.shared.log(message(),
                     level: .verbose,
                     file: file,
                     function: function,
                     line: line,
                     tag: tag)
}

public func EDLogError(_ message: @autoclosure () -> Any,
                       context: Int = 0,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line,
                       tag: Any? = nil) {
    EDLog.shared.log(message(),
                     level: .error,
                     file: file,
                     function: function,
                     line: line,
                     tag: tag)
}
