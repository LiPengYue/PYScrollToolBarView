//
//  InformationViewController.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/7.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.brown
        let handDate: PYHandleDate = PYHandleDate.handleDate
        let a: Date = Date.init(timeIntervalSinceNow: 12)
        let b: TimeInterval = a.timeIntervalSince1970 
        let date: Date? = handDate.changeObj(b.description, "yyyy-MM-dd HH:mm:ss")
        
        print("时间对象date --- ",date ?? "没有")
        let dateMatt = DateFormatter()
        dateMatt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str: String = dateMatt.string(from: date!)
         print("时间字符串date --- ",str)
        let date2: String = self.toolsChangeDataStyle(toFullStyle: b.description)
        print("---",date2)
    }

    //日期处理--后台给的是全位数（20161112190000） -> 2016-11-12 19:00:00
    func toolsChangeDataStyle(toFullStyle string: String) -> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMddHHmmss"
        let date = dateFormat.date(from: string)
        let dateMatt = DateFormatter()
        dateMatt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateMatt.string(from: date ?? Date())
        return str
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
