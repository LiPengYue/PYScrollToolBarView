//
//  PYToolBarView.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/8.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit
///toolBarViewOptionTag值统一都加了1000
let toolBarViewOptionTagBasis: NSInteger = 1000

class PYToolBarView: UIView {
    
    //MARK: --------------- 私有属性 --------------------------
    ///optionTitleStrArray(这个属性是生成toolBarView的关键)
    private lazy var _optionTitleStrArray: [String] = [String]()
    ///optionFrames
    private lazy var _optionFrameArray: [NSValue] = {
        let optionFrames: [NSValue] = [NSValue]()
        return optionFrames
    }()
    ///optionW: 选项的宽度
    private var _optionW: CGFloat?
    ///选中的option 下标 （默认为0）
    private var _selectOptionIndex: NSInteger = 0;
    ///选中的option
    private var _selectOption: UIButton = UIButton.init()
    ///线的位置集合
    private lazy var _lineFrameArray: [NSValue] = { () -> [NSValue] in
        let lineFrameArray: [NSValue] = [NSValue]()
        return lineFrameArray
    }()
    ///点击事件的回调
    var clickOptionCallBack: ((UIButton,String,NSInteger)->())?
    ///是否要刷新subView
    private var isLayoutSubView: Bool?
    
    ///将要改变当前选中button的方法
    var willChangeCurrentIndexBlock: ((_ fromeIndex:NSInteger, _ toIndex: NSInteger) -> (Bool))?
    
    
    //MARK: ------------------ 下面的开始属性的设置 -------------------------
    
    
    //MARK: ------------------ 选项的title数组 --------------------------
    ///optionTitleStrArray(这个属性是生成toolBarView的关键) (计算属性)
    var optionTitleStrArray: [String] {
        get {
            return _optionTitleStrArray
        }
        set (newValue) {
            _optionTitleStrArray = newValue
        }
    }
    
    
    //MARK: ------------------ 手动刷新UI --------------------------
    ///考虑到性能 大家一定要手动刷新UI 才能为子控件布局
    func displayUI() {
        self.isLayoutSubView = true
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        //清空数组
        //删除数组中储存的option
        self.optionArray.removeAll()
        _optionFrameArray.removeAll()
        //清空线的信息数组
        _lineFrameArray.removeAll()
        
        self.setupOption()
        //创建底部的动画选中指示条
        self.animaIndicatorBar()
        self.layoutSubviews()
    }
    
    
    //MARK: ------------------ 点击事件的回应 -----------------------------
    
    /**
     * 1. clickOptionCallBack: 点击调用的闭包
     * * option: 每个点击的选项
     * * title: 选项的描述
     * * index: 点击的索引
     */
    func clickOptionCallBackFunc(clickOptionCallBack: @escaping (_ option: UIButton, _ optionTitle: String, _ optionIndex: NSInteger) -> Swift.Void){
        self.clickOptionCallBack = clickOptionCallBack
    }
    func willChanageCurrentPageFunc(_ event:@escaping ((_ fromeIndex:NSInteger, _ toIndex: NSInteger) -> (Bool))) {
        self.willChangeCurrentIndexBlock = event
    }
    
    //MARK: ------------------ 关于中间line --------------------------------
    ///线宽 默认是1.0
    var lineWidth: CGFloat = 1.0
    
    ///线的与选项之间的间离，（默认centerY 与 option的centerY对齐）
    var distanceBetweenLine: CGFloat {
        get {
            return _distanceBetweenLine
        }
        set (newValue) {
            _distanceBetweenLine = newValue
        }
    }
    private var _distanceBetweenLine: CGFloat = 0.0
    
    
    ///线的位置集合 (只读计算属性)
    var lineFrameArray: [NSValue] {
        get {
            return _lineFrameArray
        }
    }
    
    ///自定义line的颜色 (默认是灰色)
    lazy var lineColor: UIColor = {
        let color = UIColor.lightGray
        return color
    }()
    
    
    
    //MARK: ------------------ 关于option --------------------------------
    ///option颜色状态
    
