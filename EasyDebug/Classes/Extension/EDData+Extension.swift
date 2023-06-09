//
//  EDData+Extension.swift
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

extension Data {
    
    static func reading(stream: InputStream) -> Data {
        stream.open()
        var data = Data()
        let bufferSize = 1024*1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer {
            buffer.deallocate()
        }
        while stream.hasBytesAvailable {
            let bytesRead = stream.read(buffer, maxLength: bufferSize)
            if bytesRead < 0 {
                if let error = stream.streamError {
                    EDLogError("Input stream error: \(error.localizedDescription)")
                }
                break
            }
            data.append(buffer, count: bytesRead)
        }
        stream.close()
        return data
    }
    
    enum ImageType {
        case unknown
        case jpeg
        case tiff
        case bmp
        case ico
        case icns
        case gif
        case png
        case webp
    }
    
    func detectImageType() -> Data.ImageType {
        if self.count < 16 { return .unknown }
        
        var value = [UInt8](repeating:0, count:1)
        
        self.copyBytes(to: &value, count: 1)
        
        switch value[0] {
        case 0x4D, 0x49:
            return .tiff
        case 0x00:
            return .ico
        case 0x69:
            return .icns
        case 0x47:
            return .gif
        case 0x89:
            return .png
        case 0xFF:
            return .jpeg
        case 0x42:
            return .bmp
        case 0x52:
            let subData = self.subdata(in: Range(NSMakeRange(0, 12))!)
            if let infoString = String(data: subData, encoding: .ascii) {
                if infoString.hasPrefix("RIFF") && infoString.hasSuffix("WEBP") {
                    return .webp
                }
            }
            break
        default:
            break
        }
        
        return .unknown
    }
    
    static func detectImageType(with data: Data) -> Data.ImageType {
        return data.detectImageType()
    }
    
    static func detectImageType(with url: URL) -> Data.ImageType {
        if let data = try? Data(contentsOf: url) {
            return data.detectImageType()
        } else {
            return .unknown
        }
    }
    
    static func detectImageType(with filePath: String) -> Data.ImageType {
        let pathUrl = URL(fileURLWithPath: filePath)
        if let data = try? Data(contentsOf: pathUrl) {
            return data.detectImageType()
        } else {
            return .unknown
        }
    }
    
    static func detectImageType(with imageName: String, bundle: Bundle = Bundle.main) -> Data.ImageType? {
        
        guard let path = bundle.path(forResource: imageName, ofType: "") else { return nil }
        let pathUrl = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: pathUrl) {
            return data.detectImageType()
        } else {
            return nil
        }
    }
}
