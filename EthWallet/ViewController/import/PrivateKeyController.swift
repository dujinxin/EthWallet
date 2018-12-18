//
//  PrivateKeyController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift
import JXFoundation

class PrivateKeyController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: JXPlaceHolderTextView!{
        didSet{
            textView.layer.cornerRadius = 2
            textView.layer.shadowOpacity = 1
            textView.layer.shadowRadius = 10
            textView.layer.shadowColor = JX10101aShadowColor.cgColor
            textView.layer.shadowOffset = CGSize(width: 0, height: -3)
        }
    }
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.textColor = JXMainColor
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.textColor = JXMainColor
        }
    }
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var importButton: JXShadowButton!
    
    @IBOutlet weak var titleLabel1: UILabel!{
        didSet{
            titleLabel1.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var textLabel1: UILabel!{
        didSet{
            textLabel1.textColor = JXMainText50Color
        }
    }
    
    @IBOutlet weak var titleLabel2: UILabel!{
        didSet{
            titleLabel2.textColor = JXMainTextColor
        }
    }
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        print(view.bounds.height)
        print(UIScreen.main.bounds.height)
        print(UIScreen.main.bounds.height - 44 - 64)
        self.textView.placeHolderText = "输入明文私钥"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    @IBAction func selectAction(_ sender: UIButton) {
    }
    @IBAction func privacyAction(_ sender: Any) {
    }
    @IBAction func importAction(_ sender: Any) {
        
        guard let name = self.nameTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        guard let privateKeyStr = self.textView.text else { return }
        guard
            let keyStore1 = try? EthereumKeystoreV3.init(privateKey: privateKeyStr.hex, password: password),
            let keyStore = keyStore1 else {
            print("keyStore无效")
            return
        }
        do {
            try keyStore.regenerate(oldPassword: password, newPassword: password)
        } catch let error {
            print("原钱包密码错误")
            print(error)
            return
        }
        print("导入成功")

        guard let keystoreData = try? keyStore.serialize() else { return }
        guard let keystoreData1 = keystoreData else { return }
        let keystoreBase64Str = keystoreData1.base64EncodedString()
        
        let address = keyStore.addresses[0]
        //let privateKey = try! keyStore.UNSAFE_getPrivateKeyData(password: password, account: address).toHexString()
        
        let dict: [String :Any] = [
            "name": name,
            "isDefault": 0,
            "isAppWallet": 0,
            "address": address.address,
            "keystore": keystoreBase64Str,
            "mnemonics": "",
            "remark": ""]
        
        let _ = WalletDB.shared.createTable(keys: Array(dict.keys))
        let isSuc = WalletDB.shared.appendWallet(data: dict, key: address.address)
        if isSuc {
            print("添加成功")
            if let block = backBlock {
                block()
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            print("钱包已存在")
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension PrivateKeyController : UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate{
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let _ = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        
        //self.scrollView.setContentOffset(CGPoint(x: 0, y: self.contentSize_heightConstraint.constant - rect.size.height), animated: true)
    }
    @objc func keyboardWillHide(notify:Notification) {
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let _ = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            self.view.endEditing(true)
        }
    }
}
