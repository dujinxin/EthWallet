//
//  MyBaseViewController.swift
//  ShoppingGo-Swift
//
//  Created by 杜进新 on 2017/6/6.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit
import MBProgressHUD
import JXFoundation

open class MyBaseViewController: JXBaseViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = JXFfffffColor
    }
}

extension MyBaseViewController {
    open func showMBProgressHUD() {
        let _ = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.backgroundView.color = UIColor.black
//        hud.contentColor = UIColor.black
//        hud.bezelView.backgroundColor = UIColor.black
//        hud.label.text = "加载中..."
    }
    open func hideMBProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

