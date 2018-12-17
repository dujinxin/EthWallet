//
//  WalletManager.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/1.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation
import web3swift
import JXFMDBHelper

private let userPath = NSHomeDirectory() + "/Documents/userAccound.json"

class WalletEntity: NSObject {
    
    @objc var isDefault : Bool = false           //
    @objc var name : String = ""                 //钱包名称
    @objc var address : String = ""              //钱包地址
    @objc var keystore : String = ""
    
    @objc var notice : String = ""               //密码提示
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("")
    }
}

class WalletManager : NSObject{
    
    static let manager = WalletManager()
    
    //登录接口获取
    var walletEntity = WalletEntity()
    //
    var walletDict = Dictionary<String, Any>()
    
    var isWalletExist: Bool {
        get {
            return !self.walletEntity.address.isEmpty
        }
    }
    //    var web3 : web3? {
    //        let w = Web3.new(URL(string: "http://192.168.0.129:8545")!)
    //        return w
    //    }
    
    
    lazy var web3: web3? = {
        let w = Web3.new(URL(string: "http://192.168.0.129:8545")!)
        guard let keystoreData = WalletManager.manager.getKeystoreData() else {return nil}
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreData) else {return nil}
        
        let keystoreManager = KeystoreManager.init([keystoreV3])
        w?.addKeystoreManager(keystoreManager)
        return w
    }()
    
    override init() {
        super.init()
        setUserInfo()
    }
    /// 用户数据初始化
    func setUserInfo() {
        print("用户地址：\(userPath)")
        if
            WalletDB.shareInstance.manager.isExist == true,
            let data = WalletDB.shareInstance.getDefaultWallet(),
            data.isEmpty == false {
            
            self.walletDict = data
            self.walletEntity.setValuesForKeys(data)
            //let _ = WalletDB.shareInstance.setDefaultWallet(key: self.userEntity.address!)
            print(data)
        }
    }
    
    func switchWallet(dict:Dictionary<String, Any>) -> Bool {
        
        guard let address = dict["address"] as? String else { return false }
        self.walletEntity.setValuesForKeys(dict)
        self.walletDict = dict
        return WalletDB.shareInstance.setDefaultWallet(key: address)
    }
    /// 删除用户信息
    func removeAccound() {
        self.walletEntity = WalletEntity()
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: userPath)
    }
    func getKeystoreData() -> Data?{
        let pathUrl = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/keystore1.json")
        
        guard
            let data = try? Data(contentsOf: pathUrl) else {
                print("该地址不存在keystore文件：\(pathUrl)")
                return nil
        }
        
        guard
            let result = try? JSONSerialization.jsonObject(with: data, options: []),
            var dict = result as? [String : Any],
            let address = dict["address"] as? String
            else {
                print("该地址不存在用户信息：\(pathUrl)")
                return nil
        }
        print("keystore地址：\(pathUrl)")
        if address.hasPrefix("0x"){
            print("address：\(address)")
            return data
        } else {
            let newAddress = "0x" + address
            dict["address"] = newAddress
            print("newAddress：\(newAddress)")
            return try? JSONSerialization.data(withJSONObject: dict, options: [])
        }
        //self.walletDict = dict as! [String : Any]
        
        //        return data
    }
    func getNormalKeystoreData() -> Data?{
        let pathUrl = URL(fileURLWithPath: NSHomeDirectory() + "/Documents" + "/keystore"+"/key.json")
        
        guard
            let data = try? Data(contentsOf: pathUrl) else {
                print("该地址不存在keystore文件：\(pathUrl)")
                return nil
        }
        print("keystore地址：\(pathUrl)")
        return data
    }
    func getBip32KeystoreData() -> Data?{
        let pathUrl = URL(fileURLWithPath: NSHomeDirectory() + "/Documents" + "/bip32_keystore"+"/key.json")
        
        guard
            let data = try? Data(contentsOf: pathUrl) else {
                print("该地址不存在keystore文件：\(pathUrl)")
                return nil
        }
        print("keystore地址：\(pathUrl)")
        return data
    }
}

private let dbName = "WalletDB"

class WalletDB: BaseDB {
    
    static let shareInstance = WalletDB(name: dbName)
    
    
    override init(name: String) {
        super.init(name: name)
    }
    
    func appendWallet(data:Dictionary<String,Any>, key address:String) -> Bool {
        let cs = "address = '\(address)'"
        if let dataArray = self.selectData(keys: [], condition: [cs]), dataArray.isEmpty == true {
            return self.insertData(data: data)
        } else {
            return false
        }
    }
    func deleteWallet(key address:String) -> Bool {
        let cs = "address = '\(address)'"
        return self.deleteData(condition: [cs])
    }
    func getDefaultWallet() -> Dictionary<String,Any>? {
        if self.manager.isExist == false {
            return nil
        }
        if
            let data = self.selectData(keys: [], condition: ["isDefault = \(1)"]),
            data.isEmpty == false,
            let dict = data[0] as? Dictionary<String,Any>{
            return dict
        }
        if
            let data = self.selectData(),
            data.isEmpty == false,
            let dict = data[0] as? Dictionary<String,Any> {
            
            return dict
        }
        return nil
    }
    func setDefaultWallet(key address:String) -> Bool {
        let cs = "address = '\(address)'"
        //先重置
        let isSuccess1 = self.updateData(keyValues: ["isDefault":0], condition: [])
        //再设置
        if isSuccess1 {
            let isSuccess2 = self.updateData(keyValues: ["isDefault":1], condition: [cs])
            if isSuccess2 {
                //userModel.UserName = name
            }
            return isSuccess2
        }
        return false
    }

}
extension WalletDB {
    /// 修改钱包名称
    ///
    /// - Parameter name: 钱包名称
    /// - Returns: 返回结果
    func updateWalletName(_ name: String) -> Bool{
        
        let cs = "address = '\(WalletManager.manager.walletEntity.address)'"
        let isSuccess = self.updateData(keyValues: ["name": name], condition: [cs])
        if isSuccess {
            var dict = WalletManager.manager.walletDict
            dict["name"] = name
            WalletManager.manager.walletEntity.name = name
        }
        return isSuccess
    }
    /// 修改密码提示
    ///
    /// - Parameter name: 钱包名称
    /// - Returns: 返回结果
    func updateWalletNotice(_ notice: String) {
        
        
        let cs = "address = '\(WalletManager.manager.walletEntity.address)'"
        let isSuccess = self.updateData(keyValues: ["notice": notice], condition: [cs])
        if isSuccess {
            var dict = WalletManager.manager.walletDict
            dict["notice"] = notice
            WalletManager.manager.walletEntity.notice = notice
        }
    }
   
}
