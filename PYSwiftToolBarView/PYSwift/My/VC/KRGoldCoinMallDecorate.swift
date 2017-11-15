//
//  KRGoldCoinMallDecorate.swift
//  koalareading
//
//  Created by 李鹏跃 on 2017/10/27.
//  Copyright © 2017年 koalareading. All rights reserved.
//

import UIKit
///金币商店 ---> 装饰
class KRGoldCoinMallDecorate: UITableView,UITableViewDelegate,UITableViewDataSource {
    let CellID = "CellID"
    let HEADERVIEW = "HEADERVIEW"
    let FOOTERVIEW = "FOOTERVIEW"
  
    private var modelArray_News: [Any] = []
    private var modelArray_Hot: [Any] = []
    private var modelArray_Interest: [Any] = []
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: .grouped)
        setUPView()
    }
    
    
    private func setUPView() {
        
        let cellClass: AnyClass = UITableViewCell.classForCoder()
        register(cellClass, forCellReuseIdentifier: self.CellID)
   
        self.delegate = self
        self.dataSource = self
        self.rowHeight = kViewCurrentH_XP(H: 300)
//        estimatedRowHeight = kViewCurrentH_XP(H: 600)//tableview的行高自适应
//        rowHeight = UITableViewAutomaticDimension//iOS8之后默认就是这个值，可以省略
        self.tableFooterView = UIView()
    }
    
    
    
    //MARK: - 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 111
    }
    ///数据原方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.CellID, for: indexPath) as! UITableViewCell
        cell.selectionStyle = .none
//        cell.textLabel?.text = indexPath.description
      
       let image = UIImage.init(named: "3")
       let imageView = UIImageView.init(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        cell.contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: kViewCurrentH_XP(H: 300))
        return cell
    }
    
    //MARK: 代理方法
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kViewCurrentH_XP(H: 20)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    //返回分区头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HEADERVIEW) ?? UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FOOTERVIEW) ?? UIView()
        headerView.backgroundColor = UIColor.blue
        return headerView
    }
}
