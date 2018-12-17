//
//  CreateWalletController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/5/27.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift
import JXFoundation

class CreateWalletController : BaseViewController{
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var walletNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPsdTextField: UITextField!
    
    @IBOutlet weak var createButton: JXShadowButton!
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [walletNameTextField,passwordTextField,confirmPsdTextField])
        k.showBlock = { (height, rect) in
            print(height,rect)
        }
        k.tintColor = JXMainTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        
        return k
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建钱包"
        
        self.view.addSubview(self.keyboard)
        
        //self.passwordTextField.text = "12345678"
        //self.confirmPsdTextField.text = "12345678"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    
    @IBAction func createWallet(_ sender: Any) {
        
        //        self.performSegue(withIdentifier: "createSuccess", sender: nil)
        //        return
        
        guard let name = self.walletNameTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        guard let confirmPsd = self.confirmPsdTextField.text else { return }
        guard password == confirmPsd else { return }
        
        let keyStore1 : EthereumKeystoreV3?
        do {
            keyStore1 = try EthereumKeystoreV3(password: password)
        } catch let error {
            print(error)
            fatalError("keyStore创建失败")
        }
        
        guard let keyStore = keyStore1 else { return }
        guard let keystoreData = try? keyStore.serialize() else { return }
        guard let keystoreData1 = keystoreData else { return }
        let keystoreBase64Str = keystoreData1.base64EncodedString()
        
        let address = keyStore.addresses![0]
        
        let dict = ["name":name,"isDefault":false,"address":address.address ,"keystore":keystoreBase64Str] as [String : Any]
        
        let _ = WalletDB.shareInstance.createTable(keys: Array(dict.keys))
        let isSuccess = WalletDB.shareInstance.insertData(data: dict)
        
        if isSuccess {
            let _ = WalletManager.manager.switchWallet(dict: dict)
            //            if let block = backBlock {
            //                block()
            //            }
            self.performSegue(withIdentifier: "createSuccess", sender: nil)
            
            //self.navigationController?.popViewController(animated: true)
        } else {
            print("保存钱包失败")
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
extension CreateWalletController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