    var customOptionUICallBack: ((_ option: UIButton,_ index: NSInteger, _ title: String)->())?
    ///自定义option的样式，可以统一的改变option的样式（比如形状，大小）
    func customOptionUICallFunc(customOptionUICallBack:@escaping (_ option: UIButton,_ index: NSInteger, _ title: String) -> ()) {
        self.customOptionUICallBack = customOptionUICallBack
    }
    
    ///option默认颜色 （默认为黑色）
    lazy var optionColorNormal: UIColor? = {
        let color: UIColor = UIColor.black
        return color
    }()
    
    ///option选中时候的颜色 （默认为红色）
    lazy var optionColorSelected: UIColor? = {
        let color: UIColor = UIColor.red
        return color
    }()
    
    ///option高亮状态下的颜色 (默认为黑色)
    lazy var optionColorHighlighted: UIColor? = {
        let color: UIColor = self.optionColorNormal!
        return color
    }()
    
    ///optionFont: 字体 (默认系统字体20)
    lazy var optionFont: UIFont = {
        let font: UIFont = UIFont.systemFont(ofSize: 20)
        return font
    }()
    
    ///option选中的背景色
    lazy var optionBackgroundColorSelected: UIColor = {
        return self.optionBackgroundColorNormal
    }()
    ///option选中的背景色
    lazy var optionBackgroundColorNormal: UIColor = {
        return self.backgroundColor ?? UIColor.white
    }()
    ///选中的option 计算属性
    var selectOption: UIButton {
        get {
            return _selectOption
        }
        set (newValue){
            _selectOption.isSelected = false
            _selectOption.backgroundColor = optionBackgroundColorNormal
            _selectOption = newValue
            _selectOption.backgroundColor = optionBackgroundColorSelected
            _selectOption.isSelected = true
        }
    }
    
    ///选中的option 下标 (只读计算属性 默认为0)
    var selectOptionIndex: NSInteger {
        get {
            return _selectOptionIndex
        }
        set (newValue) {
            //不允许重复点击
            if (_selectOptionIndex == newValue) && !self.isRecurClick{
                return
            }
            let fromeIndex: NSInteger = _selectOptionIndex
            _selectOptionIndex = newValue//必须赋值成功
            if self.optionArray.count == 0 {
                return //表示暂无option
            }
            //            let title = self.optionTitleStrArray[newValue]
            //            let option = self.optionArray[newValue]
            //            let index: NSInteger = option.tag - toolBarViewOptionTagBasis
            //            self.clickOptionCallBack?(selectOption,title,index)
            
            self.selectOption = self.optionArray[newValue]
            self.changeAnimaIndicatorBarView(fromIndex: fromeIndex, toIndex: _selectOptionIndex, isAnima: true)
        }
    }
    
    
    ///optionW: 选项的宽度 (只读计算属性)
    var optionW: CGFloat? {
        get {
            return _optionW
        }
    }
    
    ///每个选项的frame (只读计算属性)
    var optionFrameArray: [NSValue] {
        get {
            return _optionFrameArray
        }
    }
    
    ///option的集合 (懒加载)
    var optionArray: [UIButton] =  [UIButton]()
    
    ///option是否允许重复点击
    var isRecurClick: Bool = true
    
    
    //MARK: ------------- 关于自定义动画的属性 ------------------------
    ///动画的View
    var _animaIndicatorBarView: UIView = UIView.init()
    ///动画的view （计算属性）
    var animaIndicatorBarView: UIView {
        get{
            return _animaIndicatorBarView
        }
        set (newValue){
            _animaIndicatorBarView = newValue
            
        }
    }
    ///动画view的动画时间 （默认是0.2秒）
    var animaIndicatorBarView_animaTime: CGFloat = 0.2
    ///动画view的高度 (默认是2.0)
    var animaIndicatorBarViewH: CGFloat = 2.0
    ///动画view与option边缘的间距 (默认是0)
    var animaIndicatorBarViewMargin: CGFloat = 0
    ///动画view的背景颜色
    var animaIndicatorBarViewColor: UIColor = UIColor.blue
    
    ///自定义option选中时候的动画
    var customOptionWhenChangeSelectOptionIndex: ( (_ fromOption: UIButton, _ toOption: UIButton, _ fromIndex: NSInteger, _ toIndex: NSInteger)->())?
    
