//
//  FileExplore.swift
//  LogPocket
//
//  Created by TabZhou on 15/08/2017.
//  Copyright © 2017 ZJT. All rights reserved.
//

import Foundation

//MARK: - FileExplore
protocol FileExplore {
    func fileExists(atPath filePath: String) -> Bool
    func deleteFile(atPath filePath: String) -> Bool
    func isDirectory(atPath filePath: String) -> Bool
    func directoryExists(atPath dirPath: String) -> Bool
    func createDirectory(_ dirPath: String)
    func createDirectoryIfNotExists(_ dirPath: String)
    func sizeKB(atPath path: String) -> Int64
    func oldestFile(atDir dirPath: String) throws -> String?
    func lastestFile(atDir dirPath: String) throws -> String?
}

extension FileExplore {
    
    func fileExists(atPath filePath: String) -> Bool {
        let fm = FileManager.default
        return fm.fileExists(atPath: filePath)
    }
    
    func deleteFile(atPath filePath: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
            return false
        }
        return true
    }
    
    func isDirectory(atPath filePath: String) -> Bool {
        let fm = FileManager.default
        var isDir: ObjCBool = false
        fm.fileExists(atPath: filePath, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    func directoryExists(atPath dirPath: String) -> Bool {
        let fm = FileManager.default
        var isDir: ObjCBool = true;
        return fm.fileExists(atPath: dirPath, isDirectory: &isDir)
    }
    
    func createDirectory(_ dirPath: String) {
        let fm = FileManager.default
        do {
        try fm.createDirectory(atPath: dirPath,
                               withIntermediateDirectories: true,
                               attributes: nil);
        } catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func createDirectoryIfNotExists(_ dirPath: String) {
        if (!directoryExists(atPath: dirPath)) {
            createDirectory(dirPath);
        }
    }
    
    func sizeKB(atPath path: String) -> Int64 {
        var kb: Int64 = 0
        
        let fm = FileManager.default
        if isDirectory(atPath: path) {
            do {
                let contents = try fm.contentsOfDirectory(atPath: path)
                for content in contents {
                    var contentFullPath = URL(fileURLWithPath: path)
                    contentFullPath.appendPathComponent(content)
                    kb += sizeKB(atPath: contentFullPath.path)
                }
            } catch let error {
                print(error)
            }
        } else if (fileExists(atPath: path)) {
            do {
                let dic = try fm.attributesOfItem(atPath: path)
                kb += (dic[FileAttributeKey.size] as! NSNumber).int64Value / 1024
            } catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
        return kb
    }
    
    func oldestFile(atDir dirPath: String) throws -> String? {
        return try extremeModifiedDateFile(atDir: dirPath).oldest
    }
    
    func lastestFile(atDir dirPath: String) throws -> String? {
        return try extremeModifiedDateFile(atDir: dirPath).lastest
    }
    

    func extremeModifiedDateFile(atDir dirPath: String) throws -> (lastest:String?,oldest:String?) {
        assert(directoryExists(atPath: dirPath), "FileManager.oldestFile() should pass a dirctory path")
        //TODO: 优化。目前太多强制转类型。
        if (!directoryExists(atPath: dirPath)) {
            return (nil,nil)
        }
        
        let dirUrl = URL(fileURLWithPath:dirPath)
        
        var oldestFilePath = ""
        var lastedFilePaht = ""
        let fm = FileManager.default
        let enumerator = fm.enumerator(at: dirUrl, includingPropertiesForKeys: [URLResourceKey.contentModificationDateKey])
        
        try fm.attributesOfFileSystem(forPath: dirPath)
        var oldestModifiedTime: TimeInterval = NSDate().timeIntervalSince1970
        var lastestModifiedTime: TimeInterval = 0
        for (_,object) in enumerator!.enumerated() {
            guard let fileURL = object as? NSURL else {assert(false)}
            var modificationDateResource: AnyObject?
            try fileURL.getResourceValue(&modificationDateResource, forKey: URLResourceKey.contentModificationDateKey)
            let tempTime = modificationDateResource?.timeIntervalSince1970 ?? NSDate().timeIntervalSince1970
            if (oldestModifiedTime > tempTime) {
                oldestModifiedTime = tempTime
                oldestFilePath = fileURL.path!
            }
            
            if (lastestModifiedTime < tempTime) {
                lastestModifiedTime = tempTime
                lastedFilePaht = fileURL.path!
            }
        }
        
        return (lastedFilePaht,oldestFilePath)
    }
}

//MARK: - FileWritable
protocol FileWritable {
    var encoding:String.Encoding { get }
    var defaultFilePath:String? { get set }
    
    func write(_ contents:String)
    func write(_ contents:String, toFile filePath:String)
    
    func append(_ contents:String)
    func append(_ contents:String,toFile filePath:String)
    
    func push(_ contents:String)
    func push(_ contents:String,toFile filePath:String)
}

extension FileWritable {
    var encoding:String.Encoding {
        return String.Encoding.utf8
    }
    
    func write(_ contents:String) {
        assert(defaultFilePath != nil,"Use FileWritable.write(_ contents:String) without 'defaultFilePath'")
        write(contents, toFile: defaultFilePath!)
    }
    
    func write(_ contents:String, toFile filePath:String) {
        do {
            // Write contentss to file
            try contents.write(toFile: filePath, atomically: false, encoding: encoding)
           
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func append(_ contents:String) {
        assert(defaultFilePath != nil,"Use FileWritable.append(_ contents:String) without 'defaultFilePath'")
        append(contents, toFile: defaultFilePath!)
    }
    
    func append(_ contents:String,toFile filePath:String) {
        if (!FileManager.default.fileExists(atPath: filePath)) {
            write(contents, toFile: filePath)
            return
        }
        let fileHandle = FileHandle(forUpdatingAtPath: filePath)
        fileHandle?.seekToEndOfFile()
        fileHandle?.write(contents.data(using: encoding)!)
        fileHandle?.closeFile()
    }
    
    func push(_ contents:String) {
        assert(defaultFilePath != nil,"Use FileWritable.push(_ contents:String) without 'defaultFilePath'")
        push(contents, toFile: defaultFilePath!)
    }
    
    func push(_ contents:String,toFile filePath:String) {
        let fileHandle = FileHandle(forUpdatingAtPath: filePath)

        let originData = fileHandle?.readDataToEndOfFile()
        var newData = contents.data(using: encoding)
        if let originData = originData {
            newData?.append(originData)
        }
        
        fileHandle?.seek(toFileOffset: 0);
        fileHandle?.write(newData!)
        fileHandle?.closeFile()
    }
}


