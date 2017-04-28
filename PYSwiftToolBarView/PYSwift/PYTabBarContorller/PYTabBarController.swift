//
//  PYTabBarController.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/7.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarView : PYTabBar = PYTabBar()
        self.setValue(tabBarView, forKey: "tabBar")
        tabBarView.clickButtonCallBack = {
            print("哈哈哈➕")
        }
        self.setupUI()
    }
    
    //MARK: setupUI
    private func setupUI() {
        //添加控制器
        self.addChildVC(childVC: MainViewController(), title: "首页", imageName: "home")
        self.addChildVC(childVC: InformationViewController() , title: "消息", imageName: "message_center")
        self.addChildVC(childVC: FriendViewController(), title: "发现", imageName: "discover")
        self.addChildVC(childVC: MyViewController(), title: "我的", imageName: "profile")
    }
}


//MARK: 类扩展
private extension PYTabBarController {
     func addChildVC(childVC : UIViewController, title : String, imageName : String) {
        
        //image
        childVC.tabBarItem.image = UIImage.init(named: "tabbar_\(imageName)")
        childVC.tabBarItem.selectedImage = UIImage.init(named: "tabbar_\(imageName)_selected")
        //image渲染模式
        childVC.tabBarItem.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        childVC.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        
        //title 统一设置title，不然会出现问题 & 设置颜色 颜色
        childVC.title = title
        childVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.red], for: UIControlState.normal)
        childVC.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 21)], for: UIControlState.normal)
        
        //添加控制器的时候，总体添加NavigationController
        let nav : UINavigationController = UINavigationController.init(rootViewController: childVC)
        self.addChildViewController(nav)
    }
}