    ///关于更换选中按钮时候的动画自定义
    /**
     customOptionWhenChangeSelectOptionIndex: 自定义动画的block
     *fromOption: 更换选项前的被选中按钮
     * toOption: 更换选项后的选中按钮
     * fromIndex:  fromOption的下标
     * toIndex: toOption的下标
     */
    func customOptionWhenChangeSelectOptionFunc(customOptionWhenChangeSelectOptionIndex: @escaping (_ fromOption: UIButton, _ toOption: UIButton, _ fromIndex: NSInteger, _ toIndex: NSInteger)->()) {
        //关闭重复点击
        self.isRecurClick = false
        self.customOptionWhenChangeSelectOptionIndex = customOptionWhenChangeSelectOptionIndex
    }
    
    
    
    //MARK: --------------- 创建 （init） -----------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white
    }
    
    //MARK: --------------  布局子控件（layoutSubviews） --------------
    override func layoutSubviews() {
        super.layoutSubviews()
        if isLayoutSubView == true {
            self.displaySubViwe()
            self.isLayoutSubView = false
            self.setNeedsDisplay()
        }
    }
    
    
    //MARK: --------------- 绘图 ----------------------------
    override func draw(_ rect: CGRect) {
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return print("toolBar上下文获取失败") }
        if lineFrameArray.count < optionTitleStrArray.count {
            return
        }
        //绘图
        for i in 0..<self.optionTitleStrArray.count {
            let rect: CGRect = self.lineFrameArray[i].cgRectValue
            let color: CGColor = self.lineColor.cgColor
            context.setFillColor(color)
            context.fill(rect)
        }
    }
    
    //MARK: --------------- displaySubViwe 方法 ---------------------------
    private func displaySubViwe() {
        self.isLayoutSubView = false//防止没必要的多次布局
        
        ///option宽度
        _optionW = self.getOptionWitdhFunc()
        
        ///第一次移动到指定的位置
        self.changeAnimaIndicatorBarView(fromIndex: 0, toIndex: self._selectOptionIndex, isAnima: false)
        
        ///中间画线的frame在计算属性中获取
        _lineFrameArray = self.getLinesFrameFunc()
        
        ///option的frame
        _optionFrameArray = self.getOptionFrameFunc()
    }
}


private extension PYToolBarView {
    
    //MARK: option宽度
    func getOptionWitdhFunc() -> CGFloat{
        return (self.frame.size.width - CGFloat(NSInteger(self.optionTitleStrArray.count - 1)) * CGFloat(self.lineWidth)) / CGFloat(NSInteger( self.optionTitleStrArray.count))
    }
    
    
    //MARK: 中间划线的frame计算
    func getLinesFrameFunc() -> [NSValue] {
        //计算
        let lineW = lineWidth
        let optionW = self.optionW!
        
        var lineX: CGFloat
        let lineY: CGFloat = self.distanceBetweenLine
        let lineH: CGFloat = self.frame.size.height - 2 * self.distanceBetweenLine
        
        var lineFrameArray: [NSValue] = [NSValue]()
        
        //求出x的值
        for i in 0..<self.optionTitleStrArray.count {
            let j: CGFloat = CGFloat (i)
            //X
            lineX = j * lineW + (j + 1) * optionW
            let lineRect: CGRect = CGRect(x: lineX, y: lineY, width: lineW, height: lineH)
            let lineRectValue: NSValue = NSValue.init(cgRect: lineRect)
            lineFrameArray.append(lineRectValue)
        }
        return lineFrameArray
    }
    
    
    
    //MARK: option的frame计算
    func getOptionFrameFunc() -> [NSValue] {
        let optionH: CGFloat = self.frame.size.height
        let optionW: CGFloat = self.optionW!
        let optionY: CGFloat = 0
        let lineW: CGFloat = self.lineWidth
        var optionX: CGFloat?
        
        var optionFrameArray: [NSValue] = [NSValue]()
        
        for i in 0..<self.optionTitleStrArray.count {
            let j: CGFloat = CGFloat(i)
            optionX = (optionW + lineW) * j
            let optionFrame: CGRect = CGRect(x: optionX!, y: optionY, width: optionW, height: optionH)
            let optionFrameValue: NSValue = NSValue.init(cgRect: optionFrame)
            optionFrameArray .append(optionFrameValue)
            
            //MARK: frame赋值
            self.optionArray[i].frame = optionFrame
        }
        return optionFrameArray
    }
    
    
    
