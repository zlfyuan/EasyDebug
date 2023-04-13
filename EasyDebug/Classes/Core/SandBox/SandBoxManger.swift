//
//  SandBoxManger.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/7.
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

class SandBoxManger {
    
    static let shared = SandBoxManger()
    
    private let fileManger = FileManager.default
    
    var fileDataList = [FileDataModel]()
    
    var directoryList: [URL] = [URL]()
    
    init(){
        self.refreshFiles()
    }
    
    func refreshFiles() {
        let fileManger = self.fileManger
        let library = fileManger.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let doc = fileManger.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let tempPath = NSTemporaryDirectory()
        
        directoryList.append(library)
        directoryList.append(doc)
        directoryList.append(URL.init(fileURLWithPath: tempPath))
        
        let rootFiles = directoryList.map({ f in
            let model = createFileDataModel(use: f)
            model.subFiles = listFilesInDirectory(path: f.path)
            
            let size = folderSize(atPath: f.path)
            model.sizeStr = EDCommon.formatFileSize(size)
            return model
        })
        
        fileDataList = rootFiles
    }
    
    func createFileDataModel(use path: URL) -> FileDataModel {
        let model = FileDataModel()
        model.name = path.lastPathComponent
        model.pathUrl = path
        do {
            let fileManger = FileManager.default
            let fileAttributes = try fileManger.attributesOfItem(atPath: path.path)
            
            if let fileSize = fileAttributes[.size] as? UInt64 {
                model.size = fileSize
            }
            
            if let creationDate = fileAttributes[FileAttributeKey.creationDate] as? Date {
                
                model.createDate = creationDate
            }
            
            if let modificationDate = fileAttributes[FileAttributeKey.modificationDate] as? Date {
                
                model.modificationDate = modificationDate
            }
            
        } catch let error as NSError {
            EDLogError("Get attributes errer: \(error)")
        }
        return model
    }
    
    func listFilesInDirectory(path: String) -> [FileDataModel] {
        let fileManager = FileManager.default
        var result = [String]()
        
        var models = [FileDataModel]()
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            
            for file in files {
                let fullPath = "\(path)/\(file)"
                var isDir : ObjCBool = false
                if fileManager.fileExists(atPath: fullPath, isDirectory:&isDir) {
                    if isDir.boolValue {
                        // 如果是目录，则递归遍历子目录
                        let model = createFileDataModel(use: URL.init(fileURLWithPath: fullPath))
                        let size = folderSize(atPath: fullPath)
                        model.sizeStr = EDCommon.formatFileSize(size)
                        model.subFiles = listFilesInDirectory(path: fullPath)
                        models.append(model)
                    } else {
                        // 如果是文件，则添加到结果数组中
                        result.append(fullPath)
                        let fileUrl = URL.init(fileURLWithPath: fullPath)
                        let model = createFileDataModel(use: fileUrl)
                        model.sizeStr = EDCommon.formatFileSize(model.size)
                        model.fileType = EDFileType.init(rawValue: fileUrl.pathExtension) ?? .none
                        models.append(model)
                    }
                }
            }
        } catch {
            EDLogError("Error while enumerating files \(path): \(error.localizedDescription)")
        }
        
        return models
    }
    
    func folderSize(atPath path: String) -> UInt64 {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                var folderSize: UInt64 = 0
                if let files = fileManager.enumerator(atPath: path) {
                    for case let file as String in files {
                        let filePath = (path as NSString).appendingPathComponent(file)
                        if let fileAttributes = try? fileManager.attributesOfItem(atPath: filePath) {
                            folderSize += fileAttributes[.size] as? UInt64 ?? 0
                        }
                    }
                }
                return folderSize
            } else {
                if let fileAttributes = try? fileManager.attributesOfItem(atPath: path) {
                    return fileAttributes[.size] as? UInt64 ?? 0
                }
            }
        }
        return 0
    }
    
    fileprivate static func readTextFile(named filename: URL) -> Any? {
        do {
            let contents = try String(contentsOf: filename)
            return contents
        } catch {
            EDLogError("Error: \(error)")
            return nil
        }
    }
    
   fileprivate static func readJSONFile(named filename: URL) -> Any? {
        do {
            let contents = try Data(contentsOf: filename)
            let json = try JSONSerialization.jsonObject(with: contents, options: [])
            return EDCommon.getJsonString(rawValue: json)
        } catch {
            EDLogError("Error: \(error)")
            return nil
        }
        
    }
    
    fileprivate static func readPlistFile(named filename: URL) -> Any? {
        
        func couvertFormat(object: [String: Any]) -> [String: Any] {
            var dicContents = [String: Any]()
            object.forEach { (key: String, value: Any) in
                dicContents[key] = value
                if let _date = value as? Date {
                    dicContents[key] = _date.description
                }
                if let _data = value as? Data {
                    dicContents[key] = _data.description
                }
                if let _dic = value as? [String: Any] {
                    dicContents[key] = couvertFormat(object: _dic)
                }
            }
            return dicContents
        }
        
        do {
            let contents = try Data(contentsOf: filename)
            guard let plist = try PropertyListSerialization.propertyList(from: contents, options: [], format: nil) as? [String: Any] else {
                return nil
            }
            let dicContents = couvertFormat(object: plist)
            return EDCommon.getJsonString(rawValue: dicContents)
        } catch {
            EDLogError("Error: \(error)")
            return nil
        }
    }
    
    static func readFile(model fileModel: FileDataModel) -> Any? {
        switch fileModel.fileType {
        case .plist:
            return readPlistFile(named: fileModel.pathUrl!)
        case .text,
            .txt:
            return readTextFile(named: fileModel.pathUrl!)
        case .json:
            return readJSONFile(named: fileModel.pathUrl!)
        case .none:
            return readTextFile(named: fileModel.pathUrl!)
        }
    }
}
