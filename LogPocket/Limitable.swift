//
//  Limitable.swift
//  LogPocket
//
//  Created by TabZhou on 19/08/2017.
//  Copyright © 2017 ZJT. All rights reserved.
//

import Foundation



protocol DiskSpaceLimitable : FileExplore {
    var maxDiskSpaceKB: Int64 {get set}
    var logsHomeDir: String {get set}

    func isOutOfLimit() -> Bool
    func removeOldestFile()
}

extension DiskSpaceLimitable  {
    func isOutOfLimit() -> Bool {
        let existsSize = sizeKB(atPath: logsHomeDir)
        return existsSize > maxDiskSpaceKB
    }
    
    func removeOldestFile() {
        do {
            if let oldestFilePath = try oldestFile(atDir: logsHomeDir) {
                _ = deleteFile(atPath: oldestFilePath)
            }
        } catch let error {
            print(error)
        }
        
    }
}

protocol ExpiredLimitable {
    
}
