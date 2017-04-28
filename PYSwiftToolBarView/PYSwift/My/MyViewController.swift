//
//  MyViewController.swift
//  PYSwift
//
//  Created by 李鹏跃 on 17/3/7.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

class MyViewController: UIViewController,UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    func setButton() -> UIButton{
        let button: UIButton = UIButton.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.setTitle("点我", for: UIControlState.normal)
        button.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        button.addTarget(self, action: #selector(clickButton), for: UIControlEvents.touchUpInside)
        return button
    }
    
    func clickButton(_ button: UIButton) {
        
        let vc: UIViewController = UIViewController.init()
        
        let button: UIButton = self.setButton()
        vc.view.addSubview(button)
        vc.view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    
        vc.transitioningDelegate = self
        
        self.modalPresentationStyle = .custom;
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController {

    
}
