//
//  TextWrapable.swift
//  LogPocket
//
//  Created by TabZhou on 18/08/2017.
//  Copyright © 2017 ZJT. All rights reserved.
//

import Foundation

enum TextWrapOptions {
    case startTimeSecond
    case startTimeHumanRead
    case systemInfo
    case appInfo
}

protocol TextWrapable {
    var separatorBegin: String {get}
    var separatorEnd: String {get}
    func wrap(contents: String, withOptions options:[TextWrapOptions]) -> String
}


extension TextWrapable {

    var separatorBegin: String {
        return "<<<<<"
    }
    
    var separatorEnd: String {
        return ">>>>>"
    }
    
    func wrap(contents: String, withOptions options:[TextWrapOptions]) -> String {
        var result = ""
        var symbols = ""
        
        if options.contains(.startTimeSecond) {
            let time = String(format:"%f", Date().timeIntervalSince1970)
            symbols += time + " | "
        }
        
        if options.contains(.startTimeHumanRead) {
            let time = Date().timeIntervalSince1970.description
            symbols += time + " | "
        }
        
        if options.contains(.systemInfo) {
            let systemInfo = DeviceInfo.sysemInfo()
            symbols += systemInfo + " | "
        }
        
        if options.contains(.appInfo) {
            let appInfo = DeviceInfo.appVersion() + DeviceInfo.appBuildVersion()
            symbols += appInfo + " | "
        }

        result = separatorBegin + symbols + "\n" +
                        contents + "\n" +
                    separatorEnd + "\n"
        return result
    }
    
    
}
