//
//  AddPropertyCell.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class AddPropertyCell: UITableViewCell {

    @IBOutlet weak var coinImageView: UIImageView!{
        didSet{
            coinImageView.layer.cornerRadius = 20
            coinImageView.layer.masksToBounds = true
            coinImageView.backgroundColor = UIColor.randomColor
        }
    }
    @IBOutlet weak var coinNameIcon: UILabel!{
        didSet{
            coinNameIcon.textColor = JXFfffffColor
        }
    }
    
    @IBOutlet weak var coinShortNameLabel: UILabel!{
        didSet{
            coinShortNameLabel.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var coinWholeNameLabel: UILabel!{
        didSet{
            coinWholeNameLabel.text = ""
            coinWholeNameLabel.textColor = JXMainText50Color
        }
    }
    @IBOutlet weak var coinAddressLabel: UILabel!{
        didSet{
            coinAddressLabel.textColor = JXMainText50Color
        }
    }
    @IBOutlet weak var addButton: UIButton!
    
    var clickBlock : (()->())?
    
    @IBAction func addProperty(_ sender: Any) {
        let button = sender as! UIButton
        button.isEnabled = false
        button.setTitle("已添加", for: .normal)
        
        if let block = clickBlock {
            block()
        }
    }
    var entity: TokenEntity? {
        didSet {
//            if (entity?.isAdded)! {
//                self.addButton.setTitle("已添加", for: .normal)
//                self.addButton.isEnabled = false
//            } else {
                self.addButton.setTitle("添加", for: .normal)
                self.addButton.isEnabled = true
//            }
            self.coinShortNameLabel.text = entity?.symbol
            self.coinWholeNameLabel.text = entity?.symbol
            self.coinAddressLabel.text = entity?.address
            //self.coinImageView.backgroundColor = UIColor.green
            self.coinNameIcon.text = String(entity?.symbol?.first ?? "A")
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
