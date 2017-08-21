//
//  LogPocket.swift
//  LogPocket
//
//  Created by TabZhou on 15/08/2017.
//  Copyright © 2017 ZJT. All rights reserved.
//

import Foundation


class LogPocket: FileWritable, TextWrapable, DiskSpaceLimitable {
    static let MAX_SINGLE_FILE_SIZE_KB:Int64 = 1 * 1024
    //MARK: - FileWritable
    var defaultFilePath: String? = ""
    
    
    //MARK: - DiskSpaceLimitable
    var maxDiskSpaceKB: Int64 = 2 * 1024;
    var logsHomeDir: String = StandardDirectory().logPocketHomeDir.path
    
    //MARK: - Self method
    var currentFile:String = ""
    
    //log to terminal
    func d(_ contents: String) {
        log(contents: contents, isToTerminal: true, isToFile: false)
    }
    
    //log to file
    func f(_ contents: String) {
        log(contents: contents, isToTerminal: false, isToFile: true)
    }
    
    //log to terminal & file
    func df(_ contents: String) {
        log(contents: contents, isToTerminal: true, isToFile: true)
    }
    
    func log(contents: String, isToTerminal t: Bool, isToFile f: Bool ) {
        let wrapContents = wrap(contents: contents, withOptions: [.appInfo,.startTimeHumanRead,.startTimeSecond,.systemInfo])
        
        if (t) {
            print(wrapContents)
        }
        
        if (f) {
            currentFile = fileToLog()
            append(wrapContents, toFile: currentFile)
            if isOutOfLimit() {
                removeOldestFile()
            }
            print(currentFile)
        }
        
    }
    
    private func fileToLog() -> String {
        //use current file first
        if (fileExists(atPath: currentFile) && !isOutOfSize(currentFile)) {
            return currentFile
        }
        
        //use lastestFile
        var lastestFilePath: String?
        do {
            lastestFilePath = try lastestFile(atDir: StandardDirectory().logPocketHomeDir.path)
        } catch let error {
            print(error)
        }
        
        if lastestFilePath != nil
            && fileExists(atPath: lastestFilePath!)
            && !isOutOfSize(lastestFilePath!) {
            return lastestFilePath!
        }
        
        //use new file
        return StandardLogFile().uniqueFilePath
    }
    
    private func isOutOfSize(_ filePath: String) -> Bool {
        return (sizeKB(atPath: filePath) > LogPocket.MAX_SINGLE_FILE_SIZE_KB)
    }
    
}
