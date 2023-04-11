//
//  SandBoxManger.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/7.
//

import Foundation
import MobileCoreServices

class FileDataModel {
    var name: String = EDCommon.placeholder
    var createDate: Date = Date()
    var modificationDate:Date = Date()
    var pathUrl: URL? = nil
    var size: UInt64 = 0
    var sizeStr: String = "-"
    var subFiles: [FileDataModel] = [FileDataModel]()
}

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
        let cache = fileManger.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let tempPath = NSTemporaryDirectory()
        
        directoryList.append(library)
        directoryList.append(cache)
        directoryList.append(URL.init(fileURLWithPath: tempPath))
        
        let rootFiles = directoryList.map({ f in
            let model = createFileDataModel(use: f)
            model.subFiles = listFilesInDirectory(path: f.path)

            let size = folderSize(atPath: f.path)
            model.sizeStr = EDCommon.formatFileSize(model.size)
            return model
        })
        
        fileDataList = rootFiles
        
    }
    
    func subdirectory(use path: URL) -> [FileDataModel] {
        let tempList = [FileDataModel]()
        do {
            let subPaths = try fileManger.contentsOfDirectory(atPath: path.path)
             return subPaths.map({createFileDataModel(use: URL.init(fileURLWithPath: $0))})
        }catch let error as NSError {
            print("Get dirctory errer: \(error)")
        }
        return tempList
    }
    
    func createFileDataModel(use path: URL) -> FileDataModel {
        let model = FileDataModel()
        model.name = path.lastPathComponent
        model.pathUrl = path
        do {
            let fileManger = FileManager.default
            let fileAttributes = try fileManger.attributesOfItem(atPath: path.path)
            
            if let fileSize = fileAttributes[.size] as? UInt64 {
                print("File Size: \(fileSize)")
                model.size = fileSize
            }
            
            if let ownerName = fileAttributes[FileAttributeKey.ownerAccountName] {
                print("File Owner: \(ownerName)")
            }
         
            if let creationDate = fileAttributes[FileAttributeKey.creationDate] as? Date {
                print("File Creation Date: \(creationDate)")
                model.createDate = creationDate
            }
            
            if let modificationDate = fileAttributes[FileAttributeKey.modificationDate] as? Date {
                print("File Modification Date: \(modificationDate)")
                model.modificationDate = modificationDate
            }
            
        } catch let error as NSError {
            print("Get attributes errer: \(error)")
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
                        model.sizeStr = EDCommon.formatFileSize(model.size)
                        model.subFiles = listFilesInDirectory(path: fullPath)
                        models.append(model)
                    } else {
                        // 如果是文件，则添加到结果数组中
                        result.append(fullPath)
                        let model = createFileDataModel(use: URL.init(fileURLWithPath: fullPath))
                        model.sizeStr = EDCommon.formatFileSize(model.size)
                        models.append(model)
                    }
                }
            }
        } catch {
            print("Error while enumerating files \(path): \(error.localizedDescription)")
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
    
    func getTextFileStr(filename:String!) -> String! {
            if let path = Bundle.main.path(forResource: filename, ofType: "txt") {
                do {
                    let data = try String(contentsOfFile: path, encoding: .utf8)
                    return data
                } catch {
                    print(error)
                }
            }
            return ""
        }

    func readFile(at path: URL) -> Any {
        
        let fileExt = path.pathExtension //url为所选文件路径
        let uttype = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,fileExt as CFString,nil)
        switch uttype?.takeRetainedValue(){
        case kUTTypeMovie:
            print("这是一个视频文件")
        case kUTTypeText:
            print("这是一个文本文件")
        default:
            break
        }
        return ""
    }
}
