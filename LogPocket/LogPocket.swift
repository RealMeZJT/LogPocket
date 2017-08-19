//
//  LogPocket.swift
//  LogPocket
//
//  Created by TabZhou on 15/08/2017.
//  Copyright © 2017 ZJT. All rights reserved.
//

import Foundation


class LogPocket: FileWritable, TextWrapable {

    var defaultFilePath: String? = ""
    
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
            var path = StandardDirectory().logPocketHomeDir
            path.appendPathComponent("log.txt")
            append(wrapContents, toFile: path.path)
            print(path.path)
        }
        
    }
}
