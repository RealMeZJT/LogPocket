//
//  StandardPath.swift
//  LogPocket
//
//  Created by TabZhou on 21/08/2017.
//  Copyright © 2017 ZJT. All rights reserved.
//

import Foundation


//MARK: - StandardDirectory
struct StandardDirectory : FileExplore {
    var logPocketHomeDir: URL {
        let dir = applicationSupportDir.appendingPathComponent("logpocket", isDirectory: true);
        createDirectoryIfNotExists(dir.path);
        return dir
    }
    
    var applicationSupportDir: URL {
        let fm = FileManager.default;
        let dirs = fm.urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        
        let dir = dirs.first?.path ?? ""
        
        if (!directoryExists(atPath: dir)) {
            createDirectory(dir)
        }
        
        return URL(fileURLWithPath: dir)
    }
}

struct StandardLogFile : FileExplore {
    var uniqueFilePath: String {
        var fullPath = StandardDirectory().logPocketHomeDir
        let fileName = Date().description(with: Locale(identifier: "zh"))
        fullPath.appendPathComponent(fileName)
        
        var fullPathStr = fullPath.path
        if fileExists(atPath: fullPathStr) {
            fullPathStr.append(UUID().description)
        }
        fullPathStr.append(".txt")
        return fullPathStr
    }
}
