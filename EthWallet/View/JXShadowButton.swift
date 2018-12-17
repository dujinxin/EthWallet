//
//  JXShadowButton.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/12/16.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class JXShadowButton: UIButton {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    func setup() {
        setTitleColor(JXFfffffColor, for: .normal)
        backgroundColor = JXMainColor
        layer.cornerRadius = 2
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowColor = JX10101aShadowColor.cgColor
    }
}
