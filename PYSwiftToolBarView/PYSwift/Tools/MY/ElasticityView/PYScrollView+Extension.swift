//
//  ScrollViewExtension.swift
//  PYSwift
//
//  Created by 李鹏跃 on 2017/11/15.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit
//MARK: - scrollView的分类
extension UIScrollView {
    struct struct_UIScrollViewKey {
        static let k_struct_UIScrollViewKey = UnsafeRawPointer.init(bitPattern:"cell".hashValue)
    }
    
    var indexPathDic: [IndexPath:Bool] {
        get {
            var dic: [IndexPath:Bool]? = objc_getAssociatedObject(self, UIScrollView.struct_UIScrollViewKey.k_struct_UIScrollViewKey) as? [IndexPath : Bool]
            if dic == nil {
                dic = Dictionary()
                objc_setAssociatedObject(self, UIScrollView.struct_UIScrollViewKey.k_struct_UIScrollViewKey, dic!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return (objc_getAssociatedObject(self, UIScrollView.struct_UIScrollViewKey.k_struct_UIScrollViewKey) as? [IndexPath : Bool]) ?? Dictionary()
            
        }
        set (newValue) {
            objc_setAssociatedObject(self, UIScrollView.struct_UIScrollViewKey.k_struct_UIScrollViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    
    class func getIndexPathWithIsSeclected(_ scrollView: UIScrollView, _ cell: UIView) -> (Bool) {
        
        if scrollView is UITableView || cell is UITableViewCell {
            let tCell = cell as! UITableViewCell
            let tableview = scrollView as! UITableView
            let index : IndexPath? = tableview.indexPath(for: tCell)
            if let index_ = index {
                return tableview.indexPathDic[index_] ?? false
            }
        }
        print("没有找到相应的index")
        return false
    }
    class func setIndexPathWithIsSelected(_ scrollView: UIScrollView, _ cell: UIView, _ isSelected: Bool) {
        let tCell = cell as! UITableViewCell
        let tableview = scrollView as! UITableView
        let index : IndexPath? = tableview.indexPath(for: tCell)
        if let index_ = index {
            tableview.indexPathDic[index_] = isSelected
        }
    }
    func setIsSelected(index: IndexPath) {
        self.indexPathDic[index] = !(self.indexPathDic[index] ?? false)
    }
    func getCellIsSelected(index: IndexPath) -> Bool {
        return self.indexPathDic[index] ?? false
    }
}


