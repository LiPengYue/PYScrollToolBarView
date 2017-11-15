//
//  PYSize.swift
//  PYSwift
//
//  Created by 李鹏跃 on 2017/11/15.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit
//屏幕尺寸
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

//屏幕尺寸
let kScreenBounds = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)



//屏幕适配（直接使用UI图给定的尺寸）
let currentTwoWidth = screenWidth/375/2
let currentTwoHeight = screenHeight/667/2
//屏幕适配（长宽）
let currentWidth = screenWidth/375
let currentHeight = screenWidth/375



///view的宽度比例计算
func kViewCurrentWidth (W: CGFloat) -> (CGFloat) {
    return W * currentWidth;
}
///view的高度比例计算
func kViewCurrentHeight (H: CGFloat) -> (CGFloat) {
    return H * currentHeight;
}
/// H/2 && round
func kViewCurrentH_XP (H: CGFloat) -> (CGFloat) {
    return round(H * currentHeight / 2.0)
}
/// W/2
func kViewCurrentW_XP (W: CGFloat) -> (CGFloat) {
    return round(W * currentWidth / 2.0)
}
///弧度转角度
func RADIANS_TO_DEGREES(X: CGFloat) -> (CGFloat) {
    return X / CGFloat(Double.pi) * 180.0
}
///角度转弧度
func DEGREES_TO_RADIANS(X: CGFloat) -> (CGFloat) {
    return X * CGFloat(Double.pi) / 180.0
}


extension UIFont {
    
    enum kr_fontTypeEnum:String{
        ///苹方字体L
        case font_pingfangL = "PingFangSC-Light"
        ///苹方字体R
        case font_pingfangR = "PingFangSC-Regular"
        ///苹方字体M
        case font_pingfangM = "PingFangSC-Medium"
        ///粗斜体
        case font_Arial_BoldItalicMT = "Arial-BoldItalicMT"
    }
    class func kr_font(size: CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Regular", size:kViewCurrentH_XP(H: size))!
    }
    
    class func kr_font(type:kr_fontTypeEnum, size: CGFloat) -> UIFont {
        return UIFont.init(name: type.rawValue, size: kViewCurrentH_XP(H: size))!
    }
}


extension String {
    ///获取字符串的高度
    func getLabHeigh(font:UIFont,width:CGFloat) -> CGFloat {
        
        let size = CGSize.init(width: width, height:  CGFloat(MAXFLOAT))
        
        let dic = [NSFontAttributeName:font]
        
        let strSize = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        
        return strSize.height
    }
    
    
    ///获取字符串的宽度
    func getLabWidth(font:UIFont,height:CGFloat) -> CGFloat {
        
        let size = CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        
        let dic = [NSFontAttributeName:font]
        
        let strSize = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        
        return strSize.width
    }
}
