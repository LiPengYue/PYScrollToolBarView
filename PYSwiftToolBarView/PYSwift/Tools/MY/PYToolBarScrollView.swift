//
//  PYToolBarScrollView.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/28.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit


class PYToolBarScrollView: UIScrollView,UIScrollViewDelegate {
    
    ///顶部的View
    var topView: UIView = UIView()
    
    ///中间的toolBarView
    var midToolBarView: PYToolBarView = PYToolBarView()
    
    ///从外界传来的底部的View的集合
    var bottomViewArray: [UIView] {
        get{
            return _bottomViewArray
        }
        set (newValue) {
            _bottomViewArray = newValue
            //重新布局，为了计算和设置toolBarView和topView的frame
            self.layoutIfNeeded()
        }
    }
   
    ///是否分页
    var isBottomScrollViewPagingEnabled: Bool {
        willSet{//
            self.bottomScrollView.isPagingEnabled = newValue
        }
    }
   
    ///是否有tabBar
    var isHaveTabBar: Bool {
        willSet(newValue){
            self.kIsSetFrame = true
            if newValue {
                tabBarH = 49
            }else{
                tabBarH = 0
            }
            self.layoutSubviews()
        }
    }
    
    
    
    //MARK: -------------------------- 传出事件回调 ---------------------------
    ///当左右滚动bottomScrollView直到页码变化或者midToolBarView被点击时会调用这个方法
    /// * （注意，不要用toolBarView的点击事件的回调，应该用这个方法拿到回调结果，否则会出错误）
    func changedPageNumberCallBackFunc(_ changedPageNumberCallBack: @escaping (_ index: NSInteger, _ title: String, _ button: UIButton) -> Swift.Void) {
        self.changedPageNumberCallBack = changedPageNumberCallBack
    }
    
    
    ///当左右滚动bottomScrollView的时候调用,这个监听的是底部的scrollView的偏移量
    func scrollingBottomScrollViewCallBackFunc(_ scrollingBottomScrollViewCallBack: @escaping(_ contentOffset: CGPoint) -> Swift.Void){
     self.scrollingBottomScrollViewCallBack = scrollingBottomScrollViewCallBack
    }
   
    
    ///当顶部的view向上偏移的时候调用，监控了view的偏移量
    func scrollingTopViewCallBackFunc(_ scrollingTopViewCallBack: @escaping (_ contentOffset: CGPoint)->()) {
        self.scrollingTopViewCallBack = scrollingTopViewCallBack
    }
  
    
    
    private var scrollingBottomScrollViewCallBack: ((_ contentOffset: CGPoint)->())?
    private var changedPageNumberCallBack: ((_ index: NSInteger, _ title: String, _ button: UIButton)->())?
    private var scrollingTopViewCallBack: ((_ contentOffset: CGPoint)->())?
    private var _bottomViewArray: [UIView] = [UIView]()//底部的scrollView集合
    private var kToolBarScrollViewH: CGFloat = 0//self.H
    private var kToolBarScrollViewW: CGFloat = 0//self.W
    private var kBottomScrollViewY: CGFloat = 0//self.BottomScrollView.Y
    private var kBottomScrollViewH: CGFloat = 0//self.BottomScrollView.H
    private var kTopViewH: CGFloat = 0//self.topView.H
    private var kMidToolBarViewH: CGFloat = 0//self.MidToolBarView.H
    private var kMidToolBarViewMargin: CGFloat = 0//self.MidToolBarView距离self左右边界的距离
    private var kIsSetFrame: Bool = true//第一次默认设置空间的frame
    private let bottomScrollView: UIScrollView = UIScrollView()//底部滑动的scrollView
    //记录一下当前底部的scrollView的subView的偏移量
    private var newValue: CGPoint {
        didSet (value){
            self.newValueOld = value;
        }
    }
    //记录了旧的外界传来的scrollView的contentoffset
    private var newValueOld: CGPoint = CGPoint(x: 0, y: 0)
    //记录了self.contentOffset与外界传来的contentOffset的距离
    private var offset: CGFloat = 0.0
    private var index: NSInteger = 0
    let bottomScrollViewTag: NSInteger = 10001
    private var tabBarH = 49.0 //tabBar的高度
    
    
    
    
    
