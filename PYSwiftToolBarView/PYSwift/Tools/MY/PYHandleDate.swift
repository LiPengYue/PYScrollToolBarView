//
//  PYHandleDate.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/9.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//


import UIKit
import Foundation

enum PYHandleDateCompareDateType {
    case Little
    case Long
}

class PYHandleDate: NSObject {
    
    //MARK: -------------------- 属性 ---------------------------------
    /// * _dateFormatter: 时间格式管理者
    private let _dateFormatter: DateFormatter = DateFormatter()
    /// * 日历
    var calender: Calendar = Calendar.current
    /// * dateFormatter
    var dateFormatter: DateFormatter {
        get {
            return _dateFormatter
        }
    }
    
    
    //MARK: ------------------- 单利创建 ----------------------------------
    ///单利对象
    static let handleDate: PYHandleDate = {
        let _handleDate: PYHandleDate = PYHandleDate()
        _handleDate.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return _handleDate
    }()
  
    
    //MARK: -------------------- 转化时间对象 --------------------------------
    /**
     *对象转化成时间
     * obj: 一个对象： 可以是String NSNumber，注意如果String类型，那么分隔符一定要与formatter一致
     * formatter: 时间分隔模式
     */
    func changeObj(_ obj: Any, _ formatter: String?) -> (Date?) {
        return self.changeObjDuplicate(obj, formatter)
    }
    
    
    //MARK: -------------------- 比较时间早晚方法 -----------------------------
    ///计算时间的差值
    /// * startDate: 开始时间
    /// * endDate: 结束时间
    /// * formatter: 时间格式化标准
    /// * customCalendar: 自定义的日历
    /// * components: 要获取的时间组件集合
    /// * compareCallBack: 对于一部分时间组件的集合的回调
    /// * return: DateComponents: 时间组件集合
    func compare(_ startDate: Any, _ endDate: Any?, _ formatter: String?, customCalendar:Calendar?,_ components: Set<Calendar.Component>?, _ compareCallBack: ((_ year: NSInteger, _ month: NSInteger, _ day: NSInteger, _ hour: NSInteger, _ minute: NSInteger,  _ second: NSInteger) -> ())?) -> (DateComponents?) {
        //执行比较时间函数
        return self.compareDuplicate(startDate, endDate, formatter, customCalendar: calender, components, compareCallBack)
    }
    
    ///获取某个时间的年月日时分秒
    /// * date : 要获取的时间对象（可以是字符串，NSUmber，TimerInteger）
    /// * calender: 日历
    /// * formatter: 时间格式化标准
    /// * components: 拆分格式化标准
    /// * return: DateComponents 拆分的结果集
    func getDateComponents(_ date: Any, _ calender: Calendar?, _ formatter: String, _ components: Set<Calendar.Component>?) -> (DateComponents) {
        return self.getDateComponentsDuplicate(date, calender, formatter,    components)
    }
}




