//
//  ViewController2.swift
//  swift_demo3
//
//  Created by Tops on 5/23/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

import UIKit

protocol setmyDelegate
{
    func setMynew()
}

class ViewController2: UIViewController {

    var delegate : setmyDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func btnBackClick(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
