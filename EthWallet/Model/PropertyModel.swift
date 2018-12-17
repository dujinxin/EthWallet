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
