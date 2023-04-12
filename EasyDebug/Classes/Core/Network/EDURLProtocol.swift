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

class EDURLProtocol: URLProtocol, URLSessionDataDelegate, URLSessionTaskDelegate{
    
    fileprivate var dataTask:URLSessionDataTask?
    fileprivate let sessionDelegateQueue = OperationQueue()
    
    fileprivate var netWorkStructure = EDNetWorkStructure()
    fileprivate var receiveData = Data()

    class func startMonitor(){
        let sessionConfiguration = EDSwizzleNetwork.shared
        URLProtocol.registerClass(EDURLProtocol.self)
        if !sessionConfiguration.isSwizzle{
            sessionConfiguration.load()
        }
    }
    
    class func stopMonitor(){
        let sessionConfiguration = EDSwizzleNetwork.shared
        URLProtocol.unregisterClass(EDURLProtocol.self)
        if sessionConfiguration.isSwizzle{
            sessionConfiguration.unload()
        }
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "EDURLProtocolHandledKey", in: request) != nil {
            return false
        }
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        let mutableReqeust = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        
        URLProtocol.setProperty(true, forKey: "EDURLProtocolHandledKey",
                                in: mutableReqeust)
        return mutableReqeust as URLRequest
    }
    
    override func startLoading() {
        self.netWorkStructure = EDNetWorkStructure()
        let defaultConfigObj = URLSessionConfiguration.default
        sessionDelegateQueue.maxConcurrentOperationCount = 1
        sessionDelegateQueue.name = "com.ed.session.queue"
        let defaultSession = Foundation.URLSession(configuration: defaultConfigObj,
                                                   delegate: self, delegateQueue: sessionDelegateQueue)
        dataTask = defaultSession.dataTask(with: self.request)
        dataTask!.resume()
    }
    
    override func stopLoading() {
        dataTask?.cancel()
        dataTask = nil
    }
    
    //MARK:  URLSessionTaskDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
        self.dataTask = nil
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        self.netWorkStructure.sessionTaskMetrics = metrics
        self.netWorkStructure.urlSession(session, dataTask: task, didReceive: receiveData)
    }
    

    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
    }
    //MARK:  URLSessionDataDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        receiveData = data
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        completionHandler(.allow)
    }
}

protocol EDSwizzleable: NSObject {
    var isSwizzle: Bool {get set}

    func load()
    
    func unload()
    
    func swizzleInstanceSelector(selector: Selector, fromClass: AnyClass, toClass: AnyClass)
    
    func swizzleClassSelector(selector: Selector, fromClass: AnyClass, toClass: AnyClass)
}

extension EDSwizzleable {
    
    func swizzleInstanceSelector(selector: Selector, fromClass: AnyClass, toClass: AnyClass) {
        let originalMethod = class_getInstanceMethod(fromClass, selector)
        let stubMethod = class_getInstanceMethod(toClass, selector)
        guard originalMethod != nil && stubMethod != nil else { return }
        method_exchangeImplementations(originalMethod!, stubMethod!)
    }
    
    func swizzleClassSelector(selector: Selector, fromClass: AnyClass, toClass: AnyClass) {
        let originalMethod = class_getClassMethod(fromClass, selector)
        let stubMethod = class_getClassMethod(toClass, selector)
        guard originalMethod != nil && stubMethod != nil else { return }
        method_exchangeImplementations(originalMethod!, stubMethod!)
    }
}

class EDSwizzleNetwork: NSObject, EDSwizzleable {
    
    static let shared = EDSwizzleNetwork()
    
    var isSwizzle = false
    
    func load(){
        isSwizzle = true
        guard let cls = NSClassFromString("__NSCFURLSessionConfiguration") ?? NSClassFromString("NSURLSessionConfiguration") else { return }
        swizzleInstanceSelector(selector: #selector(protocolClasses), fromClass: cls, toClass: EDSwizzleNetwork.self)
    }
    
    func unload(){
        isSwizzle = false
        guard let cls = NSClassFromString("__NSCFURLSessionConfiguration") ?? NSClassFromString("NSURLSessionConfiguration") else { return }
        swizzleInstanceSelector(selector: #selector(protocolClasses), fromClass: cls, toClass: EDSwizzleNetwork.self)
    }
    
    @objc func protocolClasses() -> NSArray{
        return [EDURLProtocol.self]
    }
}
