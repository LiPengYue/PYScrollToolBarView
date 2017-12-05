//
//  PYCollectionViewCell+Extension.swift
//  PYSwift
//
//  Created by 李鹏跃 on 2017/11/15.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit
//MARK: - 为cell添加分类
extension UICollectionViewCell {
    var setUPDateSourceCallBack: ((_ model: Any)->())? {
        get {
            return objc_getAssociatedObject(self, UICollectionViewCell.struct_BaseUICollectionViewKey.k_CellDataSource) as? ((Any) -> ())
        }
        set (newValue) {
            objc_setAssociatedObject(self, UICollectionViewCell.struct_BaseUICollectionViewKey.k_CellDataSource, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    struct struct_BaseUICollectionViewKey {
        static let k_Cell = UnsafeRawPointer.init(bitPattern:"cell".hashValue)
        static let k_CellDataSource = UnsafeRawPointer.init(bitPattern:"k_CellDataSource".hashValue)
    }
    
    var model_BaseData_: Any {
        get {
            return objc_getAssociatedObject(self, UICollectionViewCell.struct_BaseUICollectionViewKey.k_Cell)
        }
        set (newValue) {
            setUPDateSourceCallBack?(newValue)
            objc_setAssociatedObject(self, UICollectionViewCell.struct_BaseUICollectionViewKey.k_Cell, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    func setUPDateSourceFunc(_ setUPDateSourceCallBack: ((_ model: Any)->())?) {
        self.setUPDateSourceCallBack = setUPDateSourceCallBack
    }
}
