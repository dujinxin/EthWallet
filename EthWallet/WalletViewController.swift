//
//  WalletViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/5/27.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift
import BigInt
import JXFoundation

class WalletViewController: JXTableViewController {
    @IBOutlet var defaultBackView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var createButton: JXShadowButton!
    @IBOutlet weak var importButton: UIButton!
    
    
    var count : Int = 0
    var propertyArray = Array<PropertyEntity>()
    
    var prise : Double = 0
    var totalWorth : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱包"
        
        self.tableView?.register(UINib.init(nibName: "WalletHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHead")
        self.tableView?.register(UINib.init(nibName: "PropertyViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        self.tableView?.estimatedRowHeight = 70
        //        self.tableView.rowHeight = UITableViewAutomaticDimension
        //        self.tableView.isScrollEnabled = false
        self.tableView?.separatorStyle = .none
        
        self.resetMainView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(walletChange(notify:)), name: NSNotification.Name(rawValue: "NotificationwalletChange"), object: nil)
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
        self.topConstraint.constant = kNavStatusHeight + 84
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
//        case "walletAddress":
//            if let vc = segue.destination as? WalletAddressController {
//                print(sender ?? "")
//            }
        case "transfer":
            if let vc = segue.destination as? TransferViewController, let entity = sender as? PropertyEntity {
                vc.entity = entity
            }
//        case "receipt":
//            if let vc = segue.destination as? ReceiptViewController, let entity = sender as? PropertyEntity {
//                //vc.entity = entity
//            }
        case "walletDetail":
            if let vc = segue.destination as? WalletDetailController {
                vc.dict = WalletManager.shared.walletDict
            }
        case "property":
            if let vc = segue.destination as? PropertyViewController, let entity = sender as? PropertyEntity {
                vc.propertyEntity = entity
            }
        default:
            print("")
        }
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    func resetMainView() {
        if WalletManager.shared.isWalletExist == true {
            self.title = WalletManager.shared.entity.name
            self.defaultBackView.isHidden = true
            self.tableView?.isHidden = false
            
            self.showMBProgressHUD()
            self.requestData()
            
        } else {
            self.title = "钱包"
            self.defaultBackView.isHidden = false
            self.tableView?.isHidden = true
        }
    }
    @objc func walletChange(notify: Notification) {
        self.requestData()
    }
    override func requestData() {
        
        //self.showMBProgressHUD()
        self.count = 2
        self.fetchData(count: count) {
            if self.count == 0 {
                self.hideMBProgressHUD()
            }
            self.tableView?.reloadData()
        }
    }
    func fetchData(count: Int, completion: @escaping (()->())) {
        self.propertyArray.removeAll()
        self.totalWorth = 0
        for i in 0..<count {
            self.dataInit(index: i, total: count, completion: completion)
        }
    }
    func dataInit(index: Int, total: Int, completion: @escaping (()->())) {
        let entity = PropertyEntity()
        
        let walletAddress = Address(WalletManager.shared.entity.address)
        
        let group = DispatchGroup()
        
        group.enter()
        //1
        if index == 0 { //eth
            DispatchQueue.global().async {
                let balanceResult = try? WalletManager.shared.vm.web3.eth.getBalance(address: walletAddress)
                
                print("balance = ",balanceResult ?? 0)
                DispatchQueue.main.async {
                    entity.shortName = "ETH"
                    entity.wholeName = "Ethereum"
                    entity.tokenAddress = "0x0000000000000000000000000000000000000000"
                    entity.image = "eth"
                    entity.coinNum = balanceResult ?? 0
                }
                group.leave()
                print("\(index)-\(index)")
            }
        } else { // token
            let contractAddress = Address("0x8553de7f3ce4993adbf02b0d676e4be4c5333398") // BKX token on Ethereum mainnet

            DispatchQueue.global().async {
                guard
                    let contract = try? WalletManager.shared.vm.web3.contract(Web3.Utils.erc20ABI, at: contractAddress), // utilize precompiled ERC20 ABI for your concenience
                    let bkxBalanceResult = try? contract.method("balanceOf", parameters: [walletAddress] as [AnyObject], options: Web3Options.default).call(options: nil) else { return } // encode parameters for transaction
                guard let bal = bkxBalanceResult["0"] as? BigUInt else {return} // bkxBalance is [String: Any], and parameters are enumerated as "0", "1", etc in order of being returned. If returned parameter has a name in ABI, it is also duplicated
                print(bkxBalanceResult)
                print("BKX token balance = " + String(bal))
                
                DispatchQueue.main.async {
                    
                    entity.shortName = "IPE"
                    entity.wholeName = "Ipxe"
                    //0x8553de7f3ce4993adbf02b0d676e4be4c5333398
                    entity.tokenAddress = "0x8553de7f3ce4993adbf02b0d676e4be4c5333398"
                    entity.image = "IPE"
                    entity.coinNum = bal
                    entity.prise = 1
                    
                }
                print("\(index)-\(index)")
                group.leave()
            }
        }
        
        //2
        if index == 0 {
            group.enter()
            //let vm = Web3VM()
            Web3VM.getETHPrise { (prise, msg, isSuc) in
                print(prise)
                entity.prise = prise
                
                self.prise = prise
                group.leave()
                print("\(index)-\(index + 1)")
            }
        } else {
            //token暂时不提供价格查询，以1元为基准计算
            print("\(index)-\(index + 1)")
        }
        
        
        //3
        group.notify(queue: DispatchQueue.main) {
            print("\(index)-\(index + 2)")
            let ether = EthUnit.weiToEther(wei: EthUnit.Wei(entity.coinNum))
            let priseDecimal = Decimal.init(entity.prise)
            let worth = ether * priseDecimal
            if let worthDouble = Double(worth.description) {
                entity.CNY = String(format: "%0.2f", worthDouble)
                self.totalWorth += worthDouble
            }
            self.propertyArray.append(entity)
            self.count -= 1
            completion()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.propertyArray.count + 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierHead", for: indexPath) as! WalletHeadCell
            cell.accessoryType = .none
            let s = String(format: "%0.2f", self.totalWorth)
            cell.totalNumberLabel.text = "总资产"
            cell.infoLabel.text = "≈￥\(s)"
            cell.addressLabel.text = WalletManager.shared.entity.address
            cell.nameLabel.text = WalletManager.shared.entity.name
            cell.settingBlock = {
//                let storyboard = UIStoryboard(name: "Export", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "verifyMnemonicVC") as! VerifyMnemonicController
//
//                self.navigationController?.pushViewController(vc, animated: true)
            
                let vc = SettingViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.scanBlock = {
                //self.performSegue(withIdentifier: "receipt", sender: nil)
            }
            cell.detailBlock = {
                self.performSegue(withIdentifier: "walletDetail", sender: false)
            }
            cell.codeBlock = {
                print(WalletManager.shared.entity.address)
                self.performSegue(withIdentifier: "walletAddress", sender: WalletManager.shared.entity.address)
            }
            cell.addBlock = {
                let vc = AddPropertyController()
                vc.finishBlock = { array in
                    print("entity = ",array)
                    self.tableView?.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
//            cell.transferBlock = {
//                self.performSegue(withIdentifier: "transfer", sender: nil)
//            }
//            cell.receiptBlock = {
//                self.performSegue(withIdentifier: "receipt", sender: nil)
//            }
//            cell.checkBlock = {
//                self.performSegue(withIdentifier: "checkWallet", sender: false)
//            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! PropertyViewCell
            let entity = self.propertyArray[indexPath.row - 1]
            
            cell.coinImagView.image = UIImage(named: entity.image!)
            cell.coinNameLabel.text = entity.shortName
            cell.coinLongNameLabel.text = entity.wholeName
            let ether = EthUnit.weiToEther(wei: EthUnit.Wei(entity.coinNum))
            cell.coinNumberLabel.text = "\(EthUnit.decimalNumberHandler(ether))"
            //cell.coinNumberLabel.text = String.init(format: "%.4f", ether as CVarArg) //"\(ether)"
            cell.worthLabel.text = "≈￥" + entity.CNY
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row > 0 {
            let entity = self.propertyArray[indexPath.row - 1]
            self.performSegue(withIdentifier: "property", sender: entity)
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.row > 0 else{
            return []
        }
        let entity = self.propertyArray[indexPath.row - 1]
        //default,destructive默认红色，normal默认灰色，可以通过backgroundColor 修改背景颜色，backgroundEffect 添加模糊效果
        let recipeAction = UITableViewRowAction(style: .destructive, title: "收款") { (action, indexPath) in
            self.performSegue(withIdentifier: "receipt", sender: entity)
        }
        let transferAction = UITableViewRowAction(style: .default, title: "转账") { (action, indexPath) in
            self.performSegue(withIdentifier: "transfer", sender: entity)
        }
        let cancelAction = UITableViewRowAction(style: .normal, title: "取消") { (action, indexPath) in
            
        }
        transferAction.backgroundColor = JXGreenColor
        recipeAction.backgroundColor = JXRedColor
        cancelAction.backgroundColor = JXOrangeColor
        return [cancelAction,transferAction,recipeAction]
    }
         
}
