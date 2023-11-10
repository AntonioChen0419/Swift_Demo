//
//  inspectionResultsViewController.swift
//  test
//
//  Created by cyanboo on 2022/4/13.
//

import UIKit

class InspectionResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let viewC = CNCircleProgressView.init(frame: CGRect.init(x: 100, y: 50, width: 100, height: 100))
//        viewC.circleWithProgress(progress: 0.9,title: "左目", andIsAnimate: true)
//        self.view.addSubview(viewC)
//        self.view.backgroundColor = UIColor.blue
        
        var inspectionResultsCard = InspectionResultsCard.InspectionResultsCardView()
        inspectionResultsCard.frame = CGRect.init(x: 0, y: 0, width: 345, height: 202)
        inspectionResultsCard.center = CGPoint.init(x: self.view.center.x, y: inspectionResultsCard.frame.size.height + 12)
        inspectionResultsCard.getCircleProgress(titleLeft: "左目", titleRight: "右目")
        self.view.addSubview(inspectionResultsCard)
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
