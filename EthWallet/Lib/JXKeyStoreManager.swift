//
//  JXKeyStoreManager.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/12/17.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift

//class JXKeyStoreManager: NSObject {
//
//    init(keystoreData:Data) {
//        super.init()
//
//        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreData) else {return}
//        let keystoreManager = KeystoreManager.init([keystoreV3])
//        self.web3.addKeystoreManager(keystoreManager)
//        self.keystore = keystoreV3
//    }
//    init(keystoreJsonStr:String) {
//        super.init()
//        let keystoreJsonStr1 = String.convertKeystore(keystoreJsonStr)
//
//        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreJsonStr1) else {return}
//        let keystoreManager = KeystoreManager.init([keystoreV3])
//        self.web3.addKeystoreManager(keystoreManager)
//        self.keystore = keystoreV3
//    }
//    init(keystoreBase64Str:String) {
//        super.init()
//        guard
//            keystoreBase64Str.isEmpty == false,
//
//            let keystoreData = Data.init(base64Encoded: keystoreBase64Str, options: .ignoreUnknownCharacters),
//            let keystoreStr = String.init(data: keystoreData, encoding: .utf8) else {
//                return
//        }
//        let keystoreJsonStr = String.convertKeystore(keystoreStr)
//
//        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreJsonStr) else {return}
//        let keystoreManager = KeystoreManager.init([keystoreV3])
//        self.web3.addKeystoreManager(keystoreManager)
//        self.keystore = keystoreV3
//    }
//
//
//    func getKeystoreData() -> Data?{
//        let pathUrl = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/keystore1.json")
//
//        guard
//            let data = try? Data(contentsOf: pathUrl) else {
//                print("该地址不存在keystore文件：\(pathUrl)")
//                return nil
//        }
//
//        guard
//            let result = try? JSONSerialization.jsonObject(with: data, options: []),
//            var dict = result as? [String : Any],
//            let address = dict["address"] as? String
//            else {
//                print("该地址不存在用户信息：\(pathUrl)")
//                return nil
//        }
//        print("keystore地址：\(pathUrl)")
//        if address.hasPrefix("0x"){
//            print("getKeystoreData func","address：\(address)")
//            return data
//        } else {
//            let newAddress = "0x" + address
//            dict["address"] = newAddress
//            print("newAddress：\(newAddress)")
//            return try? JSONSerialization.data(withJSONObject: dict, options: [])
//        }
//    }
//}
