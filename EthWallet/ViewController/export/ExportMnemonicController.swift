//
//  ExportMnemonicController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/12/17.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ExportMnemonicController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!


    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            topConstraint.constant = kNavStatusHeight + 30
        }
    }
    @IBOutlet weak var textLabel1: UILabel!{
        didSet{
            textLabel1.textColor = JXMainText50Color
        }
    }

    @IBOutlet weak var textBackView: UIView!{
        didSet{
            textBackView.backgroundColor = UIColor.groupTableViewBackground
            textBackView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var textLabel2: UILabel!{
        didSet{
            textLabel2.textColor = JXMainTextColor
        }
    }
    
    @IBOutlet weak var nextButton: JXShadowButton!
    
    var mnemonicStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "备份助记词"
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.textLabel2.text = self.mnemonicStr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VerifyMnemonicController {
            vc.mnemonicStr = self.mnemonicStr
        }
    }
    @IBAction func nextStep(_ sender: Any) {
        
    }
}
