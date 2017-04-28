//
//  MainViewController.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/7.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: 加载一个toolBarView
    var pytoolBarView: PYToolBarView = PYToolBarView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        pytoolBarView.optionTitleStrArray = ["我","是","谁"]//字符串数组
        pytoolBarView.animaIndicatorBarView_animaTime = 0//动画时长
        pytoolBarView.selectOptionIndex = 2;//默认选中的索引
        pytoolBarView.isRecurClick = true//是否能够重复点击
        //点击事件注册
        self.pytoolBarView.clickOptionCallBackFunc { (option: UIButton, title: String, index: NSInteger) in
            print(title,index)
        }
        self.pytoolBarView.customOptionWhenChangeSelectOptionFunc { (fromOption, toOption, fromIndex, toIndex) in
            UIView.animate(withDuration: 1, animations: {
                fromOption.backgroundColor = UIColor.white
                fromOption.layer.transform = CATransform3DIdentity
                toOption.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1)
            })
        }
        
        //布局
        pytoolBarView.frame = CGRect(x:0, y: 100, width: self.view.frame.size.width, height: 200)
        self.view.addSubview(pytoolBarView)
        
        //绘制
        self.pytoolBarView.displayUI()
    }
    //点击屏幕
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pytoolBarView.optionTitleStrArray = ["wo","shi","sheine","呢"]
        self.pytoolBarView.lineColor = UIColor.red
        self.pytoolBarView.lineWidth = 0.5
        self.pytoolBarView.distanceBetweenLine = 20.0
        self.pytoolBarView.animaIndicatorBarViewColor = UIColor.black
        self.pytoolBarView.animaIndicatorBarView_animaTime = 0.3
        self.pytoolBarView.selectOptionIndex = 0
        //重绘
        self.pytoolBarView.displayUI()
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