    //MARK: -------------- 创建并布局button -------------------------
    func setupOption() {
        
        for i in 0..<self.optionTitleStrArray.count {
            
            // 创建option
            let option: UIButton = UIButton.init()
            self.addSubview(option)
            
            // text & font
            let title: String = self.optionTitleStrArray[i]
            option.setTitle(title, for: UIControlState.normal)
            option.titleLabel?.font = self.optionFont
            
            // color
            option.setTitleColor(self.optionColorNormal, for: UIControlState.normal)
            option.setTitleColor(self.optionColorSelected, for: UIControlState.selected)
            option.setTitleColor(self.optionColorHighlighted, for: UIControlState.highlighted)
            option.backgroundColor = self.optionBackgroundColorNormal
            
            //手势
            let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(clickOption))
            option.addGestureRecognizer(tap)
            
            //设置option tag值
            option.tag = toolBarViewOptionTagBasis + i
            
            //点击是否高亮
            option.showsTouchWhenHighlighted = false
            
            //添加
            self.optionArray.append(option)
            
            //设置选中
            if self.selectOptionIndex == i {
                self.selectOption = option
            }
            //自定义option样式的接口
            self.customOptionUICallBack?(option,i,title)
        }
    }
    
    
    
    //MARK: 点击事件的添加
    @objc private func clickOption(tap: UITapGestureRecognizer) {
        
        let option: UIButton = tap.view as! UIButton
        //不允许重复点击 放到了index的计算属性的setter方法里
        if (option == self.selectOption) && !self.isRecurClick{
            return
        }
        
        //将要改变当前选中button的方法
        let fromIndex: NSInteger = self.selectOption.tag - toolBarViewOptionTagBasis
        let toIndex: NSInteger = option.tag - toolBarViewOptionTagBasis
        if (self.willChangeCurrentIndexBlock?(fromIndex,toIndex)) ?? false {
            return
        }
        
        let title = self.optionTitleStrArray[toIndex]
        self.clickOptionCallBack?(option,title,toIndex)
        
        //如果选中的与现在选中的一致，那么不做selected操作 在了index的计算属性的 setter方法里面设置
        
        //改变option的状态 （在set方法里做了下部view动画的操作）
        self.selectOptionIndex = toIndex
    }
    
    
    
    //MARK: animaIndicatorBar 动画指示条
    func animaIndicatorBar() {
        self.addSubview(self.animaIndicatorBarView)
        self.animaIndicatorBarView.backgroundColor = self.animaIndicatorBarViewColor
        //        self.changeAnimaIndicatorBarView(index: self.selectOptionIndex, isAnima: false)//移动到了layoutSubView里面，因为如果不设置frame的话，这个时候拿不到宽度
    }
    
    
    //MARK: 根据选中的索引 设置frame并添加动画
    func changeAnimaIndicatorBarView (fromIndex: NSInteger, toIndex: NSInteger, isAnima: Bool) {
        let indexFloat: CGFloat = CGFloat(toIndex)
        let W = self.optionW! - self.animaIndicatorBarViewMargin * 2
        let H = self.animaIndicatorBarViewH
        let Y: CGFloat = self.frame.size.height - H
        let X: CGFloat = indexFloat * (self.optionW! + self.lineWidth) + self.animaIndicatorBarViewMargin
        if isAnima {
            UIView.animate(withDuration: TimeInterval(self.animaIndicatorBarView_animaTime), animations: {
                self.animaIndicatorBarView.frame = CGRect(x: X, y: Y, width: W, height: H)
            })
        }else {
            self.animaIndicatorBarView.frame = CGRect(x: X, y: Y, width: W, height: H)
        }
        let toOption: UIButton = self.optionArray[toIndex]
        let fromOption: UIButton = self.optionArray[fromIndex]
        //执行动画
        self.customOptionWhenChangeSelectOptionIndex?(fromOption,toOption,fromIndex,toIndex)
    }
}
