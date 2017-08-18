//
//  ViewController.swift
//  LogPocketExample
//
//  Created by TabZhou on 15/08/2017.
//  Copyright © 2017 ZJT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var path = StandardDirectory().logPocketHomeDir
        path = path.appendingPathComponent("log.txt")
        print(path.path)
        var pocket = LogPocket()
        pocket.defaultFilePath =  path.path ;
        pocket.write("protocol oriented program")
        
        pocket.append("hello")
        
        pocket.push("start\n")
    }
    



}

