//
//  PYTabBar.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/7.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYTabBar: UITabBar {

    //MARK: 点击button的闭包 & 方法
    var clickButtonCallBack : (()->())?
    
    @objc private func clickButtonFunc() {
        //着这样相当于判断闭包部位空就执行，否则不执行
        self.clickButtonCallBack?()
    }
    
    
    
    //MARK: 懒加载———加号按钮
    private lazy var addButton : UIButton = {
        let button : UIButton = UIButton.init()
        button.setTitleColor(UIColor.red, for: UIControlState.normal)
        button.setTitle("➕", for: UIControlState.normal);
        
        button.addTarget(self, action: #selector(clickButtonFunc), for: UIControlEvents.touchUpInside)
        return button
    }()
   
    
    
    //MARK: 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    
    
    //MARK: setupUI (添加button)
    private func setupUI () {
        self.addSubview(self.addButton)
    }
    
    
    
    //MARK: 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()//调用父类
        
        //获取控件的子控件的数量
        let count: NSInteger = self.subviews.count
        if count == 0 {
            print("PYTabBar暂无子控件")
            return
        }
        let W : CGFloat = self.frame.size.width
        let H : CGFloat = self.frame.size.height
        let subViewW : CGFloat = CGFloat(W) / CGFloat(NSInteger (count - 1))
        let mid : NSInteger = count / 2 //中间偏左一个位置
        
        //循环遍历子控件设置控件的位置
        for i in 0..<count {}//用这个不好操作  不如直接for in 取出subview
        
        var i : NSInteger = 0
        for button in self.subviews{
            //判断是否为我们自己添加的button
            let isButton = button.isKind(of:NSClassFromString("UIButton")!)
            if isButton {//如果是
                let addButton : UIButton = button as! UIButton
                addButton.center = CGPoint(x: W / 2, y: H / 2)
                button.bounds = CGRect(x: 0, y: 0, width: subViewW, height: H)
            }
            if button.isKind(of:NSClassFromString("UITabBarButton")!) {
                button.frame = CGRect(x: CGFloat (subViewW) * CGFloat (NSInteger (i)), y: 0, width: subViewW, height: H)
                i += 1
                if i == mid-1 {//到中间了就跳过一个 UIBarBackground 所以实际的subView会多一个
                    i += 1
                }
            }
        }
        
//        
//        let W: CGFloat = self.frame.size.width / 5
//        
//        //设置变量  统计i
//        var i: CGFloat = 0
//        for button in self.subviews {
//            //打印添加的按钮的类型  以及系统的类型 系统的类型是  UITabBarButton
//            //            print(button.self)
//            //判断这个类转城字符串是不是UIButton
//            if NSStringFromClass(button.classForKeyedArchiver!) == "UIButton" {
//                //                button.center = self.center//如果是我添加的那么就设置最中心的位置
//                //这里必须这么设置，因为 self的center是相对于父控件的位置
//                button.center.x = self.frame.size.width / 2 // self.centerX
//                button.center.y = self.frame.size.height / 2
//                
//            }
//            
//            if button.isKind(of: NSClassFromString("UITabBarButton")!) {
//                button.frame.origin.x = CGFloat(i) * W
//                i += 1
//                if i == 2 {
//                    i += 1
//                }
//            }
//        }
//
    }
}
