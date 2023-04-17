//
//  ViewController.swift
//  EasyDebug
//
//  Created by zlfyuan on 03/30/2023.
//  Copyright (c) 2023 CocoaPods. All rights reserved.
//

import UIKit
import EasyDebug
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        Alamofire.AF.request("https://portal.lanrenyun.cn/1681358805762",method: HTTPMethod.get).response { d in
            EDLogInfo(d)
        }
        
        
        
    }
}
