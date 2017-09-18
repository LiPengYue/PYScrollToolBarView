//
//  FriendViewController.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/7.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panFunc))
        self.view.addGestureRecognizer(pan)
        self.setupToolBarScrollView()
        
    }

    func panFunc(_ pan: UIPanGestureRecognizer)  {
        print("--------")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupToolBarScrollView() -> () {
        
        let pytoolBarView: PYToolBarView = self.setToolBarView()
        let viewFrame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        
        let scrollViewArray: [UIScrollView] = self.getScrollArray()
        
        let topView: UIImageView = UIImageView()
        topView.image = UIImage(named: "1")
        topView.backgroundColor = #colorLiteral(red: 0.7422643802, green: 0.8729702831, blue: 1, alpha: 1)
        
        
        let toolBarView: PYToolBarScrollView = PYToolBarScrollView.init(frame: viewFrame, toolBarView: pytoolBarView, topView: topView, bottomViewArray: scrollViewArray, topViewH: 200, toolBarViewH: 30, toolBarViewMargin: 10, isHaveTabBar: true)
        toolBarView.isBottomScrollViewPagingEnabled = true
        self.view.addSubview(toolBarView)
        toolBarView.changedPageNumberCallBackFunc{ (index, title, button) in
            print(index)
        }
        toolBarView.scrollingBottomScrollViewCallBackFunc { (point) in
            print(point)
        }
    }
    
    
    //MARK: -------- toolBarView创建设置
    func setToolBarView() -> (PYToolBarView) {
        let pytoolBarView: PYToolBarView = PYToolBarView()
        pytoolBarView.optionTitleStrArray = ["我","是"]//字符串数组
        pytoolBarView.animaIndicatorBarView_animaTime = 0.4//动画时长
        pytoolBarView.selectOptionIndex = 0;//默认选中的索引
        pytoolBarView.isRecurClick = false//是否能够重复点击
        
        //MARK: ------ 对于toolBarView 动画的设置
        //对option进行设置
        pytoolBarView.customOptionUICallFunc { (option, index, title) in
            option.backgroundColor = UIColor.clear
        }
//        //自定义动画
//        pytoolBarView.customOptionWhenChangeSelectOptionFunc { (fromOption, toOption, fromIndx, toIndex) in
//            UIView.animate(withDuration: 1, animations: {
//                fromOption.layer.transform = CATransform3DIdentity
//                toOption.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1)
//            })
//        }
        return pytoolBarView
    }
    
    func getScrollArray() -> ([UIScrollView]) {
        var scrollViewArray: [UIScrollView] = [UIScrollView]()
        let collectionView: PYCollectionView = PYCollectionView()
        let tableView: PYTableView = PYTableView()
        scrollViewArray.append(tableView)
        scrollViewArray.append(collectionView)
        return scrollViewArray
    }
}
