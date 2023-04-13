//
//  EDNetWorkData.swift
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

class EDStateLine: EDJSONEncoder {
    var httpMethod: String? = nil
    var url: URL? = nil
    var protocolVersion: String? = nil
    var statusCode: Int = -1
}

class EDInfoHeader: EDJSONEncoder {
    var values: [String: String]? = nil
}

class EDBodyInfo: EDJSONEncoder {
    var values: String? = nil
    var size:Int = 0
}

class EDRequestInfo {
    var stateLine: EDStateLine? = nil
    var requestInfoHeader: EDInfoHeader? = nil
    var requestBodyInfo: EDBodyInfo? = nil
}

class EDResponseInfo {
    var stateLine: EDStateLine? = nil
    var reponseInfoHeader: EDInfoHeader? = nil
    var reponseBodyInfo: EDBodyInfo? = nil
}

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
