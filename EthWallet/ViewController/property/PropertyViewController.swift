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
import MJRefresh

class PropertyViewController: MyBaseViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            topConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeButton: JXShadowButton!
    @IBOutlet weak var transferButton: JXShadowButton!
    
    var currentPage: Int = 1
    var tradeList = [TxEntity]()
    
    var type: Type = .eth
    var propertyEntity = PropertyEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = propertyEntity.shortName
        
        self.tableView.register(UINib.init(nibName: "WalletHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHead")
        self.tableView.register(UINib.init(nibName: "PropertyViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        self.tableView.estimatedRowHeight = 70
        self.tableView.separatorStyle = .none
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentPage = 1
            self.requestPage(self.currentPage)
        })
        self.tableView.mj_footer = MJRefreshBackFooter(refreshingBlock: {
            self.currentPage += 1
            self.requestPage(self.currentPage)
        })
        self.tableView.mj_header.beginRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        
        case "transfer":
            if let vc = segue.destination as? TransferViewController, let entity = sender as? PropertyEntity {
                vc.entity = entity
            }
            //        case "receipt":
            //            if let vc = segue.destination as? ReceiptViewController, let entity = sender as? PropertyEntity {
            //                //vc.entity = entity
        //            }
       
        default:
            print("")
        }
    }

    func requestPage(_ page: Int) {
        self.showMBProgressHUD()
        Web3VM.getTxlist(address: WalletManager.shared.entity.address, type: self.type, page: page, offset: 20) { (array, msg, isSuc) in
            self.hideMBProgressHUD()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if page == 1 {
                self.tradeList.removeAll()
                self.tradeList = array
            } else {
                self.tradeList += array
            }
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tradeList.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierHead", for: indexPath) as! WalletHeadCell
       
            let ether = EthUnit.weiToEther(wei: EthUnit.Wei(propertyEntity.coinNum))
            cell.totalNumberLabel.text = "\(EthUnit.decimalNumberHandler(ether))"
            cell.infoLabel.text = "≈￥\(propertyEntity.CNY)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! PropertyViewCell
            
            let entity = self.tradeList[indexPath.row - 1]
            cell.coinNameLabel.text = entity.from
            cell.coinLongNameLabel.text = entity.timeStampStr//Date.calculateTimeIntervalFrom(entity.timeStamp)
            cell.coinNumberLabel.text = "数量"
            
            if let fromAddress = entity.from, fromAddress.lowercased() == WalletManager.shared.entity.address.lowercased() {
                cell.coinImagView.image = UIImage(named: "arrowDown")
            } else {
                cell.coinImagView.image = UIImage(named: "arrowUp")
            }
            let bigUInt = BigUInt.init(entity.value ?? "0") ?? 0
            let ether = EthUnit.weiToEther(wei: EthUnit.Wei(bigUInt))
            cell.worthLabel.text = "\(EthUnit.decimalNumberHandler(ether))"
            
            if entity.from?.lowercased() == WalletManager.shared.entity.address.lowercased() {
                cell.worthLabel.text = "-\(EthUnit.decimalNumberHandler(ether))"
            } else {
                cell.worthLabel.text = "+\(EthUnit.decimalNumberHandler(ether))"
            }

            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
