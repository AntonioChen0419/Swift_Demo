//
//  InspectionResultsCard.swift
//  test
//
//  Created by cyanboo on 2022/4/13.
//

import UIKit

class InspectionResultsCard: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var rightView: UIView!
    
    @IBOutlet var leftView: UIView!
    
    @IBOutlet var backgroundImage: UIImageView!
    static func InspectionResultsCardView() -> InspectionResultsCard {
      return Bundle.main.loadNibNamed("InspectionResultsCard", owner: nil, options: nil)?.last as! InspectionResultsCard
   }

    func getCircleProgress(titleLeft: String = "", titleRight: String = "", progressLeft: Double = 0.9, progressRight: Double = 0.5) {
        backgroundImage.layer.masksToBounds = true
        backgroundImage.layer.cornerRadius = 20
        
        let viewR = CNCircleProgressView.init(frame: CGRect.init(x: 0, y: 0, width: rightView.frame.size.width, height: rightView.frame.size.height))
        viewR.circleWithProgress(progress: progressLeft,title: titleLeft, andIsAnimate: true)
        leftView.addSubview(viewR)
        
        let viewL = CNCircleProgressView.init(frame: CGRect.init(x: 0, y: 0, width: rightView.frame.size.width, height: rightView.frame.size.height))
        viewL.circleWithProgress(progress: progressRight,title: titleRight, andIsAnimate: true)
        rightView.addSubview(viewL)
        
//        self.layer.cornerRadius = 10.0
    }
}


