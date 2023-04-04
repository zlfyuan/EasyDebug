//
//  EDURLProtocol.swift
//  EasyDebug
//
//  Created by zluof on 2023/3/31.
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
public class ZLFSerializaLogFormat {
public var rawValue : AnyObject? = nil

public init?(rawValue:Any) {
    do{
        let s = try JSONSerialization.data(withJSONObject: rawValue, options: JSONSerialization.WritingOptions.prettyPrinted)
        let e = NSString.init(data: s, encoding: String.Encoding.utf8.rawValue)
        self.rawValue = e
    }catch let error{
        print(error)
    }
}
}
