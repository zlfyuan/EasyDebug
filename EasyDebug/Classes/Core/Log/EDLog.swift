//
//  EDLog.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/11..
//  Copyright © 2023 zlfyuan. All rights reserved.
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

import CocoaLumberjack

class EDLogFormatter: NSObject, DDLogFormatter {
    
    func format(message logMessage: DDLogMessage) -> String? {
        if logMessage.level == .warning {
            // ⚠️
        }else if logMessage.level == .debug {
            // debug
        }
        let date = getLocalDate()
        logMessage.setValue(date, forKey: "timestamp")
        let formatLog = "\(date.toString(format: "yyyy-MM:dd HH:mm.ss.SSSS")) [\(logMessage.fileName)] line:\(logMessage.line) \(logMessage.message)"
        return formatLog
    }
    
    func getLocalDate() -> Date {
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        let localDate = Date(timeInterval: TimeInterval(interval), since: date)
        return localDate
    }
    
}

struct EDLogData {
    let date: String
    let fileName: String
    let line: String
    let info: String
}

class EDLog {
    
    static let shared = EDLog()
    
    var level = DDLogLevel.all
    
    var logInfo:[EDLogData] = [EDLogData]()
    
    var currentLogFilePath: String = EDCommon.placeholder
    
    func config() {
        
        DDTTYLogger.sharedInstance?.logFormatter = EDLogFormatter()
        DDLog.add(DDTTYLogger.sharedInstance!, with: level)
        
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.logFormatter = EDLogFormatter()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        
        currentLogFilePath = fileLogger.currentLogFileInfo?.filePath ?? EDCommon.placeholder
        
    }
    
    func setLevel(_ level: DDLogLevel) {
        DDLog.add(DDOSLogger.sharedInstance, with: level)
    }
    
    func getLogData() -> [EDLogData] {
        
        let fileUrl = URL.init(fileURLWithPath: currentLogFilePath)
        do {
            let fileContent = try String(contentsOf: fileUrl, encoding: .utf8)
            let lines = fileContent.components(separatedBy: "\n")
            guard lines.count > 0 else {
                return logInfo
            }
            logInfo = lines.map { str in
                guard str.count > 0 else {
                    return EDLogData(date: EDCommon.placeholder, fileName: EDCommon.placeholder, line: EDCommon.placeholder, info: EDCommon.placeholder)
                }
                let infos = str.components(separatedBy: " ")
                guard let date = infos[0] as? String,
                      let file = infos[1] as? String,
                      let line = infos[2] as? String,
                      let info = infos[3] as? String else{
                    return EDLogData(date: EDCommon.placeholder, fileName: EDCommon.placeholder, line: EDCommon.placeholder, info: EDCommon.placeholder)
                }
                let log = EDLogData(date: date, fileName: file, line: line, info: info)
                return log
            }
        } catch {
            EDLogError("Error reading file: \(error)")
        }
        return logInfo
    }
}


public func EDLogDebug(_ message: @autoclosure () -> Any,
                       level: DDLogLevel = DDDefaultLogLevel,
                       context: Int = 0,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line,
                       tag: Any? = nil,
                       asynchronous async: Bool = asyncLoggingEnabled,
                       ddlog: DDLog = .sharedInstance) {
    DDLogDebug(message(),
                  level: level,
                  context: context,
                  file: file,
                  function: function,
                  line: line,
                  tag: tag,
                  asynchronous: async,
                  ddlog: ddlog)
}

public func EDLogInfo(_ message: @autoclosure () -> Any,
                      level: DDLogLevel = DDDefaultLogLevel,
                      context: Int = 0,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line,
                      tag: Any? = nil,
                      asynchronous async: Bool = asyncLoggingEnabled,
                      ddlog: DDLog = .sharedInstance) {
    DDLogInfo(message(),
                  level: level,
                  context: context,
                  file: file,
                  function: function,
                  line: line,
                  tag: tag,
                  asynchronous: async,
                  ddlog: ddlog)
}


public func EDLogWarn(_ message: @autoclosure () -> Any,
                      level: DDLogLevel = DDDefaultLogLevel,
                      context: Int = 0,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line,
                      tag: Any? = nil,
                      asynchronous async: Bool = asyncLoggingEnabled,
                      ddlog: DDLog = .sharedInstance) {
    DDLogWarn(message(),
                  level: level,
                  context: context,
                  file: file,
                  function: function,
                  line: line,
                  tag: tag,
                  asynchronous: async,
                  ddlog: ddlog)
}

public func EDLogVerbose(_ message: @autoclosure () -> Any,
                         level: DDLogLevel = DDDefaultLogLevel,
                         context: Int = 0,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line,
                         tag: Any? = nil,
                         asynchronous async: Bool = asyncLoggingEnabled,
                         ddlog: DDLog = .sharedInstance) {
    DDLogVerbose(message(),
                  level: level,
                  context: context,
                  file: file,
                  function: function,
                  line: line,
                  tag: tag,
                  asynchronous: async,
                  ddlog: ddlog)
}

public func EDLogError(_ message: @autoclosure () -> Any,
                       level: DDLogLevel = DDDefaultLogLevel,
                       context: Int = 0,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line,
                       tag: Any? = nil,
                       asynchronous async: Bool = false,
                       ddlog: DDLog = .sharedInstance) {
    DDLogError(message(),
                  level: level,
                  context: context,
                  file: file,
                  function: function,
                  line: line,
                  tag: tag,
                  asynchronous: async,
                  ddlog: ddlog)
}
