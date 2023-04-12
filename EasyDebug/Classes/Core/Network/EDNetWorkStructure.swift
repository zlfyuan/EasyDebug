//
//  EDNetWorkStructure.swift
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

class EDNetWorkStructure {
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    var timeElapsed: TimeInterval = 0
    var sessionTaskMetrics = URLSessionTaskMetrics()
    let requestLine = EDStateLine()
    let edRequestHeader = EDInfoHeader()
    let edRequestBodyInfo = EDBodyInfo()
   
    let responseStateLine = EDStateLine()
    let edReponseHeader = EDInfoHeader()
    let edResponseBodyInfo = EDBodyInfo()
}

extension EDNetWorkStructure: CustomStringConvertible {
    var description: String {
        
        var json = self.responseStateLine.value
        json["Request headers"] = self.edRequestHeader.value["values"]
        if let _body = self.edRequestBodyInfo.value["values"] as? String {
            json["Request body"] = EDCommon.getObject(jsonString: _body)
        }else{
            json["Request body"] = nil
        }
        
        json["Response headers"] = self.edReponseHeader.value["values"]
        if let _body = self.edResponseBodyInfo.value["values"] as? String {
            json["Response body"] = EDCommon.getObject(jsonString: _body)
        }else{
            json["Response body"] = nil
        }
        if let str = EDCommon.getJsonString(rawValue: json) {
            return str.replacingOccurrences(of: "\\", with: "")
        }
        return "null"
    }
}

extension EDNetWorkStructure {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionTask, didReceive data: Data) {
        guard let request = dataTask.originalRequest,
              let response = dataTask.response as? HTTPURLResponse else {
            return
        }
        
        let metric = self.sessionTaskMetrics.transactionMetrics.last
        
        /// 请求行
        requestLine.httpMethod = request.httpMethod
        requestLine.url = request.url
        requestLine.protocolVersion = metric?.networkProtocolName
        
        /// 请求头
        edRequestHeader.values = request.allHTTPHeaderFields
        
        /// 请求体
        if let data = request.httpBody {
            edRequestBodyInfo.values = String(data: data, encoding: .utf8)
            edRequestBodyInfo.size = data.count
        }
        if request.httpBodyStream != nil {
            let _data = Data.reading(stream: request.httpBodyStream!)
            edRequestBodyInfo.values = String(data: _data, encoding: .utf8)
            edRequestBodyInfo.size = _data.count
        }
        /// 解析URL 参数
        if let _p = request.url?.urlParameters,
           let str = EDCommon.getJsonString(rawValue: _p),
           let _data = str.data(using: .utf8){
            edRequestBodyInfo.values = String(data: _data, encoding: .utf8)
            edRequestBodyInfo.size = _data.count
        }
        
        /// 响应行
        responseStateLine.httpMethod = requestLine.httpMethod
        responseStateLine.url = response.url
        responseStateLine.protocolVersion = requestLine.protocolVersion
        responseStateLine.statusCode = response.statusCode
        
        /// 响应头
        edReponseHeader.values = response.allHeaderFields as? [String: String]
        /// 响应体
        edResponseBodyInfo.values = String(data: data, encoding: .utf8)
        edResponseBodyInfo.size = data.count
        /// 耗时
        startDate = self.sessionTaskMetrics.taskInterval.start
        endDate = self.sessionTaskMetrics.taskInterval.end
        timeElapsed = self.sessionTaskMetrics.taskInterval.duration
        /// 记录请求
        EDNetWorkManger.shared.netWorkDataSources.insert(self, at: 0)
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

