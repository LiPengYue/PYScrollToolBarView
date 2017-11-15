//
//  MyViewController.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/7.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class MyViewController: UIViewController,UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      setUPViews()
    }


    ///设置subview
    private func setUPViews() {
        view.addSubview(toolBarScrollView)
    }
    
    ///toolBarScrollView的懒加载
    private lazy var toolBarScrollView: PYToolBarScrollView = {
        let frame = CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64)
        let scrollView = PYToolBarScrollView(frame: frame, midView: self.midView, topView: self.topView, bottomViewArray: self.bottomScrollViewArray, topViewH: kViewCurrentH_XP(H: 270), midViewH: kViewCurrentH_XP(H: 110), midViewMargin: 0, isHaveTabBar: true)
        scrollView.isBottomScrollViewPagingEnabled = true
        return scrollView//672
    }()
    ///底部的tableView数组的懒加载
    private lazy var bottomScrollViewArray: [UIScrollView] = {
        let goldCoinMallDecorate = KRGoldCoinMallDecorate(frame: CGRect.zero, style: .plain)
        
        let knapsackView = KRKnapsackView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        let scrollArray = [
            goldCoinMallDecorate,
            knapsackView
        ]
        
        return scrollArray
    }()
    ///盛放toolBarView的懒加载
    private lazy var midView: KRGoldCoinMallDecorate_MidToolBarView = {
        let midView = KRGoldCoinMallDecorate_MidToolBarView()
        midView.goldValue = "1000"
        return midView
    }()
    ///topview的懒加载
    private lazy var topView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "4")
        return imageView
    }()
}

extension ViewController {

    
}
