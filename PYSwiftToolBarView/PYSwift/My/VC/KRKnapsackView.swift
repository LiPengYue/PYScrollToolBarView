//
//  KRKnapsackView.swift
//  koalareading
//
//  Created by 李鹏跃 on 2017/11/8.
//  Copyright © 2017年 koalareading. All rights reserved.
//

import UIKit

class KRKnapsackView:UICollectionView,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate
{
  let CELLID = "CELLID"
      let HEADERVIEW = "HEADERVIEW"
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let layoutF = UICollectionViewFlowLayout()
        layoutF.itemSize = CGSize(width: kViewCurrentW_XP(W: 325), height: kViewCurrentW_XP(W: 202))
        layoutF.scrollDirection = .vertical
        layoutF.minimumLineSpacing = kViewCurrentW_XP(W: 40)
        layoutF.minimumInteritemSpacing = kViewCurrentW_XP(W: 30)
        layoutF.sectionInset = UIEdgeInsetsMake(kViewCurrentW_XP(W: 30), kViewCurrentW_XP(W: 30), 0, kViewCurrentW_XP(W: 30))
        super.init(frame: frame, collectionViewLayout: layoutF)
        
        setUP()
//        self.contentInset = UIEdgeInsetsMake(kViewCurrentH_XP(H: 20), 0, 0, 0)
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
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLID, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        let image = UIImage.init(named: "2")
        let imageView = UIImageView.init(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        cell.contentView.addSubview(imageView)
        imageView.frame = cell.bounds
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        view.backgroundColor = UIColor.brown
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: screenWidth, height: kViewCurrentH_XP(H: 20))
    }
  
    //区头设置
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADERVIEW, for: indexPath)
        
        headerView.backgroundColor = UIColor.gray
        return headerView
    }
}


