//
//  EDURLProtocol.swift
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

import Foundation
import ObjectiveC.runtime

class EDNetwork: NSObject {
    
    static let shared = EDNetwork()
    
    fileprivate var isSwizzle = false
    
    class func startIntercept(){
        let sessionConfiguration = EDNetwork.shared
        URLProtocol.registerClass(EDURLProtocol.self)
        if !sessionConfiguration.isSwizzle{
            sessionConfiguration.isSwizzle = true
            guard let cls = NSClassFromString("__NSCFURLSessionConfiguration") ?? NSClassFromString("NSURLSessionConfiguration") else { return }
            sessionConfiguration.swizzleInstanceSelector(selector: #selector(protocolClasses), fromClass: cls, toClass: EDNetwork.self)
        }
    }
    
    class func stopIntercept(){
        let sessionConfiguration = EDNetwork.shared
        URLProtocol.unregisterClass(EDURLProtocol.self)
        if sessionConfiguration.isSwizzle{
            sessionConfiguration.isSwizzle = false
            guard let cls = NSClassFromString("__NSCFURLSessionConfiguration") ?? NSClassFromString("NSURLSessionConfiguration") else { return }
            sessionConfiguration.swizzleInstanceSelector(selector: #selector(protocolClasses), fromClass: cls, toClass: EDNetwork.self)
        }
    }
    
    @objc func protocolClasses() -> NSArray {
        return [EDURLProtocol.self]
    }
    
    fileprivate func swizzleInstanceSelector(selector: Selector, fromClass: AnyClass, toClass: AnyClass) {
        let originalMethod = class_getInstanceMethod(fromClass, selector)
        let stubMethod = class_getInstanceMethod(toClass, selector)
        guard originalMethod != nil && stubMethod != nil else { return }
        method_exchangeImplementations(originalMethod!, stubMethod!)
    }
    
    fileprivate func swizzleClassSelector(selector: Selector, fromClass: AnyClass, toClass: AnyClass) {
        let originalMethod = class_getClassMethod(fromClass, selector)
        let stubMethod = class_getClassMethod(toClass, selector)
        guard originalMethod != nil && stubMethod != nil else { return }
        method_exchangeImplementations(originalMethod!, stubMethod!)
    }
}


class EDURLProtocol: URLProtocol, URLSessionDataDelegate, URLSessionTaskDelegate{
    
    fileprivate var dataTask:URLSessionDataTask?
    fileprivate let sessionDelegateQueue = OperationQueue()
    fileprivate var urlSession: URLSession?
    fileprivate var metrics = URLSessionTaskMetrics()
    fileprivate var response: URLResponse?
    fileprivate var data: Data?
    fileprivate var error: Error?
    
    
    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "EDURLProtocolHandledKey", in: request) != nil {
            return false
        }
        if let fileTyep = request.value(forHTTPHeaderField: "Content-Type"),
            fileTyep.contains("multipart/form-data") {
            return false
        }
        guard let scheme = request.url?.scheme,
              let host = request.url?.host else{
            return false
        }
        if scheme != "http" && scheme != "https" {
            return false
        }
        if EDNetWorkManger.shared.blacklist.contains(where: { $0 == host }) {
            return false
        }
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        let mutableRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: "EDURLProtocolHandledKey", in: mutableRequest)
        return mutableRequest as URLRequest
    }
    
    override func startLoading() {
        let defaultConfigObj = URLSessionConfiguration.default
        self.sessionDelegateQueue.maxConcurrentOperationCount = 1
        self.sessionDelegateQueue.name = "com.ed.session.queue"
        self.data = Data()
        
        let defaultSession = Foundation.URLSession(configuration: defaultConfigObj,
                                                   delegate: self, delegateQueue: sessionDelegateQueue)
        self.urlSession = defaultSession
        self.dataTask = defaultSession.dataTask(with: self.request)
        self.dataTask!.resume()
    }
    
    override func stopLoading() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            EDNetWorkManger.shared.parseData(self.data, self.response, self.request, self.error, self.metrics)
        }
        self.dataTask?.cancel()
        self.dataTask = nil
    }
    
    //MARK:  URLSessionTaskDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            self.error = error
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
        self.dataTask = nil
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        self.metrics = metrics
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
    }
    
    //MARK:  URLSessionDataDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data?.append(data)
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.response = response
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        completionHandler(.allow)
    }
}
