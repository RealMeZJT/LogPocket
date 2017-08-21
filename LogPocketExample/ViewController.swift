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
        
 
        let pocket = LogPocket()
        while true {
            pocket.df("protocol oriented program2")
            
            pocket.df("hello")
            
            pocket.df("push!!!")
        }
        
    }
    

}

