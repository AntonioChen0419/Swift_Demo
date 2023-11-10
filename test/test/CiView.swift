//
//  view.swift
//  test
//
//  Created by cyanboo on 2022/4/12.
//

import Foundation
import UIKit

class CNCircleProgressView: UIView {
    /// 灰色线条的颜色
    var strokelineWidth:CGFloat = 10.0
    /// 中间字的大小
    var numbelFont = UIFont.systemFont(ofSize: 18)
    /// 中间字的颜色
    var numbelTextColor = UIColor.white
    /// 内部轨道颜色
    var interiorRailwayColor = UIColor.white
    /// 外部轨道颜色
    var exteriorRailwayColor = UIColor.blue
    /// label定时器
    var labelTimer : Timer?
    /// 总的进度
    private var progressValue : CGFloat!
    /// 累加的进度
    private var progressFlag : CGFloat!
    
    let backgroundBlueColor = UIColor.init(red: 7/255.0, green: 9/255.0, blue: 77/255.0, alpha: 1)
    
    /// 轨道layer
    private lazy var interiorRailwayLayer : CAShapeLayer! = {
        let Layer = CAShapeLayer()
        Layer.strokeColor = UIColor.lightGray.cgColor
        Layer.fillColor = UIColor.clear.cgColor
        Layer.lineCap = CAShapeLayerLineCap.round
        self.layer.addSublayer(Layer)
        return Layer
    }()
    /// 加载轨道layer
    private lazy var exteriorRailwayLayer : CAShapeLayer! = {
        let layerNew = CAShapeLayer()
        layerNew.fillColor = UIColor.clear.cgColor
        layerNew.strokeColor = UIColor.blue.cgColor
        layerNew.lineCap = CAShapeLayerLineCap.round
        
        //        self.layer.addSublayer(layerNew)
        return layerNew
    }()
    
    /// 中间显示数字
    private lazy var numberLabel : UILabel! = {
        let numLabelNew = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        numLabelNew.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height/2)
        numLabelNew.backgroundColor = UIColor.clear
        numLabelNew.textAlignment = .center
        self.addSubview(numLabelNew)
        return numLabelNew
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = backgroundBlueColor
        
    }
    
    /**
     调整绘制图像
     
     - parameter progress: 90
     - parameter animate:  true or false
     */
    func circleWithProgress(progress: CGFloat,title: String = "", andIsAnimate animate : Bool){
        progressFlag = 0
        progressValue = (progress * 100.0)
        if animate {
            
            let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height/2), radius: self.bounds.size.width / 2 - strokelineWidth / 2 - 5, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
            self.interiorRailwayLayer.path = path.cgPath
            self.interiorRailwayLayer.lineWidth = strokelineWidth
            self.interiorRailwayLayer.strokeColor = interiorRailwayColor.cgColor
            
            let pathE = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height/2), radius: self.bounds.size.width / 2 - strokelineWidth / 2 - 5, startAngle: -CGFloat(M_PI * 0.5), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
            self.exteriorRailwayLayer.path = pathE.cgPath
            self.exteriorRailwayLayer.lineWidth = strokelineWidth
            self.exteriorRailwayLayer.strokeColor = exteriorRailwayColor.cgColor
            
            let pathAnima = CABasicAnimation(keyPath: "strokeEnd")
            pathAnima.duration = Double(progressValue / 100.0)
            pathAnima.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            pathAnima.fromValue = NSNumber(value: 0)
            pathAnima.toValue = NSNumber(value: Float(progressValue / 100.0))
            pathAnima.fillMode = CAMediaTimingFillMode.forwards
            pathAnima.isRemovedOnCompletion = false
            self.exteriorRailwayLayer.add(pathAnima, forKey: "strokeEndAnimation")
 
            
            self.numberLabel.text = "\(title)\n\(Double(progressValue / 100))"
            self.numberLabel.numberOfLines = 0
            self.numberLabel.font = numbelFont
            self.numberLabel.textColor = numbelTextColor
            
            if progressValue > 0 {
                labelTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CNCircleProgressView.nameLbChange), userInfo: nil, repeats: true)
            }
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.exteriorRailwayLayer.bounds
            
            let whiteBlueColor = UIColor.init(red: 175/255.0, green: 226/255.0, blue: 253/255.0, alpha: 1).cgColor
            let backBlueColor1 = UIColor.init(red: 31/255.0, green: 175/255.0, blue: 250/255.0, alpha: 1).cgColor
            //            let thisBlueColor = UIColor.init(red: 109/255.0, green: 223/255.0, blue: 248/255.0, alpha: 1).cgColor
            
            gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint.init(x: 0.0, y: 0.75)
            
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [whiteBlueColor,whiteBlueColor,backBlueColor1]
            gradientLayer.mask = exteriorRailwayLayer
            self.layer.addSublayer(gradientLayer)
            
        }else{
            self.numberLabel.text = "左目\n \(Double(progress))"
            self.numberLabel.numberOfLines = 0
            self.numberLabel.font = numbelFont
            self.numberLabel.textColor = numbelTextColor
            
            let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height/2), radius: self.bounds.size.width / 2 - strokelineWidth / 2 - 5, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
            self.interiorRailwayLayer.path = path.cgPath
            self.interiorRailwayLayer.lineWidth = strokelineWidth
            self.interiorRailwayLayer.strokeColor = interiorRailwayColor.cgColor
            
            let pathE = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height/2), radius: self.bounds.size.width / 2 - strokelineWidth / 2 - 5, startAngle: -CGFloat(M_PI * 0.5), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
            
            self.exteriorRailwayLayer.path = pathE.cgPath
            self.exteriorRailwayLayer.lineWidth = strokelineWidth
            self.exteriorRailwayLayer.strokeColor = exteriorRailwayColor.cgColor
            self.exteriorRailwayLayer.strokeEnd = progressValue / 100.0
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.exteriorRailwayLayer.bounds
            
            //            let thisRedColor = UIColor.init(red: 225/255.0, green: 92/255.0, blue: 94/255.0, alpha: 1).cgColor
            //            let thisBlueColor1 = UIColor.init(red: 102/255.0, green: 174/255.0, blue: 135/255.0, alpha: 1).cgColor
            //            let thisBlueColor = UIColor.init(red: 109/255.0, green: 223/255.0, blue: 248/255.0, alpha: 1).cgColor
            
            gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint.init(x: 0.0, y: 0.75)
            
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [UIColor.white.cgColor,UIColor.clear.cgColor,UIColor.blue.cgColor]
            gradientLayer.mask = exteriorRailwayLayer
            self.layer.addSublayer(gradientLayer)
        }
        self.backgroundColor = UIColor.clear
        
    }
    
    /**
     定时器走的方法
     */
    @objc func nameLbChange(){
        if(progressFlag >= progressValue - 1){
            labelTimer!.invalidate()
            labelTimer = nil
        }
        progressFlag! += CGFloat(1.0)
//        numberLabel.text = "\(Int(progressFlag))%"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

