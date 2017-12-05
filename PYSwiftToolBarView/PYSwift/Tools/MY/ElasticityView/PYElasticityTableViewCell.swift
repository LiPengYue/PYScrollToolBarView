//
//  PYElasticityTableViewCell.swift
//  PYSwift
//
//  Created by 李鹏跃 on 2017/11/16.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit
let PYElasticityTableViewCell_ClickMoreButton = "PYElasticityTableViewCell_ClickMoreButton"
/// ------------------- ~ read me ~ -----------------------
/* 使用：
 1. 继承自PYElasticityTableViewCell，然后自定义一个传输数据的model接口，
 2. 然后在model的didSet方法里面，你要调用*setUPElasticityCollectionViewDataSourceFunc*这个方法，给collectionView传递数据，
 3. 如果不想点击collectionView下面的按钮后自动让你的tableview刷新，那么可以设置属性isAutoReloadData为False，但是你必须要在tableVIew的数据源中，监听到点击事件，并手动刷新，直接复制粘贴下面代码到数据源中，注意message，是collectionView当前的数据源数组。
 ····代码：
 self?.eceivedSignalFunc(eventCallBack: { [weak self](signalKey, message) -> (Any)? in
 if signalKey == PYElasticityTableViewCell_ClickMoreButton {
 /// 你要的点击事件在这里拿到
 self?.reloadData()
 }
 return nil
 })
 ····
 */
class PYElasticityTableViewCell: UITableViewCell {

    /// 配置cell，使得里面有点击按钮可以伸缩的collectionView
    ///
    /// - Parameters:
    ///   - layout: collectionViewCell 的layout
    ///   - cellClass: collectionViewCell 的class
    ///   - maxShowItem: 未展开的时候最多展示多少条
    ///   - maxRowItemNum: 每一行有最多有多少
    ///   - isHiddenButton: 是否隐藏底部的Button按钮，隐藏那就默认像是最多数据
    ///   - topView: topview，如果设置了topview，那么最好设置topViewH，如果没有设置，请在topView中用约束撑起topView
    ///   - bottomView: 同topView
    ///   - topViewH: topView的高度
    ///   - bottomViewH: 同topViewH
    func configurationCollectionViwFunc(layout: UICollectionViewFlowLayout,cellClass: AnyClass,maxShowItem: NSInteger, maxRowItemNum: NSInteger,isHiddenButton: Bool? = false,buttonInstert: UIEdgeInsets? = UIEdgeInsetsMake(0, 0, 0, 0),topView: PYElasticityTopView? = nil, bottomView: PYElasticityBottomView? = nil,topViewH: CGFloat? = 0, bottomViewH: CGFloat? = 0) {
        self.topViewH = topViewH ?? 0
        self.bottomViewH = bottomViewH ?? 0
        elasticityCollectionViewLayout = layout
        elasticityCollectionViewCellClass = cellClass
        setUPElasticityFunc()
        elasticityCollectionView?.maxShowItem = maxShowItem
        elasticityCollectionView?.maxRowItemNum = maxRowItemNum
        elasticityCollectionView?.isHiddenButton = isHiddenButton ?? false
        elasticityCollectionView?.buttonInsets = buttonInstert ?? UIEdgeInsetsMake(0, 0, 0, 0)
        PYSetUP()
    }
    
    
    //MARK: - 属性设置
    ///是否为点击状态
    ///点击后展开按钮后，父控件是否自动刷新数据(默认是true，如果设置成False，请在tableview中的数据源中用receivedSignalFunc函数监听点击事件，然后自行刷新,注意signalKey为PYElasticityTableViewCell_ClickMoreButton)
    var isAutoReloadData: Bool = true
    ///设置collectionView的flowLayout
    var elasticityCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var elasticityCollectionViewCellClass: AnyClass = UICollectionViewCell.classForCoder()
    ///顶部的view
    var topView: PYElasticityTopView?
    ///底部的视图
    var bottomView: PYElasticityBottomView?
    /// update topViewH，如果在创建self的时候，没有给topViewH，那么请不要用这个来更改topView的高度
    var topViewH: CGFloat? = 0 {
        didSet {
            topView?.snp.updateConstraints({ (make) in
                make.height.equalTo(topViewH ?? 0)
            })
        }
    }
    /// upDate topViewH， 如果在创建self的时候，没有给bottomViewH，那么请不要用这个来更改bottomView的高度
    var bottomViewH: CGFloat? = 0 {
        didSet {
            bottomView?.snp.updateConstraints({ (make) in
                make.height.equalTo(bottomViewH ?? 0)
            })
        }
    }
  
    var indexPath: IndexPath?
    //MARK: - 设置collectionView的属性
    /// collectionView的Button
    var collectionViewBottomButton: UIButton {
        get {
            return getCollectionViewButton()
        }
    }
    var elasticityCollectionViewModelArray: [Any] {
        get{
            return elasticityCollectionView?.modelArray ?? []
        }
    }
  
