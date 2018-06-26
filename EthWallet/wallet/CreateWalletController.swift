//
//  CreateWalletController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/5/27.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

import web3swift

class CreateWalletController: UITableViewController {

    @IBOutlet weak var walletNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var confirmPsdTextField: UITextField!
    @IBOutlet weak var noticeTextField: UITextField!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    var backBlock : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.passwordTextField.text = "12345678"
        self.confirmPsdTextField.text = "12345678"
        
        
//        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        FileManager.default.createFile(atPath: userDir + "/bip32_keystore"+"/key.json", contents: nil, attributes: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectAction(_ sender: UIButton) {
    }
    
    @IBAction func viewPrivacy(_ sender: Any) {
        
    }

    @IBAction func createWallet(_ sender: Any) {
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
        //let privateKey = try! keyStore.UNSAFE_getPrivateKeyData(password: password, account: address).toHexString()

//        let jsonStr = String.init(data: keyStore.serialize(), encoding:.utf8)
//        let jsonDict = JSONSerialization.jsonObject(with: keyStore.serialize(), options: [])
        
        let dict = ["name":name,"isDefault":false,"address":address.address ,"keystore":keystoreBase64Str] as [String : Any]
        
        let _ = WalletDB.shareInstance.createTable(keys: Array(dict.keys))
        let isSuccess = WalletDB.shareInstance.insertData(data: dict)
        
        if isSuccess {
            if let block = backBlock {
                block()
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            print("保存钱包失败")
        }
        
        
        
        
        //        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //        //create BIP32 keystore
        //        let bip32keystoreManager = KeystoreManager.managerForPath(userDir + "/bip32_keystore", scanForHDwallets: true)
        //
        //        let keyStore : BIP32Keystore?
        //        if (bip32keystoreManager?.addresses?.count == 0) {
        //            //创建助记词
        //            let mnemonic = try! BIP39.generateMnemonics(bitsOfEntropy: 128, language: .english)
        //            let seed = BIP39.seedFromMmemonics(mnemonic!)
        //
        //            keyStore = try! BIP32Keystore.init(mnemonics: mnemonic!, password: password, mnemonicsPassword: "", language: .english, prefixPath: HDNode.defaultPathPrefix)
        //            let address = keyStore?.addresses![0]
        //            let privateKey = try! keyStore?.UNSAFE_getPrivateKeyData(password: password, account: address!).toHexString()
        //
        //            let keydata = try! JSONEncoder().encode(keyStore!.keystoreParams)
        //            FileManager.default.createFile(atPath: userDir + "/bip32_keystore"+"/key.json", contents: keydata, attributes: nil)
        //
        //            print("mnemonic = ",mnemonic)
        //            print("seed = ",seed)
        //            print("privateKey = ",privateKey)
        //            print("web3 = ",web3)
        //
        //            let dict = ["name":name,"password":password,"address":address?.address,"privateKey":privateKey] as [String : Any]
        //
        //            let _ = WalletManager.manager.saveAccound(dict: dict)
        //        } else {
        //            keyStore = bip32keystoreManager?.walletForAddress((bip32keystoreManager?.addresses![0])!) as? BIP32Keystore
        //        }
        //        web3?.addKeystoreManager(bip32keystoreManager)
        
        
    }
    func web3Kit() {

//        var bip32ks: BIP32Keystore?
//        if (bip32keystoreManager?.addresses?.count == 0) {
//            bip32ks = try! BIP32Keystore.init(mnemonics: "normal dune pole key case cradle unfold require tornado mercy hospital buyer", password: password, mnemonicsPassword: "", language: .english)
//            let keydata = try! JSONEncoder().encode(bip32ks!.keystoreParams)
//            FileManager.default.createFile(atPath: userDir + "/bip32_keystore"+"/key.json", contents: keydata, attributes: nil)
//        } else {
//            bip32ks = bip32keystoreManager?.walletForAddress((bip32keystoreManager?.addresses![0])!) as? BIP32Keystore
//        }
//        guard let bip32sender = bip32ks?.addresses?.first else {return}

    
        
//        let pathUrl = URL(fileURLWithPath: userDir + "/bip32_keystore"+"/key.json")
//
//        guard
//            let data = try? Data(contentsOf: pathUrl),
//            let dict = try? JSONSerialization.jsonObject(with: data, options: []) else {
//                print("该地址不存在keystore：\(pathUrl)")
//                return
//        }
//        print(dict)
        
        
    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
