//
//  PropertyViewCell.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/2.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PropertyViewCell: UITableViewCell {

    @IBOutlet weak var coinImagView: UIImageView!
    @IBOutlet weak var coinNameLabel: UILabel!{
        didSet{
            coinNameLabel.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var coinLongNameLabel: UILabel!{
        didSet{
            coinLongNameLabel.textColor = JXMainText50Color
        }
    }
    @IBOutlet weak var coinNumberLabel: UILabel!{
        didSet{
            coinNumberLabel.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var worthLabel: UILabel!{
        didSet{
            worthLabel.textColor = JXMainText50Color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