    ///button 的上下左右的 间距
    var collectionViewBottomButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            self.elasticityCollectionView?.buttonInsets = collectionViewBottomButtonInsets
        }
    }
    //MARK: - 方法调用
    ///设置collectionView的数据源
    func setUPElasticityCollectionViewDataSourceFunc(ModelArray modelArray: [Any]?) {
        elasticityCollectionView?.modelArray = modelArray ?? []

        print("\(String(describing: indexPath))")
        print("\(getIsSelected(index: indexPath))")
       updateCollectionViewLayout()
    }
    
    private weak var superTableView: UITableView?
    private var elasticityCollectionView: PYElasticityCollectionView?
    var lineView_top: UIView = UIView()
    
    private func PYSetUP () {
        var viewTemp = lineView_top
        //layout lineView_Top
        layout_lineViewTope()
       
        //layout topView
        if let topView = topView {
            layout_TopView(view: topView,tempTopView: viewTemp)
            viewTemp = topView
        }
       
        //layout collectionView
        if let view = elasticityCollectionView {
            layout_ElasticityCollectionView(view: view, tempTopView: viewTemp)
            viewTemp = view
        }
        
        //layout bottomView
        if let view =  bottomView {
            layout_BottomView(view: view, tempTopView: viewTemp)
        }
    }
    private func layout_lineViewTope() {
        self.addSubview(lineView_top)
        lineView_top.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(UIScreen.main.scale * 0.1)
        }
    }
    private func layout_TopView(view: UIView,tempTopView: UIView) {
        contentView.addSubview(view)
        if topViewH == nil || topViewH == 0 {
            view.snp.makeConstraints { (make) in
                make.left.right.equalTo(contentView)
                make.top.equalTo(tempTopView.snp.bottom)
            }
            return
        }
        view.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.height.equalTo(self.topViewH ?? 0)
            make.top.equalTo(tempTopView.snp.bottom)
        }
    }
    private func layout_ElasticityCollectionView(view: UIView, tempTopView: UIView) {
        contentView.addSubview(view)
        if bottomView == nil {
            view.snp.makeConstraints({ (make) in
                make.left.right.equalTo(contentView)
                make.height.equalTo(0)
                make.top.equalTo(contentView)
                make.bottom.equalTo(contentView)
            })
            return
        }
        view.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.height.equalTo(0)
            make.top.equalTo(tempTopView.snp.bottom)
        }
    }
    private func layout_BottomView(view: UIView, tempTopView: UIView) {
        contentView.addSubview(view)
        if bottomViewH == nil || bottomViewH == 0 {
            view.snp.makeConstraints { (make) in
                make.left.right.equalTo(contentView)
                make.bottom.equalTo(contentView)
                make.top.equalTo(tempTopView.snp.bottom)
            }
            return
        }
        view.snp.makeConstraints { (make) in
            make.height.equalTo(bottomViewH ?? 0)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.top.equalTo(tempTopView.snp.bottom)
        }
    }
    private func getIsSelected(index: IndexPath?) -> (Bool) {
            if let index_ = index {
                return (self.superTableView?.getCellIsSelected(index: index_)) ?? false
            }
            print("🌶\(self)，暂无indexPath,请查看tableview的数据源中，是否给cell的indexPath赋值")
            return false
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        superTableView = getScrollView(self)
    }
    private func getScrollView(_ view: UIView) -> (UITableView) {
        if superTableView != nil{
            return self.superTableView!
        }
        if view is UITableView {
            superTableView = view as? UITableView
            return view as! (UITableView)
        }
        if view.superview == nil {
            print("🌶 \\getScrollView(_ view: UIView) -> (UIScrollView)\\ superView为nil")
            return UITableView()
        }
        let scrollView = self.getScrollView(view.superview!)
        return scrollView
    }
    
    private func getCollectionViewButton () -> (UIButton) {
        if let button = self.elasticityCollectionView?.button {
            return button
        }
        print("🌶|| \(self),获取self.elasticityCollectionView?.button，为nil,🌶🌶请在你的tableview的数据源方法里面，给self的indexPath赋值🌶🌶")
        return UIButton()
    }
    ///设置collectionView
    private func setUPElasticityFunc() {
        elasticityCollectionView = PYElasticityCollectionView(frame: CGRect.zero, cellClass: elasticityCollectionViewCellClass, layout: elasticityCollectionViewLayout)
       
        //collectionView的点击事件
        elasticityCollectionView?.clickBottomButtonFunc({[weak self] (collectionViewH) -> () in
            //自动刷新
            if self?.indexPath == nil {
                print("🌶\(String(describing: self)).indexpath没有值 导致self?.superTableView?.setIsSelected(index: index)设置失败，你将永远都展不开你的collectionView，🌶🌶请在你的tableview的数据源方法里面，给self的indexPath赋值🌶🌶")
                return
            }
            ///更新布局
            self?.superTableView?.setIsSelected(index: (self?.indexPath)!)
//            self?.updateCollectionViewLayout()
            
            self?.sendSignalFunc(signalKey: PYElasticityTableViewCell_ClickMoreButton, message: self?.elasticityCollectionViewModelArray ?? [])
            if (self?.isAutoReloadData ?? true) {
                self?.superTableView?.reloadData()
            }
        })
    }
    
    //刷新自己的UI
    private func updateCollectionViewLayout() {
        elasticityCollectionView?.isSelected = self.getIsSelected(index: indexPath)
        let collectionViewH = elasticityCollectionView?.currentViewH
        self.elasticityCollectionView?.snp.updateConstraints({ (make) in                make.height.equalTo(collectionViewH ?? 0)
        })
    }
    deinit {
        print("✅\(self)被销毁")
    }
}
private extension PYElasticityTableViewCell {
}
