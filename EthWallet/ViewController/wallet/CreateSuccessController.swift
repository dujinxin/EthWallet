//
//  CreateSuccessController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/12/16.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class CreateSuccessController: BaseViewController {
    @IBOutlet weak var defaultBackView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var successLabel: UILabel!{
        didSet{
            successLabel.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!{
        didSet{
            checkButton.setTitleColor(JXMainColor, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建成功"
        
        if let controllers = self.navigationController?.viewControllers {
            print(controllers)
            let count = controllers.count
            if count > 2 {
                
                self.navigationController?.viewControllers.remove(at: count - 2)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 41
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    @IBAction func copyPrivacyStr(_ sender: Any) {
        
    }
    @IBAction func checkWallet(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
