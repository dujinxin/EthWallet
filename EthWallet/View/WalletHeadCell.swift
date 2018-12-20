//
//  WalletHeadCell.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/1.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class WalletHeadCell: UITableViewCell {

    @IBOutlet weak var totalNumberLabel: UILabel!{
        didSet{
            totalNumberLabel.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var infoLabel: UILabel!{
        didSet{
            infoLabel.textColor = JXMainText50Color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
