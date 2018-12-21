//
//  Web3VM.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/25.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation
import web3swift
import JX_AFNetworking

//keystoreV3
/*
 {
    "version":3,
    "id":" 33f582c4-0432-4ae7-8416-476dec347135",
    "crypto":{
      "ciphertext":"d6710f77bf6327b7bfdaeec3c9ffa94b1077c45e01170c6e6f419cc5bff68aa0",
      "cipherparams":{"iv":"43f7f8880519540d68fd296b1d7ab529"},
      "kdf":"scrypt",
      "kdfparams":{
         "r":6,
         "p":1,
         "n":4096,
         "dklen":32,
         "salt":"4aaf93ff3e4e8215f7b435ff06cac4b3e987f688fea7ea72c7b9b31eab56dab0"
       },
      "mac":"e89d42e0c8404659775a09d4121ea714501a39c8b45166c47e6a2c61d3f8065c",
      "cipher":"aes-128-cbc"
    },
    "address":"0xe156adcd604330357595e5c8d38dc7664b7c1314"
 }
 */
//BIPKeystore32
/*
 {
   "isHDWallet":true,
   "id":"f233650b-7d78-40af-a46a-fe0e620d48b9",
   "crypto":{
 "ciphertext":"ff58c452f08d4b248a29f4320210680f213e8536aad7e53cb84bc4c6561d9a236424d42e7b792c2e306d0a7c315e52f19e664107b1f5ef762b95ec49171645a224f5c5280ac6d38646979051c651799285d27aa35bcf44b38b1dd160ee76c04c",
     "cipherparams":{"iv":"eece6c40fcd7e72b90e25a7e529e635e"},
     "kdf":"scrypt",
     "kdfparams":{
         "r":6,
         "p":1,
         "n":4096,
         "dklen":32,
         "salt":"5b9827647b8646054b38e4935063b7b42a5984ff67e526a27eb13f1541794222"},
         "mac":"b3e2f451023a02768976be52be5135e1c08e31a863d9a7ee16b36dfbd2bfe6af",
         "cipher":"aes-128-cbc"
     },
     "pathToAddress":{
         "m\/44'\/60'\/0'\/0\/0":"0xC9492530a4eA23AF15BbB479D57619C7699391cB"
     },
     "rootPath":"m\/44'\/60'\/0'\/0",
     "version":3
 }
 */
class Web3VM : BaseViewModel{
    
    //https://mainnet.infura.io/0a8aa5d2db674577bf61aa4be1e38472
    //https://mainnet.infura.io/v3/e91a846b69f14dc1a87fbd19a52955ed
    
    //var web3 = Web3.init(infura: .mainnet) //主网
    var web3 = Web3.init(infura: .mainnet, accessToken: "0a8aa5d2db674577bf61aa4be1e38472") //主网测试token
    //var web3 = Web3.init(infura: .mainnet, accessToken: "e91a846b69f14dc1a87fbd19a52955ed") //主网测试token
    
    //var web3 = Web3.new(URL(string: "http://192.168.0.129:8545")!)! //自己搭建的
    
