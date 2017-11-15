//
//  KRKnapsackDecorateView.swift
//  koalareading
//
//  Created by 李鹏跃 on 2017/11/9.
//  Copyright © 2017年 koalareading. All rights reserved.
//

import UIKit

class KRKnapsackDecorateView: UICollectionView,
    UICollectionViewDataSource,
    UICollectionViewDelegate
{
    let CELLID = "CELLID"
    let HEADERVIEW = "HEADERVIEW"
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing  = kViewCurrentW_XP(W: 10)
        layout.minimumLineSpacing = kViewCurrentW_XP(W: 50)
        layout.itemSize = CGSize(width: kViewCurrentW_XP(W: 140), height: kViewCurrentH_XP(H: 280))
        layout.sectionInset = UIEdgeInsetsMake(kViewCurrentH_XP(H: 0), kViewCurrentW_XP(W: 40), kViewCurrentW_XP(W: 40), kViewCurrentW_XP(W: 40))
        layout.scrollDirection = .vertical
        super.init(frame: frame, collectionViewLayout: layout)
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP () {
        delegate = self
        dataSource = self
        self.backgroundColor = UIColor.white
        self.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: CELLID)
        self.register(KRKnapsackHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADERVIEW)
    }
    
    
    //MARK: Delegate && DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLID, for: indexPath)
        cell.backgroundColor = UIColor.brown
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: screenWidth, height: kViewCurrentH_XP(H: 20))
    }
    
    //区头设置
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADERVIEW, for: indexPath)
        headerView.backgroundColor = UIColor.red
        return headerView
    }

  
}
