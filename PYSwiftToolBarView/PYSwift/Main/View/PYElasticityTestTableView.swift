
//
//  PYElasticityTestTableView.swift
//  PYSwift
//
//  Created by 李鹏跃 on 2017/11/16.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYElasticityTestTableView: UITableView,
UITableViewDelegate,
UITableViewDataSource
{
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUP() {
        self.dataSource = self
        self.delegate = self
        //tableview的行高自适应,这个要尽量的接近你的自适应高度
        estimatedRowHeight = kViewCurrentH_XP(H: 500)
        //iOS8之后默认就是这个值，可以省略
        rowHeight = UITableViewAutomaticDimension
        self.register(PYElasticityTestTCell.classForCoder(), forCellReuseIdentifier: "CELLID")
    }
}

extension PYElasticityTestTableView {
    ///数据原方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELLID", for: indexPath) as! PYElasticityTestTCell
        cell.indexPath = indexPath
        
        cell.modelArray = [
        "不","是","和","还",
        ]
        
//        cell.receivedSignalFunc {[weak self] (s, me) -> (Any)? in
////
//            self?.indexPathDic[indexPath] = !(self?.indexPathDic[indexPath] ?? false)
//            self?.reloadData()
//            return nil
//        }
        return cell
    }
}