    init(bIP32KeystoreJsonStr: String) {
        super.init()
        //let keystoreJsonStr1 = String.convertKeystore(keystoreJsonStr)
        guard JSONSerialization.isValidJSONObject(bIP32KeystoreJsonStr) == true else {
            fatalError("keystore is not Json string")
        }
//        guard
//            let result = try? JSONSerialization.data(withJSONObject: bIP32KeystoreJsonStr, options: []),
//            let jsonStr = String.init(data: result, encoding: .utf8) else{
//                return
//        }
        guard let keystore = BIP32Keystore.init(bIP32KeystoreJsonStr) else {return}
        let keystoreManager = KeystoreManager.init([keystore])
        self.web3.addKeystoreManager(keystoreManager)

    }
    init(bIP32KeystoreJsonData: String) {
        super.init()
        
        guard let keystore = BIP32Keystore.init(bIP32KeystoreJsonData) else {return}
        let keystoreManager = KeystoreManager.init([keystore])
        self.web3.addKeystoreManager(keystoreManager)
       
    }
    init(bIP32KeystoreBase64Str: String) {
        super.init()
        guard
            bIP32KeystoreBase64Str.isEmpty == false,
            
            let keystoreData = Data.init(base64Encoded: bIP32KeystoreBase64Str, options: .ignoreUnknownCharacters)
            //,let keystoreStr = String.init(data: keystoreData, encoding: .utf8)
            else {
                return
        }
        //let keystoreJsonStr = String.convertKeystore(keystoreStr)
        
        guard let keystore = BIP32Keystore.init(keystoreData) else {return}
        let keystoreManager = KeystoreManager.init([keystore])
        self.web3.addKeystoreManager(keystoreManager)
    }
    //MARK:EthereumKeystoreV3
    init(keystoreData: Data) {
        super.init()
        
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreData) else {return}
        let keystoreManager = KeystoreManager.init([keystoreV3])
        self.web3.addKeystoreManager(keystoreManager)

    }
    init(keystoreJsonStr: String) {
        super.init()
        let keystoreJsonStr1 = String.convertKeystore(keystoreJsonStr)
        
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreJsonStr1) else {return}
        let keystoreManager = KeystoreManager.init([keystoreV3])
        self.web3.addKeystoreManager(keystoreManager)
    }
    init(keystoreBase64Str: String) {
        super.init()
        guard
            keystoreBase64Str.isEmpty == false,
            
            let keystoreData = Data.init(base64Encoded: keystoreBase64Str, options: .ignoreUnknownCharacters),
            let keystoreStr = String.init(data: keystoreData, encoding: .utf8) else {
                return
        }
        let keystoreJsonStr = String.convertKeystore(keystoreStr)
        
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreJsonStr) else {return}
        let keystoreManager = KeystoreManager.init([keystoreV3])
        self.web3.addKeystoreManager(keystoreManager)
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
            print("getKeystoreData func","address：\(address)")
            return data
        } else {
            let newAddress = "0x" + address
            dict["address"] = newAddress
            print("newAddress：\(newAddress)")
            return try? JSONSerialization.data(withJSONObject: dict, options: [])
        }
    }
    
    
    /// 获取ETH当前人民币，美元价格
    /*
     向授权服务地址https://api.coinmarketcap.com/v2/ticker/1027/?convert=CNY发送请求
     "data": {
         "id": 1027,
         "name": "Ethereum",
         "symbol": "ETH",
         "website_slug": "ethereum",
         "rank": 2,
         "circulating_supply": 101045963.0,
         "total_supply": 101045963.0,
         "max_supply": null,
         "quotes": {
             "USD": {
                 "price": 418.939268684,
                 "volume_24h": 1897124199.14193,
                 "market_cap": 42332121842.0,
                 "percent_change_1h": 0.27,
                 "percent_change_24h": -7.41,
                 "percent_change_7d": -12.02
             },
             "CNY": {
                 "price": 2856.3978967454,
                 "volume_24h": 12934909609.490934,
                 "market_cap": 288627476185.0,
                 "percent_change_1h": 0.27,
                 "percent_change_24h": -7.41,
                 "percent_change_7d": -12.02
             }
         },
         "last_updated": 1533096513
     },
     "metadata": {
         "timestamp": 1533096107,
         "error": null
     }
     */
    ///
    /// - Parameter completion: 回调
    static func getETHPrise(completion: @escaping ((_ data: Double, _ msg: String, _ isSuccess: Bool)->())){
        let coinMarketCapUrl = "https://api.coinmarketcap.com/v2/ticker/1027/?convert=CNY"
        Web3Request.request(tag: 0, method: .get, url: coinMarketCapUrl, param: [:], success: { (data, message) in
            guard
                let mdict = data as? Dictionary<String, Any>,
                let dict = mdict["data"] as? Dictionary<String, Any>,
                let quotes = dict["quotes"] as? Dictionary<String, Any>,
                let cny = quotes["CNY"] as? Dictionary<String, Any>,
                let price = cny["price"] as? Double
                else{
                    completion(0,message,false)
                    return
            }
            completion(price,message,true)
            
        }, failure: { (message, code) in
            completion(0,message,false)
        })
    }
    
    static func getEthTokens(completion: @escaping ((_ data: Array<TokenEntity>, _ msg: String, _ isSuccess: Bool)->())){
        JXNetworkManager.manager.afmanager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html","application/json","text/json","image/jpeg","text/plain") as? Set<String>
        
        let ethTokenUrl = "https://raw.githubusercontent.com/kvhnuke/etherwallet/mercury/app/scripts/tokens/ethTokens.json"
        Web3Request.request(tag: 0, method: .get, url: ethTokenUrl, param: [:], success: { (data, message) in
            guard
                let array = data as? Array<Dictionary<String, Any>>
                else{
                    completion([],message,false)
                    return
            }
            var list = Array<TokenEntity>()
            array.forEach({ (dict) in
                let entity = TokenEntity()
                entity.setValuesForKeys(dict)
                list.append(entity)
            })
            completion(list,message,true)
            
        }, failure: { (message, code) in
            completion([],message,false)
        })
    }
    
    //http://api.etherscan.io/api?module=account&action=txlist&address=0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a&startblock=0&endblock=99999999&sort=asc&apikey=YourApiKeyToken
    //https://api.etherscan.io/api?module=account&action=txlist&address=0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a&startblock=0&endblock=99999999&page=1&offset=10&sort=asc&apikey=YourApiKeyToken
    /**
     [{
         blockHash = 0x4a5b042b55a4209ea5b82bc040272a497ace4d2b047bb24c14adb5816d6a0fa7;
         blockNumber = 6096374;
         confirmations = 823436;
         contractAddress = "";
         cumulativeGasUsed = 7524531;
         from = 0xd9ab35f204b40a355763ba23a917dc7883f1084f;
         gas = 21000;
         gasPrice = 2000000000;
         gasUsed = 21000;
         hash = 0xe16156dba1168f2dc88f4808ddff56e10a605ff49a99eefbbed58b564e2604a6;
         input = 0x;
         isError = 0;
         nonce = 8;
         timeStamp = 1533526043;
         to = 0xe156adcd604330357595e5c8d38dc7664b7c1314;
         transactionIndex = 227;
         "txreceipt_status" = 1;
         value = 100000000000000;
     }]
     */
    static var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return f
    }()
   
    /// 查询交易记录
    ///
    /// - Parameters:
    ///   - address: 钱包地址
    ///   - type: 类型，tokentx: 合约, txlist: eth
    ///   - page: 分页
    ///   - offset: 数量
    ///   - completion: 回调
    static func getTxlist(address: String, type: Type = .eth, page: Int = 1, offset: Int = 20, completion: @escaping ((_ data: Array<TxEntity>, _ msg: String, _ isSuccess: Bool)->())){
        
        let actionStr = (type == .eth) ? "txlist" : "tokentx"
        let ethTokenUrl = "http://api.etherscan.io/api?module=account&action=\(actionStr)&address=\(address)&startblock=0&endblock=99999999$page=\(page)&offset=\(offset)&sort=asc&apikey=\("VQTHS2DB1GKV9ZRQA2SUR16TGUH5CSQ44W")"
        
        
        Web3Request.request(tag: 0, method: .get, url: ethTokenUrl, param: [:], success: { (data, message) in
            guard
                let result = data as? Dictionary<String, Any>,
                let array = result["result"] as? Array<Dictionary<String, Any>>
                else {
                    completion([],message,false)
                    return
            }
            var list = Array<TxEntity>()
            array.forEach({ (dict) in
                let entity = TxEntity()
                entity.setValuesForKeys(dict)
                entity.Hash = dict["hash"] as? String
                let d = Date.init(timeIntervalSince1970: entity.timeStamp)

                entity.timeStampStr = self.formatter.string(from: d)
                list.append(entity)
            })
            completion(list,message,true)
            
        }, failure: { (message, code) in
            completion([],message,false)
        })
    }
}
class Web3Request: JXRequest {
    
