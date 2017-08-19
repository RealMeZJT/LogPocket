//
//  StandardDirectory.swift
//  LogPocket
//
//  Created by TabZhou on 19/08/2017.
//  Copyright © 2017 ZJT. All rights reserved.
//

import Foundation


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
