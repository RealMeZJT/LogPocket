//
//  FileExplore.swift
//  LogPocket
//
//  Created by TabZhou on 15/08/2017.
//  Copyright © 2017 ZJT. All rights reserved.
//

import Foundation

protocol FileExplore {
    func directoryExists(atPath dirPath: String) -> Bool
    func createDirectory(_ dirPath: String)
    func createDirectoryIfNotExists(_ dirPath: String)
}

extension FileExplore {
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
}


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


