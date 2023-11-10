//
//  ThirdViewController.swift
//  0o9i
//
//  Created by cyanboo on 2023/4/27.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var controllers =  self.navigationController?.viewControllers
         var vc:UIViewController?
         controllers?.forEach({ item in
             if item.isKind(of: FirstViewController.self) {
                 vc = item
             }
         })
        var controllersCopy = controllers
        var num: Int = 0
        controllersCopy?.forEach({ item in
            num += 1

            if item.isKind(of: SecondViewController.self){
                controllers?.remove(at: num)
            }
        })
        
        print(controllers)
        print("")
    }
    

    
    @IBAction func back1(_ sender: Any) {
        
        let controllers =  self.navigationController?.viewControllers
         var vc:UIViewController?
         controllers?.forEach({ item in
             if item.isKind(of: FirstViewController.self) {
                 vc = item
             }
         })
        if let _ =  vc {
            
        } else {
            print("")
        }
 //        let personalViewController = self.GET_SB(sbName: "Main").instantiateViewController(withIdentifier: "ViewController")

         self.navigationController?.popToViewController(vc!, animated: true)
    }

    
    func GET_SB (sbName : String) -> UIStoryboard {
        return UIStoryboard(name: sbName, bundle: Bundle.main)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
