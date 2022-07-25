//
//  FacialExpressionTest+Expression.swift
//  test
//
//  Created by cyanboo on 2022/7/18.
//

import Foundation
import UIKit

enum FaceType {
    case videoFirst
    case videoSecond
    case videoThird
    case finshed
}

// MARK: stats
extension FacialExpressionTest {
    func getFaceType() {
        if faceType == .videoFirst {
            
        } else if faceType == .videoSecond {
            
        } else if faceType == .videoThird {
            
        } else {
            printErrorLog("face type is null")
        }
    }
    
    func getFaceTypeAddress() -> String {
        if faceType == .videoFirst {
            return "videoFirst"
        } else if faceType == .videoSecond {
            return "videoSecond"
        } else if faceType == .videoThird {
            return "videoThird"
        }else if faceType == .finshed {
            return "finshed"
        } else {
            printErrorLog("face type is null")
            return "error"
        }
    }
    
    func changeFaceTypeStatus() {
        if faceType == .videoFirst {
            faceType = .videoSecond
        } else if faceType == .videoSecond {
            faceType = .videoThird
        } else if faceType == .videoThird {
            faceType = .finshed
        } else if faceType == .finshed {
            faceType = .finshed
        } else {
            printErrorLog("face type is null")
            faceType = .videoFirst
        }
    }
    func videoFirst15S() {
        if videoTimeFirst3S == nil {
            printGreenLog("first timer 开始运行⚫️")

            videoTimeFirst3S = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(videoTimerClick), userInfo: nil, repeats: true)
        }
        //        faceTimeAfter2.fire()
        //        RunLoop.main.add(faceTimeAfter2, forMode: .common)
    }
    func videoSecond15S() {
        if videoTimeSecond15S == nil {
            printGreenLog("second timer 开始运行⚫️")

            videoTimeSecond15S = Timer.scheduledTimer(timeInterval: videoTimeCount, target: self, selector: #selector(videoTimerClick), userInfo: nil, repeats: true)
        }
        //        faceTimeAfter2.fire()
        //        RunLoop.main.add(faceTimeAfter2, forMode: .common)
    }
    func videoThird15S() {
        if videoTimeThird15S == nil {
            printGreenLog("third timer 开始运行⚫️")

            videoTimeThird15S = Timer.scheduledTimer(timeInterval: videoTimeCount, target: self, selector: #selector(videoTimerClick), userInfo: nil, repeats: true)
        }
        //            if videoTimeFirst3S == nil {
        //        faceTimeAfter2.fire()
        //        RunLoop.main.add(faceTimeAfter2, forMode: .common)
    }
    
    @objc  func videoTimerClick() {
        
        printGreenLog("计时器到时间 进入 videoTimerClick")

        
        //        recordButton.backgroundColor = UIColor.red
        //        faceSession.stopRunning()
        //        captureSession.startRunning()
        if faceType == .videoFirst {
            printGreenLog("停止计时器 first🟢")

            videoTimeFirst3S?.invalidate()
//            startRecord()

        } else if faceType == .videoSecond {
            printGreenLog("停止计时器 second🟢")

            videoTimeSecond15S?.invalidate()
            
            //            videoSecond15S()
        } else if faceType == .videoThird {
            printGreenLog("停止计时器 third🟢")

            videoTimeThird15S?.invalidate()
            
            //            videoThird15S()
        }else if faceType == .finshed {
//            videoTimeThird15S?.invalidate()
            
            //            saveVideoToDocument(outputFileURL: outputFileURL)
            return
        } else {
            printErrorLog("face type is null")
            
        }
        finshRecord()
        
    }
    
    func countDown(){
        
        if faceType == .videoFirst {
            countDownNumber = 4
        } else if faceType == .videoSecond || faceType == .videoThird {
            countDownNumber = 16
        } else {
            countDownNumberLabel.isHidden = true
            videoTimeCountDown?.invalidate()
            return
        }
        videoTimeCountDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownClick), userInfo: nil, repeats: true)
    }
    
    @objc func countDownClick() {
        countDownNumber -= 1
        countDownNumberLabel.text = "\(countDownNumber)"

        if countDownNumber <= 0 {
            countDownNumberLabel.isHidden = true
        } else {
            countDownNumberLabel.isHidden = false
            printLog(countDownNumber)
        }
    }
}




import Foundation
import UIKit

extension String {
    /// 十六进制字符串颜色转为UIColor
    /// - Parameter alpha: 透明度
    func uicolor(alpha: CGFloat = 1.0) -> UIColor {
        // 存储转换后的数值
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hex = self
        // 如果传入的十六进制颜色有前缀，去掉前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        if hex.count < 6 {
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }
        
        // 分别进行转换
        // 红
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        // 绿
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        // 蓝
        Scanner(string: String(hex[hex.index(startIndex, offsetBy: 4)...])).scanHexInt64(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
}