//MARK: --------------------------- 时间操作 -----------------------
private extension PYHandleDate {
    ///计算时间的差值
    func compareDuplicate(_ startDate: Any, _ endDate: Any?, _ formatter: String?, customCalendar:Calendar?,_ components: Set<Calendar.Component>?, _ compareCallBack: ((_ year: NSInteger, _ month: NSInteger, _ day: NSInteger, _ hour: NSInteger, _ minute: NSInteger,  _ second: NSInteger) -> ())?) -> (DateComponents?) {
        
        if formatter != nil {
            self.dateFormatter.dateFormat = formatter
        }
        
        //转化对象 (具有相同的分隔印记的时间对象)
        let startDateChange: Date = self.changeObj(startDate, self.dateFormatter.dateFormat) ?? Date()
        
        // 开始时间data格式如果没有传入 那么默认是当前时间
        let endDateChange: Date = self.changeObj(endDate ?? Date.init(), self.dateFormatter.dateFormat) ?? Date()
        
        //日历
        let calenderTemp: Calendar = customCalendar ?? self.calender
        
        //通过日历 创建NSDateComponents
        let componentsTemp: Set<Calendar.Component> = components ?? [.year,.month,.day,.hour,.minute,.second]
        
        //比较时间
        let dateComponents: DateComponents = calenderTemp.dateComponents(componentsTemp, from: startDateChange, to: endDateChange)
        
        //做了初步的处理
        let year = dateComponents.year ?? 0
        let month = dateComponents.month ?? 0
        let day = dateComponents.day ?? 0
        let hour = dateComponents.hour ?? 0
        let minute = dateComponents.minute ?? 0
        let second = dateComponents.second ?? 0
        
        //执行block 把值传到外界
        compareCallBack?(year,month,day,hour,minute,second)
        
        //返回比较的结果集
        return dateComponents
    }
    /**
     *对象转化成时间
     * obj: 一个对象： 可以是String NSNumber，注意如果String类型，那么分隔符一定要与formatter一致
     * formatter: 时间分隔模式
     */
    func changeObjDuplicate(_ obj: Any, _ formatter: String?) -> (Date?) {
        
        if let dateFormat = formatter {
            self.dateFormatter.dateFormat = dateFormat
        }
        
        var date: Date?
        
        //判断类型
        //string
        if obj is String {
            //转化成时间对象
            var dateStr:String = obj as! String
            date = self.dateFormatter.date(from: dateStr)
            //判断是否转换成功 （转换成功就返回 否则按NSNumber处理）
            if let resultDate: Date = date {
                return resultDate
            }
            
            //看来没有成功
            let dateNum: TimeInterval = TimeInterval(dateStr)!
            //转化成时间
            let dateTemp: Date  = Date.init(timeIntervalSince1970: TimeInterval(dateNum))
            
            dateStr = self.dateFormatter.string(from: dateTemp)
            
            date = self.dateFormatter.date(from: dateStr)
            if let resultDate: Date = date {
                return resultDate
            }
        }
        
        if obj is TimeInterval {
            let dateNum: TimeInterval = obj as! TimeInterval
            let dateTemp: Date?  = Date.init(timeIntervalSince1970: TimeInterval(dateNum))
            if dateTemp != nil {
                return dateTemp
            }
        }
        //是NSNumber类型
        if obj is NSNumber {
            var dateStr: String = (obj as AnyObject).description
            let dateNum: NSInteger = NSInteger(dateStr)!
            
            //转化成时间
            let dateTemp: Date  = Date.init(timeIntervalSince1970: TimeInterval(dateNum))
            
            dateStr = self.dateFormatter.string(from: dateTemp)
            
            date = self.dateFormatter.date(from: dateStr)
            if let resultDate: Date = date {
                return resultDate
            }
        }
        print("《handleDateChangeObj》 方法中，对象<——>时间 的转化错误")
        return nil
    }
    
    ///获取某个时间的年月日时分秒
    func getDateComponentsDuplicate(_ date: Any, _ calender: Calendar?, _ formatter: String, _ components: Set<Calendar.Component>?) -> (DateComponents) {
        let dateComponents: Date = self.changeObj(date, formatter) ?? Date.init()
        
        //日历
        let calenderTemp: Calendar = calender ?? self.calender
        
        //通过日历 创建NSDateComponents
        let componentsTemp: Set<Calendar.Component> = components ?? [.year,.month,.day,.hour,.minute,.second]
        
        return calenderTemp.dateComponents(componentsTemp, from: dateComponents)
    }

}



// ---------------------------  -----------------------------
/*
 swift时间的比较 可以用">", "<", "==", ">=", "<="
*/

/**
 EEEE: 代表一天的全名,比如Monday.使用1-3个E就代表简写,比如Mon.
 MMMM: 代表一个月的全名,比如July.使用1-3个M就代表简写,比如Jul.
 dd: 代表一个月里的几号,比如07或者30.
 yyyy: 代表4个数字表示的年份,比如2016.
 HH: 代表2个数字表示的小时,比如08或17.
 mm: 代表2个数字表示的分钟,比如01或59.
 ss: 代表2个数字表示的秒,比如2016.
 zzz: 代表3个字母表示的时区,比如GTM(格林尼治标准时间,GMT+8为北京所在的时区,俗称东八区)
 GGG: BC或者AD, 即公元前或者公元
 系统自带的样式不够用时, 就可以使用自定义说明符自定义Date的输出格式.
 自定义说明符的另一个巨大的作用就是可以将复杂的字符类型的日期格式(比如Fri, 08 Aug 2016 09:22:33 GMT)转换成Date类型.
 */
