//
//  PYToolBarScrollView.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/28.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit


protocol PYToolBarViewProtocol {
    func registerToolBarView()->(PYToolBarView)
}
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
    ///底部的scrollView是否可以滑动
    var isBottomScrollEnable: Bool = true {
        didSet {
            self.bottomScrollView.isScrollEnabled = isBottomScrollEnable
        }
    }
    
    
    ///底部是否有弹簧效果
    var isBottomScrollViewBounces: Bool {
        willSet {
            self.bottomScrollView.bounces = newValue
        }
    }
    
    ///是否有tabBar
    var isHaveTabBar: Bool = true{
        didSet{
            self.kIsSetFrame = true
            if isHaveTabBar {
                tabBarH = 49
            }else{
                tabBarH = 0
            }
            self.layoutSubviews()
        }
    }
    ///ToolBar 悬停顶部时，toolBar.top 与 self.top之间的距离
    var spacingBetweenTopOfToolBarAndSelf: CGFloat = 0 {
        didSet {
            kTopViewH += spacingBetweenTopOfToolBarAndSelf
        }
    }
    
    ///当前的底部的scrollView
    var currentScrollView: UIView {
        get {
            if bottomViewArray.count < self.midToolBarView.optionTitleStrArray.count {
                print("🌶,toolBarView的title 个数大于bottomScrollView 的个数\(self)")
                return UIView()
            }
            return self.bottomViewArray[self.midToolBarView.selectOptionIndex]
        }
    }
    
    //MARK: -------------------------- 传出事件回调 ---------------------------
    ///当左右滚动bottomScrollView直到页码变化或者midToolBarView被点击时会调用这个方法
    /// * （注意，不要用toolBarView的点击事件的回调，应该用这个方法拿到回调结果，否则会出错误）
    func changedPageNumberCallBackFunc(_ changedPageNumberCallBack: @escaping (_ index: NSInteger, _ title: String, _ button: UIButton) -> Swift.Void) {
        self.changedPageNumberCallBack = changedPageNumberCallBack
    }
    private var changeCurrentPageBlock: ((_ fromeIndex:NSInteger, _ toIndex: NSInteger) -> (Bool))?
    ///改变currentPage之前调用的方法
    func changeCurrentPageBeforeFunc(_ event: @escaping (_ fromeIndex:NSInteger, _ toIndex: NSInteger) -> (Bool)) {
        changeCurrentPageBlock = event
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
    private var midView: PYMidView?
    
    
    //MARK: ----------------- init --------------------
    init (frame: CGRect,midView: PYMidView, topView: UIView?, bottomViewArray: [UIView], topViewH: CGFloat, midViewH: CGFloat, midViewMargin: CGFloat, isHaveTabBar: Bool) {
        self.isBottomScrollViewPagingEnabled = true
        self.isBottomScrollViewBounces = true
        self.newValue = CGPoint(x: 0, y: 0)
        super.init(frame: frame)
        //解决push的时候scrollView向下移动，并且向上飘逸的情况
        if #available(iOS 11.0, *) {
            //            sel  f.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        let toolBarView = midView.delegate?.registerToolBarView()
        
        let toolBarView_h = midViewH
        if (toolBarView == nil) {
            print("midView toolBarView 为nil，所以崩了")
        }
        self.midView = midView
        
        self.configure(toolBarView: toolBarView!, topView: topView, bottomViewArray: bottomViewArray, topViewH: topViewH, toolBarViewH: toolBarView_h, toolBarViewMargin: midViewMargin, isHaveTabBar: isHaveTabBar)
    }
    init(frame: CGRect,toolBarView: PYToolBarView, topView: UIView?, bottomViewArray: [UIView], topViewH: CGFloat, toolBarViewH: CGFloat, toolBarViewMargin: CGFloat, isHaveTabBar: Bool) {
        self.isBottomScrollViewPagingEnabled = true
        self.isBottomScrollViewBounces = true
        self.newValue = CGPoint(x: 0, y: 0)
        
        super.init(frame: frame)
        self.configure(toolBarView: toolBarView, topView: topView, bottomViewArray: bottomViewArray, topViewH: topViewH, toolBarViewH: toolBarViewH, toolBarViewMargin: toolBarViewMargin, isHaveTabBar: isHaveTabBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure (toolBarView: PYToolBarView, topView: UIView?, bottomViewArray: [UIView], topViewH: CGFloat, toolBarViewH: CGFloat, toolBarViewMargin: CGFloat, isHaveTabBar: Bool)->() {
        tabBarH = isHaveTabBar ? 49 : 0
        //添加子控件
        self.midToolBarView = toolBarView
        if self.midView != nil {
            self.addSubview(self.midView!)
        }else{
            self.addSubview(self.midToolBarView)
        }
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
        self.isHaveTabBar = isHaveTabBar
        self.delegate = self
        
    }
    
    //MARK: ------------------- layoutSubviews --------------------
    override func layoutSubviews() {
        //如果常用值没值 那么就赋值 并且设置了self.contentSize
        self.setCommonValue()
        self.contentSize = CGSize(width: 0, height: kTopViewH + kToolBarScrollViewH)
        //第一次进入，设置topView，toolBarView，bottomScrollView的farme
        if self.kIsSetFrame {
            self.contentOffset = CGPoint(x: 0, y: 0)
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
        if self.frame.size.width == nil || self.frame.size.width == 0{
            self.layoutIfNeeded()
        }
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
        
        
        //点击事件的回调 注意循环引用问题
        //将要改变index的时候调用
        self.midToolBarView.willChanageCurrentPageFunc {[weak self] (frome, to) in
            return (self?.changeCurrentPageBlock?(frome,to)) ?? false
        }
        
        
        self.midToolBarView.clickOptionCallBackFunc { [weak self] (button, title, index) in
            self?.bottomScrollView.contentOffset = CGPoint(x:CGFloat(index)
                * (self?.kToolBarScrollViewW)!, y: 0)
            
            self?.changedPageNumberCallBack?(index,title,button)
        }
        
        if self.midView != nil {
            self.midView!.frame = CGRect(x: kMidToolBarViewMargin, y: self.kTopViewH, width: self.kToolBarScrollViewW - self.kMidToolBarViewMargin * 2, height: self.kMidToolBarViewH)
            self.midToolBarView.displayUI()
            return
        }
        
        
        if kMidToolBarViewH <= 0 {
            return
        }
        
        self.midToolBarView.frame = CGRect(x: kMidToolBarViewMargin, y: self.kTopViewH, width: self.kToolBarScrollViewW - self.kMidToolBarViewMargin * 2, height: self.kMidToolBarViewH)
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
    ///是否已注册
    var isRegisterObserver: Bool = false
    private func setupBottomScrollViewSubView(_ contentOffsetY: CGFloat) {
        //如果要是是ScrollView的子类那么监听contentOffset
        if isRegisterObserver {
            //重复注册，在deinit的时候会出现崩溃现象
            return
        }
        for index: NSInteger in 0 ..< self.bottomViewArray.count {
            //布局subview
            let view: UIView = self.bottomViewArray[index]
            self.bottomScrollView.addSubview(view)
            view.frame = CGRect(x: kToolBarScrollViewW * CGFloat(index), y:0, width: kToolBarScrollViewW, height: kBottomScrollViewH + contentOffsetY)
            
            if view is UIScrollView {
                let scrollView: UIScrollView = view as! UIScrollView
                scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
                self.panGestureRecognizer.require(toFail: scrollView.panGestureRecognizer)
            }
        }
        isRegisterObserver = true
    }
    
    ///通知的移除
    deinit {
        for view in bottomViewArray {
            if view is UIScrollView {
                view.removeObserver(self, forKeyPath: "contentOffset")
                print("%@,已经移除observer",view)
            }
        }
        print("✅ %@,已经被销毁",self)
    }
    
    ///通知的方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            
            if kTopViewH <= 0 {
                return
            }
            
            let scrollView: UIScrollView = object as! UIScrollView
            
            //获取偏移量
            let newValue: CGPoint = change?[NSKeyValueChangeKey.newKey] as! CGPoint
            self.newValue = newValue;
            
            //改变scrollView偏移的位置
            if scrollView.contentOffset.y <= 0{
                if newValue.y < 0 {
                    self.offset = 0
                }
            }
            
            if scrollView.contentOffset.y >= self.kTopViewH {
                if newValue.y > self.kTopViewH {
                    self.offset = 0
                }
            }
            
            if scrollView.contentSize.height <= scrollView.frame.size.height + kTopViewH {
                
                let insertY = scrollView.frame.size.height + kTopViewH - scrollView.contentSize.height
                
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, insertY, 0)
            }else{
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
            
            self.contentOffset = CGPoint(x: 0, y: newValue.y + self.offset)
            let track = scrollView.isDragging && scrollView.isTracking && !scrollView.isDecelerating
            if (!track) {
                //                scrollView.contentOffset.y
            }
        }
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == bottomScrollViewTag {
            //拿到滚动的下标
            //            print("-----",scrollView.contentOffset)
            let index = round(scrollView.contentOffset.x / self.frame.size.width)
            //滚动时候回调
            self.scrollingBottomScrollViewCallBack?(scrollView.contentOffset)
            
            //滚动到页码变了才调用
            if NSInteger(index) != self.midToolBarView.selectOptionIndex {
                //判断是否超出了数组的取值范围
                if index < 0 || NSInteger(index) >= self.bottomViewArray.count  {
                    return
                }
                let index_ = NSInteger(index)
                self.midToolBarView.selectOptionIndex = index_
                if self.bottomViewArray[index_] is UIScrollView {
                    
                    let scroView: UIScrollView = self.bottomViewArray[index_] as! UIScrollView
                    let title = self.midToolBarView.optionTitleStrArray[index_]
                    let button = self.midToolBarView.optionArray[index_]
                    self.changedPageNumberCallBack?(index_,title,button)
                    
                    self.offset = self.contentOffset.y - scroView.contentOffset.y
                }
            }
        }
        
        if scrollView == self {
            if self.contentOffset.y > kTopViewH {
                self.contentOffset = CGPoint(x: 0, y: self.kTopViewH)
            }
            if self.contentOffset.y < 0 {
                self.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
}

