//
//  MyTableViewController.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/7.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit
import JXFoundation
import MBProgressHUD

let reuseIdentifierNormal = "reuseIdentifierNormal"

class MyTableViewController: JXTableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MyTableViewController {
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
