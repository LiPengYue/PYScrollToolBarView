//
//  PYCollectionView.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/4/9.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class PYCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource {

    static let CELLID: String = "CELLID"
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
            
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.delegate = self
        self.dataSource = self
        
        self.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: PYCollectionView.CELLID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PYCollectionView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PYCollectionView.CELLID, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        return cell
        
    }
    
}


