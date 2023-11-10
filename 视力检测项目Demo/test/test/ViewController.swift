//
//  ViewController.swift
//  test
//
//  Created by cyanboo on 2022/2/22.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    var mangers: CBPeripheralManager?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("123")
//        let viewC = CNCircleProgressView.init(frame: CGRect.init(x: 100, y: 50, width: 100, height: 100))
////        viewC.frame
//        viewC.circleWithProgress(progress: 0.9,title: "左目", andIsAnimate: true)
////        self.navigationController?.pushViewController(viewC, animated: true)
////        viewC.frame = CGRect.init(x: 100, y: 50, width: 200, height: 200)
////        self.view.backgroundColor = UIColor.gray
//        self.view.addSubview(viewC)
//        self.view.backgroundColor = UIColor.gray
        
        
        // Do any additional setup after loading the view.
//        mangers = CBPeripheralManager.init(delegate: self, queue: DispatchQueue.global())
//        mangers?.delegate = self
//        self.view.backgroundColor = .blue
//        if mangers != nil {
//            
//        }
//        
//        let a = 100
//        let letObject: Int = {
//            //            statements
//            return a + (Int(arc4random())%3)
//        }()
//        
//        let bbb = addStr { it, ia in
//            
//            return it + ia + "1"
//        }// 这种就是尾随闭包的写法
//        print(bbb)
    }
    func addStr(closure:(_ a1:String,_ b1:String)->String)->String{
        return "closure()"
    }
}


extension ViewController: CBPeripheralManagerDelegate{
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }
}