    //MARK: ----------------- init --------------------
    init(frame: CGRect,toolBarView: PYToolBarView, topView: UIView?, bottomViewArray: [UIView], topViewH: CGFloat, toolBarViewH: CGFloat, toolBarViewMargin: CGFloat) {
        self.isBottomScrollViewPagingEnabled = true
        self.isHaveTabBar = true
        self.newValue = CGPoint(x: 0, y: 0)
        
        super.init(frame: frame)
        
        //添加子控件
        self.midToolBarView = toolBarView
        self.addSubview(self.midToolBarView)
        //如果有topview && topView有高度
        if topView != nil && topViewH != 0{
            self.topView = topView!
            self.addSubview(self.topView)
        }
        //bottomScrollView添加view
        self.addSubview(self.bottomScrollView)
        
        //属性记录
        self.kTopViewH = topViewH
        self.kMidToolBarViewH = toolBarViewH
        self.kMidToolBarViewMargin = toolBarViewMargin
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.bottomViewArray = bottomViewArray//里面会重新布局
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: ------------------- layoutSubviews --------------------
    override func layoutSubviews() {
        //如果常用值没值 那么就赋值 并且设置了self.contentSize
        self.setCommonValue()
        self.contentSize = CGSize(width: 0, height: kTopViewH + kToolBarScrollViewH)
        //第一次进入，设置topView，toolBarView，bottomScrollView的farme
        if self.kIsSetFrame {
            //topVIew布局
            self.setupTopView()
           
            //toolBarView布局
            self.setupMidToolBarView()
           
            //bottomScrollView布局 方法内部//对subView进行了布局
            self.setupBottomScrollView()
            self.kIsSetFrame = false
        }
        if self.contentOffset.y < 0 {
            self.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    
    ///为私有的参考量赋值
    private func setCommonValue() {
        if self.kToolBarScrollViewW == 0 || self.kToolBarScrollViewH == 0 {
            self.kToolBarScrollViewH = self.frame.size.height
            self.kToolBarScrollViewW = self.frame.size.width
            self.kBottomScrollViewY = self.kTopViewH + self.kMidToolBarViewH
            self.kBottomScrollViewH = self.frame.size.height - kMidToolBarViewH - CGFloat(self.tabBarH)
            self.index = self.midToolBarView.selectOptionIndex
        }
    }
    
    ///布局topView
    private func setupTopView() {
        if self.kTopViewH != 0{
            self.topView.frame = CGRect(x: 0.0, y: 0.0, width: self.kToolBarScrollViewW, height: self.kTopViewH)
        }
    }
    
    ///布局中间的toolBarView
    private func setupMidToolBarView() {
        self.midToolBarView.frame = CGRect(x: kMidToolBarViewMargin, y: self.kTopViewH, width: self.kToolBarScrollViewW - self.kMidToolBarViewMargin * 2, height: self.kMidToolBarViewH)
        
        //点击事件的回调 注意循环引用问题
        self.midToolBarView.clickOptionCallBackFunc { [weak self] (button, title, index) in
            self?.bottomScrollView.contentOffset = CGPoint(x:CGFloat(index)
             * (self?.kToolBarScrollViewW)!, y: 0)
            
            self?.changedPageNumberCallBack?(index,title,button)
        }
        
        self.midToolBarView.displayUI()
    }
    
    ///布局bottomScrollView (内部进行了subView布局，contentSize赋值)
    private func setupBottomScrollView() {
        //设置frame
        self.bottomScrollView.frame = CGRect(x: 0, y: self.kBottomScrollViewY, width: self.kToolBarScrollViewW, height: self.kBottomScrollViewH)
        //设置contentSize
        self.bottomScrollView.contentSize = CGSize(width: kToolBarScrollViewW * CGFloat (self.bottomViewArray.count), height: kBottomScrollViewH)
        //代理
        self.bottomScrollView.delegate = self
        //tag值
        self.bottomScrollView.tag = self.bottomScrollViewTag
        //设置默认的选中
        let contentOffsetX: CGFloat =  CGFloat(self.midToolBarView.selectOptionIndex) * kToolBarScrollViewW
        self.bottomScrollView.contentOffset = CGPoint(x: contentOffsetX, y: 0)
        
        self.bottomScrollView.showsVerticalScrollIndicator = false
        self.bottomScrollView.showsHorizontalScrollIndicator = false
        
        //布局子控件
        self.setupBottomScrollViewSubView(0)
    }
    
    ///布局bottomScrollView的subView （把subView添加到了bottomScrollViewView里面）
    private func setupBottomScrollViewSubView(_ contentOffsetY: CGFloat) {
        for index: NSInteger in 0 ..< self.bottomViewArray.count {
            //布局subview
            let view: UIView = self.bottomViewArray[index]
            self.bottomScrollView.addSubview(view)
            view.frame = CGRect(x: kToolBarScrollViewW * CGFloat(index), y:0, width: kToolBarScrollViewW, height: kBottomScrollViewH + contentOffsetY)
            //如果要是是ScrollView的子类那么监听contentOffset
            if view is UIScrollView {
                let scrollView: UIScrollView = view as! UIScrollView
                scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
//                self.panGestureRecognizer.require(toFail: scrollView.panGestureRecognizer)
            }
        }
    }

    ///通知的移除
    deinit {
        self.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    ///通知的方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            
            print(change?[NSKeyValueChangeKey.newKey] ?? "----- 没有纸")
            
            let scrollView: UIScrollView = object as! UIScrollView
            
            
            //获取偏移量
            let newValue: CGPoint = change?[NSKeyValueChangeKey.newKey] as! CGPoint
            self.newValue = newValue;
            
            
            
        

            //改变scrollView偏移的位置
            if scrollView.contentOffset.y <= 0{
                if newValue.y < 0 {
                    self.offset = 0
                }
                self.contentOffset = CGPoint(x: 0, y: 0)
            }
            
            if scrollView.contentOffset.y >= self.kTopViewH {
                if newValue.y > self.kTopViewH {
                    self.offset = 0
                }
                
                
                self.contentOffset = CGPoint(x: 0, y: self.kTopViewH)
            }
            
////            
//            if newValue.y > self.kTopViewH {
//                //                self.contentOffset = CGPoint(x: 0, y: self.kTopViewH)
//                self.offset = 0
//                self.animaOffet(CGPoint(x: 0, y: self.kTopViewH), scrollView)
//            }
//            
//            if newValue.y < 0 {
//                //                self.contentOffset = CGPoint(x: 0, y: 0)
//                self.offset = 0
//                self.animaOffet(CGPoint(x: 0, y: 0), scrollView)
//            }
            
            
            self.contentOffset = CGPoint(x: 0, y: newValue.y + self.offset)
        }
    }
    
    func animaOffet(_ offset: CGPoint, _ scrollView: UIScrollView) ->() {
        self.offset = 0
        let velocity: CGPoint = scrollView.panGestureRecognizer.velocity(in: self)
        let time: CGFloat = scrollView.contentOffset.y / velocity.y
        UIView.animate(withDuration: TimeInterval(0.2), animations: {
            self.contentOffset = offset
        })
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == bottomScrollViewTag {
            //拿到滚动的下标
            print("-----",scrollView.contentOffset)
            let index = round(scrollView.contentOffset.x / self.frame.size.width)
            //滚动时候回调
            self.scrollingBottomScrollViewCallBack?(scrollView.contentOffset)

            //滚动到页码变了才调用
            if NSInteger(index) != self.midToolBarView.selectOptionIndex {
                //判断是否超出了数组的取值范围
                if index < 0 || NSInteger(index) >= self.bottomViewArray.count  {
                    return
                }
              
                self.midToolBarView.selectOptionIndex = NSInteger(index)
                if self.bottomViewArray[NSInteger(self.midToolBarView.selectOptionIndex)] is UIScrollView {
                    let scroView: UIScrollView = self.bottomViewArray[NSInteger(self.midToolBarView.selectOptionIndex)] as! UIScrollView
                    self.offset = self.contentOffset.y - scroView.contentOffset.y
                }
                
//                for view in self.bottomViewArray {
//                    if view is UIScrollView {
//                        let scrollView = view as! UIScrollView
//                        scrollView.contentOffset = self.contentOffset
//                    }
//                }
            }
        }

        if scrollView == self {
            if self.contentOffset.y > kTopViewH {
                self.contentOffset = CGPoint(x: 0, y: self.kTopViewH)
            }
        }
    }
//    func getScrollView(_ index: NSInteger) ->(UIScrollView) {
//        if index >= self.bottomViewArray.count {
//            print("数组越界了，pyToolBarScrollView，方法： getScrollView")
//        }
//        if self.bottomViewArray[index] is UIScrollView {
//            let scrollView: UIScrollView = self.bottomViewArray[index] as! UIScrollView
//            return scrollView;
//        }
//        return nil
//    }
}

