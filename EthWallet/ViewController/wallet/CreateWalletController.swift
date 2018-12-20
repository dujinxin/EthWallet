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
    @IBOutlet weak var remarkTextField: UITextField!
    
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
        
        
        guard let name = self.walletNameTextField.text, name.isEmpty == false else { return }
        guard let password = self.passwordTextField.text, password.isEmpty == false else { return }
        guard let confirmPsd = self.confirmPsdTextField.text, confirmPsd.isEmpty == false else { return }
        guard let remark = self.remarkTextField.text else { return }
        guard password == confirmPsd else { return }
        
        
        let mnemonics = Mnemonics()
        
        print(mnemonics.string)
        
        let keyStore1 : BIP32Keystore?
        do {
            keyStore1 = try BIP32Keystore(mnemonics: mnemonics, password: password)
        } catch let error {
            print(error)
            fatalError("keyStore创建失败")
        }
        
        guard
            let keyStore = keyStore1,
            let keystoreData = try? keyStore.serialize(),
            let keystoreData1 = keystoreData else { return }
        
        
        
        let keystoreBase64Str = keystoreData1.base64EncodedString()
        let address = keyStore.addresses[0]
        
        let dict: [String :Any] = [
            "name": name,
            "isDefault": 0,
            "isHDWallet": 1,
            "address": address.address,
            "keystore": keystoreBase64Str,
            "mnemonics": mnemonics.string,
            "remark": remark]
        
        guard
            WalletDB.shared.createTable(keys: Array(dict.keys)) == true,
            WalletDB.shared.insertData(data: dict) == true,
            WalletManager.shared.switchWallet(dict: dict) == true else {
            print("保存钱包失败")
            return
        }
        self.performSegue(withIdentifier: "createSuccess", sender: nil)
        
        print(keyStore)
    
        //Web3.default.keystoreManager = KeystoreManager([keyStore])
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
