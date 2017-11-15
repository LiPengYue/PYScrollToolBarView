//
//  KRGoldCoinMallDecorate_MidToolBarView.swift
//  koalareading
//
//  Created by 李鹏跃 on 2017/10/30.
//  Copyright © 2017年 koalareading. All rights reserved.
//

import UIKit
import SnapKit
///积分商城 -- 中间的 toolBarView
class KRGoldCoinMallDecorate_MidToolBarView: PYMidView,PYToolBarViewProtocol {
    
    var goldValue: String = "0"{
        didSet {
            self.goldNumberLabel.text = goldValue
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        setUPView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUPView() {
        addSubview(toolBarView)
        addSubview(myGoldLabel)
        addSubview(goldImageView)
        addSubview(goldNumberLabel)
        
        myGoldLabel.snp.makeConstraints { (make) in
            make.left.equalTo(kViewCurrentW_XP(W: 20))
            make.height.equalTo(kViewCurrentW_XP(W: 30))
            make.width.equalTo(kViewCurrentW_XP(W: 110))
            make.centerY.equalTo(self)
        }
        goldImageView.snp.makeConstraints { (make) in
            make.left.equalTo(myGoldLabel.snp.right)
            make.height.width.equalTo(kViewCurrentW_XP(W: 26))
            make.centerY.equalTo(myGoldLabel)
        }
        toolBarView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(kViewCurrentW_XP(W: -30))
            make.width.equalTo(kViewCurrentW_XP(W: 300))
            make.height.equalTo(kViewCurrentW_XP(W: 56))
            make.centerY.equalTo(self)
        }
        goldNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goldImageView.snp.right).offset(kViewCurrentW_XP(W: 10))
           make.height.equalTo(myGoldLabel)
            make.centerY.equalTo(self)
            make.right.equalTo(toolBarView.snp.left)
        }
    }
    
    /// 积分商城- toolBarView -的懒加载
    lazy var toolBarView: PYToolBarView = {
        let toolBarView = PYToolBarView()
        toolBarView.optionTitleStrArray = [
            "荷花","莲花"
        ]
        toolBarView.lineWidth = 0//线宽
        toolBarView.optionFont = UIFont.kr_font(size: 28)
        toolBarView.optionColorSelected = UIColor.white
        toolBarView.optionColorNormal = UIColor.gray
        toolBarView.optionBackgroundColorSelected = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        toolBarView.optionBackgroundColorNormal = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        toolBarView.animaIndicatorBarViewH = kViewCurrentW_XP(W: 0)
        toolBarView.layer.masksToBounds = true
        toolBarView.layer.cornerRadius = 5
        return toolBarView
    }()
    ///我的金币的懒加载
    private lazy var myGoldLabel:  UILabel = {
        let label = UILabel()
        label.font = UIFont.kr_font(size: 20)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.text = "我的金币："
        return label
    }()
    ///金币的懒加载
    private lazy var goldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_qianbi")
        return imageView
    }()
    ///金币数量的懒加载
    private lazy var goldNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.kr_font(size: 20)
        label.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        label.textAlignment = .left
        label.text = "0"
        return label
    }()
    func registerToolBarView() -> (PYToolBarView) {
        return toolBarView
    }
}
