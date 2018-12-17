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

    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            topConstraint.constant = kStatusBarHeight
        }
    }
    @IBOutlet weak var coinImageView: UIImageView!{
        didSet{
            coinImageView.isUserInteractionEnabled = true
            coinImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(walletDetail)))
        }
    }
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.textColor = JXFfffffColor
        }
    }
    
    @IBOutlet weak var settingButton: UIButton!{
        didSet{
            
            settingButton.tintColor = JXFfffffColor
            settingButton.setImage(UIImage(named: "iconGear")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    @IBOutlet weak var scanButton: UIButton!{
        didSet{
            scanButton.tintColor = JXFfffffColor
            scanButton.setImage(UIImage(named: "scanIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    @IBOutlet weak var addressLabel: UILabel!{
        didSet{
            addressLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var codeButton: UIButton!{
        didSet{
            codeButton.tintColor = JXFfffffColor
            codeButton.setImage(UIImage(named: "icon-qc")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @IBOutlet weak var totalNumberLabel: UILabel!{
        didSet{
            totalNumberLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var infoLabel: UILabel!{
        didSet{
            infoLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            addButton.tintColor = JXFfffffColor
        }
    }
    var settingBlock : (()->())?
    var scanBlock : (()->())?
    var detailBlock : (()->())?
    var addBlock : (()->())?
    var codeBlock : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = JXMainColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func setting(_ sender: Any) {
        if let block = settingBlock {
            block()
        }
    }
    @IBAction func scan(_ sender: Any) {
        if let block = scanBlock {
            block()
        }
    }
    @IBAction func codeAddress(_ sender: Any) {
        if let block = codeBlock {
            block()
        }
    }
    @IBAction func addProperty(_ sender: Any) {
        if let block = addBlock {
            block()
        }
    }
    @objc func walletDetail() {
        if let block = detailBlock {
            block()
        }
    }
}
