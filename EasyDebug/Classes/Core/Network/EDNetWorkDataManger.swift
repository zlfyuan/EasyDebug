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
    fileprivate var semaphore = DispatchSemaphore(value: 1)
    init(){
        if let list = UserDefaults.standard.object(forKey: self.blacklistKey) as? [String] {
            self.blacklist = list
        }
    }
    
    func addNetWorkDataSources(_ source:EDNetWorkStructure) {
        semaphore.wait()
        netWorkDataSources.insert(source, at: 0)
        semaphore.signal()
    }
    
    func clearAllNetWorkDataSources(){
        semaphore.wait()
        netWorkDataSources.removeAll()
        semaphore.signal()
    }
}

extension EDNetWorkManger {
    
    func parseData(_ data: Data?, _ response: URLResponse?, _ request: URLRequest, _ error: Error?, _ metrics: URLSessionTaskMetrics) {
        guard let response = response as? HTTPURLResponse else {
            return
        }
        let metric = metrics.transactionMetrics.last
        let structure = EDNetWorkStructure()
        /// 请求行
        structure.requestLine.httpMethod = request.httpMethod
        structure.requestLine.url = request.url
        structure.requestLine.protocolVersion = metric?.networkProtocolName
        
        /// 请求头
        structure.edRequestHeader.values = request.allHTTPHeaderFields
        
        /// 请求体
        if let data = request.httpBody {
            structure.edRequestBodyInfo.values = String(data: data, encoding: .utf8)
            structure.edRequestBodyInfo.size = data.count
        }
        if request.httpBodyStream != nil {
            let _data = Data.reading(stream: request.httpBodyStream!)
            structure.edRequestBodyInfo.values = String(data: _data, encoding: .utf8)
            structure.edRequestBodyInfo.size = _data.count
        }
        /// 解析URL 参数
        if let _p = request.url?.urlParameters,
           let str = EDCommon.getJsonString(rawValue: _p),
           let _data = str.data(using: .utf8){
            structure.edRequestBodyInfo.values = String(data: _data, encoding: .utf8)
            structure.edRequestBodyInfo.size = _data.count
        }
        
        /// 响应行
        structure.responseStateLine.httpMethod = structure.requestLine.httpMethod
        structure.responseStateLine.url = request.url
        structure.responseStateLine.protocolVersion = structure.requestLine.protocolVersion
        structure.responseStateLine.statusCode = response.statusCode
        
        /// 响应头
        structure.edReponseHeader.values = response.allHeaderFields as? [String: String]
        /// 响应体
        if let _data = data {
            structure.edResponseBodyInfo.values = String(data: _data, encoding: .utf8)
            structure.edResponseBodyInfo.size = _data.count
        }
       
        /// 耗时
        
            for sessionMetric in metrics.transactionMetrics {
                let dom = {
                    if let domainLookupStartDate = sessionMetric.domainLookupStartDate?.timeIntervalSince1970,
                       let domainLookupEndDate = sessionMetric.domainLookupEndDate?.timeIntervalSince1970 {
                        return (domainLookupEndDate - domainLookupStartDate) * 1000
                    }
                    return 0
                }()
                
                let sec = {
                    if let secureConnectionStartDate = sessionMetric.secureConnectionStartDate?.timeIntervalSince1970,
                       let secureConnectionEndDate = sessionMetric.secureConnectionEndDate?.timeIntervalSince1970 {
                        return (secureConnectionEndDate - secureConnectionEndDate) * 1000
                    }
                    return 0
                }()
                
                let con = {
                    if let connectStartDate = sessionMetric.connectStartDate?.timeIntervalSince1970,
                       let connectEndDate = sessionMetric.connectEndDate?.timeIntervalSince1970 {
                        return (connectEndDate - connectStartDate) * 1000
                    }
                    return 0
                }()
                
                let req = {
                    if let requestStartDate = sessionMetric.requestStartDate?.timeIntervalSince1970,
                       let requestEndDate = sessionMetric.requestEndDate?.timeIntervalSince1970 {
                        return (requestEndDate - requestStartDate) * 1000
                    }
                    return 0
                }()
                
                let res = {
                    if let responseStartDate = sessionMetric.responseStartDate?.timeIntervalSince1970,
                       let responseEndDate = sessionMetric.responseEndDate?.timeIntervalSince1970 {
                        return (responseEndDate - responseStartDate) * 1000
                    }
                    return 0
                }()
                
                let tot = {
                    if let fetchStartDate = sessionMetric.fetchStartDate?.timeIntervalSince1970,
                       let responseEndDate = sessionMetric.responseEndDate?.timeIntervalSince1970 {
                        structure.startDate = sessionMetric.fetchStartDate!
                        structure.endDate = sessionMetric.responseEndDate!
                        structure.timeElapsed =  (responseEndDate - fetchStartDate) * 1000
                        return structure.timeElapsed
                    }
                    return 0
                }()
                var locip = ""
                var remip = ""
                if #available(iOS 13.0, *) {
                    locip = "\(sessionMetric.localAddress ?? "")"
                    remip = "\(sessionMetric.remoteAddress ?? "")"
                }
                print("metric path:\(sessionMetric.request.url?.lastPathComponent) 总耗时:\(tot)ms, 域名解析:\(dom)ms, 连接耗时:\(con)ms(包括TLS:\(sec)ms), 请求:\(req)ms, 回调:\(res)ms l:\(locip) r:\(remip)")
        }
        /// 记录请求
        EDNetWorkManger.shared.addNetWorkDataSources(structure)
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
