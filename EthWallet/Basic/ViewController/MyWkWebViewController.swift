//
//  MyWkWebViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/12/24.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import WebKit
import JXFoundation

class MyWkWebViewController: JXWkWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("123")
    }
}
