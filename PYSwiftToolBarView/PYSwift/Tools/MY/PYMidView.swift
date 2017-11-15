
//
//  PYMindView.swift
//  koalareading
//
//  Created by 李鹏跃 on 2017/10/27.
//  Copyright © 2017年 koalareading. All rights reserved.
//

import UIKit
class PYMidView: UIView {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    var delegate: PYToolBarViewProtocol?
    private var isFirstSetToolBarUI: Bool = true
    
    override func layoutSubviews() {
        if isFirstSetToolBarUI {
            self.delegate?.registerToolBarView().displayUI()
            layoutIfNeeded()
            isFirstSetToolBarUI = false
        }
    }
}
