//
//  SecondViewController.swift
//  0o9i
//
//  Created by cyanboo on 2023/4/27.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBackRoot(_ sender: Any) {
        let personalViewController = self.GET_SB(sbName: "Main").instantiateViewController(withIdentifier: "ThirdViewController")
        self.navigationController?.pushViewController(personalViewController, animated: true)
 
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
