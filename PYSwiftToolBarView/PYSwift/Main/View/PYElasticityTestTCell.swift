//
//  PYElasticityTestTCell.swift
//  PYSwift
//
//  Created by 李鹏跃 on 2017/11/16.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYElasticityTestTCell: PYElasticityTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configurationCollectionViwFunc(layout: self.layout, cellClass: PYElasticityCollectionViewCell.classForCoder(), maxShowItem: 2, maxRowItemNum: 2, isHiddenButton: false, topView: nil, bottomView: nil, topViewH: nil, bottomViewH: nil)
        self.setUPButton()
    
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var modelArray:[Any] = [] {
        didSet {
            self.setUPElasticityCollectionViewDataSourceFunc(ModelArray: modelArray)
        }
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layoutF = UICollectionViewFlowLayout()
        layoutF.itemSize = CGSize(width: kViewCurrentW_XP(W: 325), height: kViewCurrentW_XP(W: 202))
        layoutF.scrollDirection = .vertical
        layoutF.minimumLineSpacing = kViewCurrentW_XP(W: 40)
        layoutF.minimumInteritemSpacing = kViewCurrentW_XP(W: 30)
        layoutF.sectionInset = UIEdgeInsetsMake(kViewCurrentW_XP(W: 30), kViewCurrentW_XP(W: 30), 0, kViewCurrentW_XP(W: 30))
        return layoutF
    }()
    private func setUPButton() {
        //未完成数据展示的collectionView展示
        self.modelArray =
            []
        self.collectionViewBottomButton.setTitle("button", for: .normal)
        self.collectionViewBottomButton.titleLabel?.font = UIFont.kr_font(size: 26)
        self.collectionViewBottomButton.setTitle("更多", for: .normal)
        self.collectionViewBottomButton.setTitle("收起", for: .selected)
        collectionViewBottomButton.setTitleColor(UIColor.gray, for: .normal)
        collectionViewBottomButton.setTitleColor(UIColor.black, for: .selected)
    }

}