    override func handleResponseResult(result: Any?) {
        var msg = "请求失败"
        var netCode : JXNetworkError = .kResponseUnknow
        var data : Any? = nil
        var isSuccess : Bool = false
        
        print("requestParam = \(String(describing: param))")
        print("requestUrl = \(String(describing: requestUrl))")
        
        if result is Dictionary<String, Any> {
            
            let jsonDict = result as! Dictionary<String, Any>
            print("responseData = \(jsonDict)")
            isSuccess = true
            data = result
        }else if result is Array<Any>{
            print("Array")
            isSuccess = true
            data = result
        }else if result is String{
            print("String")
            isSuccess = true
            data = result
        }else if result is Error{
            print("Error")
            guard let error = result as? NSError,
                let code = JXNetworkError(rawValue: error.code)
                else {
                    handleResponseResult(result: data, message: "Error", code: .kResponseUnknow, isSuccess: isSuccess)
                    return
            }
            netCode = code
            
            switch code {
            case .kRequestErrorCannotConnectToHost,
                 .kRequestErrorCannotFindHost,
                 .kRequestErrorNotConnectedToInternet,
                 .kRequestErrorNetworkConnectionLost,
                 .kRequestErrorUnknown:
                msg = kRequestNotConnectedDomain;
                break;
            case .kRequestErrorTimedOut:
                msg = kRequestTimeOutDomain;
                break;
            case .kRequestErrorResourceUnavailable:
                msg = kRequestResourceUnavailableDomain;
                break;
            case .kResponseDataError:
                msg = kRequestResourceDataErrorDomain;
                break;
            default:
                msg = error.localizedDescription;
                break;
            }
            
        }else{
            print("未知数据类型")
        }
        handleResponseResult(result: data, message: msg, code: netCode, isSuccess: isSuccess)
    }
    
