//
//  PropertyModel.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import BigInt

class PropertyModel: NSObject {

}

class PropertyEntity: BaseModel {
    
    @objc var shortName : String?
    @objc var wholeName : String?
    @objc var tokenAddress   : String = ""
    @objc var isAdded   : Bool = false
    @objc var image     : String?
    
    var coinNum   : BigUInt = 0
    @objc var prise     : Double = 0
    @objc var CNY       : String = "0"
    
}
class CoinEntity: BaseModel {
    var name : String?
    var coinNum   : BigUInt = 0
    var CNY       : String = ""
}


class TokenEntity: BaseModel {
    @objc var address : String?
    @objc var symbol : String?
    @objc var type   : String = ""
    @objc var decimal: Int = 18
}

class TxEntity: BaseModel {
    
    @objc var blockHash: String?
    @objc var blockNumber: Int = 0
    @objc var confirmations: Double = 0
    @objc var contractAddress: String?
    @objc var cumulativeGasUsed: Double = 0
    @objc var from: String?
    @objc var gas: Int = 0
    @objc var gasPrice: Double = 0
    @objc var gasUsed: Int = 0
    @objc var Hash: String?
    @objc var input: String?
    @objc var isError: Int = 0
    @objc var nonce: Int = 0
    @objc var timeStamp: Double = 0
    @objc var to: String?
    @objc var transactionIndex: Int = 0
    @objc var txreceipt_status: Int = 0
    @objc var value: String?
    
    @objc var timeStampStr: String = ""
}


