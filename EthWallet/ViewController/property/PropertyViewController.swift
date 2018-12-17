//
//  PropertyViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/12/15.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift
import BigInt
import JXFoundation

class PropertyViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    
    
    var propertyEntity = PropertyEntity()
    
    var vm : Web3VM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱包"
        
        self.tableView.register(UINib.init(nibName: "WalletHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHead")
        self.tableView.register(UINib.init(nibName: "PropertyViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        self.tableView.estimatedRowHeight = 70
        //        self.tableView.rowHeight = UITableViewAutomaticDimension
        //        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    
    override func requestData() {
        
//        self.showMBProgressHUD()
//        self.count = 2
//        self.fetchData(count: count) {
//            if self.count == 0 {
//                self.hideMBProgressHUD()
//            }
//            self.tableView?.reloadData()
//        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierHead", for: indexPath) as! WalletHeadCell
            cell.accessoryType = .none
            
            cell.totalNumberLabel.text = "≈￥\(propertyEntity.CNY)"
            cell.addressLabel.text = propertyEntity.tokenAddress
            cell.nameLabel.text = propertyEntity.shortName
            cell.codeBlock = {
                print(WalletManager.shared.entity.address)
            }
            cell.addBlock = {
                let vc = AddPropertyController()
                vc.finishBlock = { array in
                    print("entity = ",array)
                    self.tableView?.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! PropertyViewCell
            //let entity = self.propertyArray[indexPath.row - 1]
//
//            cell.coinImagView.image = UIImage(named: entity.image!)
//            cell.coinNameLabel.text = entity.shortName
//            //            cell.coinLongNameLabel.text = entity.wholeName
//            let ether = EthUnit.weiToEther(wei: EthUnit.Wei(entity.coinNum))
//            //            cell.coinNumberLabel.text = "\(EthUnit.decimalNumberHandler(ether))"
//            //cell.coinNumberLabel.text = String.init(format: "%.4f", ether as CVarArg) //"\(ether)"
//            cell.worthLabel.text = "≈￥" + entity.CNY
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
