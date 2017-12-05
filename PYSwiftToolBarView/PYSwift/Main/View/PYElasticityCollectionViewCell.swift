//
//  PYElasticityCollectionViewCell.swift
//  PYSwift
//
//  Created by 李鹏跃 on 2017/11/16.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYElasticityCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
