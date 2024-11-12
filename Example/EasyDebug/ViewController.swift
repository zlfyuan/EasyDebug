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
       
//        for _ in 0...1 {
//            Alamofire.AF.request("https://v0.yiketianqi.com/api?unescape=1&version=v61&appid=85841439&appsecret=EKCDLT4I",method: HTTPMethod.get).response { d in
//                EDLogInfo(d)
//            }
//        }
//        
        Alamofire.AF.request("http://www.tianqiapi.com/api?version=v9&appid=23035354&appsecret=8YvlPNrz",method: HTTPMethod.get).response { d in
            EDLogInfo(d)
        }
        
    }
}
