//
//  PYTableView.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/4/9.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    static let CELLID: String = "CELLID"
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.backgroundColor = #colorLiteral(red: 0.8565997481, green: 1, blue: 0.90980579, alpha: 1)
        self.delegate = self
        self.dataSource = self
        self.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: PYTableView.CELLID)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PYTableView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: PYTableView.CELLID, for: indexPath)
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
}