    override func handleResponseResult(result: Any?, message: String, code: JXNetworkError, isSuccess: Bool) {
        
        guard
            let success = self.success,
            let failure = self.failure
            else {
                return
        }
        
        if isSuccess {
            success(result,message)
        }else{
            failure(message,code)
        }
    }
}
extension String {
    
    static func convertKeystore(_ keystoreStr: String, addPrefixStr str: String = "0x") -> String {
        
        guard
            let data = keystoreStr.data(using: .utf8),
            let result = try? JSONSerialization.jsonObject(with: data, options: []),
            var dict = result as? [String : Any],
            let address = dict["address"] as? String
            else {
                fatalError("Not format keystoreData!")
        }
        if address.hasPrefix(str){
            print("convertKeystore func","address：\(address)")
            return keystoreStr
        } else {
            let newAddress = str + address
            dict["address"] = newAddress
            print("newAddress：\(newAddress)")
            guard
                let newData = try? JSONSerialization.data(withJSONObject: dict, options: []),
                let newKeystoreStr = String.init(data: newData, encoding: .utf8) else {
                    fatalError("convertKeystore error")
            }
            return newKeystoreStr
        }
    }
    static func convertBase64Str(_ str: String) -> String {
        guard
            let keystoreData = Data.init(base64Encoded: str, options: .ignoreUnknownCharacters),
            let keystoreStr = String.init(data: keystoreData, encoding: .utf8) else {
                fatalError("convertString error")
        }
        return keystoreStr
    }
}
