//
//  KeyStoreController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift
import JXFoundation

class KeyStoreController: JXBaseViewController {

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
            nameTextField.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.textColor = JXMainTextColor
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
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [textView,nameTextField,passwordTextField])
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
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        
        self.textView.placeHolderText = "keystone 文件内容"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        guard let keystoreStr = self.textView.text else { return }
        
        guard let keyStore = EthereumKeystoreV3(keystoreStr) else {
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
        
        guard let keystoreData = keystoreStr.data(using: .utf8) else { return }
        
        let keystoreBase64Str = keystoreData.base64EncodedString(options: .lineLength64Characters)
        let address = keyStore.addresses[0]
        //let privateKey = try! keyStore.UNSAFE_getPrivateKeyData(password: password, account: address).toHexString()
        let dict: [String :Any] = [
            "name": name,
            "isDefault": 0,
            "isHDWallet": 0,
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
extension KeyStoreController : UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate{
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
        print("notify = ","notify")
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
