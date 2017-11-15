//
//  KRKnapsackHeaderView.swift
//  koalareading
//
//  Created by 李鹏跃 on 2017/11/13.
//  Copyright © 2017年 koalareading. All rights reserved.
//

import UIKit

class KRKnapsackHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
        let label = UILabel()
        label.frame = self.frame
        self.backgroundColor = UIColor.gray
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
