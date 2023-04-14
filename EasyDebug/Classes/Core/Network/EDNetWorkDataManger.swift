//
//  EDNetWorkDataManger.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/1.
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

class EDNetWorkManger {
    
    static let shared = EDNetWorkManger()
    var current: EDNetWorkStructure = EDNetWorkStructure()
    var netWorkDataSources = [EDNetWorkStructure]()
    var blacklist = [String]()
    let blacklistKey = "blacklistKey"
    
    init(){
        if let list = UserDefaults.standard.object(forKey: self.blacklistKey) as? [String] {
            self.blacklist = list
        }
    }
}

extension EDNetWorkManger {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionTask, didReceive data: Data) {
        guard let request = dataTask.originalRequest,
              let response = dataTask.response as? HTTPURLResponse else {
            return
        }
        
        let metric = self.current.sessionTaskMetrics.transactionMetrics.last
        
        /// 请求行
        self.current.requestLine.httpMethod = request.httpMethod
        self.current.requestLine.url = request.url
        self.current.requestLine.protocolVersion = metric?.networkProtocolName
        
        /// 请求头
        self.current.edRequestHeader.values = request.allHTTPHeaderFields
        
        /// 请求体
        if let data = request.httpBody {
            self.current.edRequestBodyInfo.values = String(data: data, encoding: .utf8)
            self.current.edRequestBodyInfo.size = data.count
        }
        if request.httpBodyStream != nil {
            let _data = Data.reading(stream: request.httpBodyStream!)
            self.current.edRequestBodyInfo.values = String(data: _data, encoding: .utf8)
            self.current.edRequestBodyInfo.size = _data.count
        }
        /// 解析URL 参数
        if let _p = request.url?.urlParameters,
           let str = EDCommon.getJsonString(rawValue: _p),
           let _data = str.data(using: .utf8){
            self.current.edRequestBodyInfo.values = String(data: _data, encoding: .utf8)
            self.current.edRequestBodyInfo.size = _data.count
        }
        
        /// 响应行
        self.current.responseStateLine.httpMethod = self.current.requestLine.httpMethod
        self.current.responseStateLine.url = response.url
        self.current.responseStateLine.protocolVersion = self.current.requestLine.protocolVersion
        self.current.responseStateLine.statusCode = response.statusCode
        
        /// 响应头
        self.current.edReponseHeader.values = response.allHeaderFields as? [String: String]
        /// 响应体
        self.current.edResponseBodyInfo.values = String(data: data, encoding: .utf8)
        self.current.edResponseBodyInfo.size = data.count
        /// 耗时
        self.current.startDate = self.current.sessionTaskMetrics.taskInterval.start
        self.current.endDate = self.current.sessionTaskMetrics.taskInterval.end
        self.current.timeElapsed = self.current.sessionTaskMetrics.taskInterval.duration
        /// 记录请求
        EDNetWorkManger.shared.netWorkDataSources.insert(self.current, at: 0)
    }
}

public extension URL {
    var urlParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
