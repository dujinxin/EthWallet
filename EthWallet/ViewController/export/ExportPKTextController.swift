//
//  ExportPKTextController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/12/16.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class ExportPKTextController: JXBaseViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var titleLabel1: UILabel!{
        didSet{
            titleLabel1.textColor = JXMainColor
        }
    }
    @IBOutlet weak var textLabel1: UILabel!{
        didSet{
            textLabel1.textColor = JXMainText50Color
        }
    }
    
    @IBOutlet weak var titleLabel2: UILabel!{
        didSet{
            titleLabel2.textColor = JXMainColor
        }
    }
    @IBOutlet weak var textLabel2: UILabel!{
        didSet{
            textLabel2.textColor = JXMainText50Color
        }
    }
    
    @IBOutlet weak var titleLabel3: UILabel!{
        didSet{
            titleLabel3.textColor = JXMainColor
        }
    }
    @IBOutlet weak var textLabel3: UILabel!{
        didSet{
            textLabel3.textColor = JXMainText50Color
        }
    }
    
    
    
    @IBOutlet weak var textView: JXPlaceHolderTextView!{
        didSet{
            textView.isEditable = false
            
            textView.layer.cornerRadius = 2
            textView.layer.shadowOpacity = 1
            textView.layer.shadowRadius = 10
            textView.layer.shadowColor = JX10101aShadowColor.cgColor
            textView.layer.shadowOffset = CGSize(width: 0, height: -3)
        }
    }
    @IBOutlet weak var copyButton: JXShadowButton!
    
    var privateKeyStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.textView.text = self.privateKeyStr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func copyKs(_ sender: Any) {
        
        let pals = UIPasteboard.general
        pals.string = self.textView.text
        
        ViewManager.showNotice("复制成功")
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
}
