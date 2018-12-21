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
import MJRefresh

class WalletViewController: JXBaseViewController {
    
    //MARK:wallet headerView
    
    @IBOutlet weak var headerView: UIView!{
        didSet{
            headerView.backgroundColor = JXMainColor
        }
    }
    @IBOutlet weak var topSubConstraint: NSLayoutConstraint!{
        didSet{
            topSubConstraint.constant = kStatusBarHeight
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
            nameLabel.text = ""
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
            addressLabel.text = ""
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
            totalNumberLabel.text = ""
            totalNumberLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var infoLabel: UILabel!{
        didSet{
            infoLabel.text = "总资产"
            infoLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            addButton.tintColor = JXFfffffColor
        }
    }
    
    
    @IBAction func setting(_ sender: Any) {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func scan(_ sender: Any) {
        //self.performSegue(withIdentifier: "receipt", sender: nil)
    }
    @IBAction func codeAddress(_ sender: Any) {
        print(WalletManager.shared.entity.address)
        self.performSegue(withIdentifier: "walletAddress", sender: WalletManager.shared.entity.address)
    }
    @IBAction func addProperty(_ sender: Any) {
        let vc = AddPropertyController()
        vc.finishBlock = { array in
            print("entity = ",array)
            self.tableView?.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func walletDetail() {
        self.performSegue(withIdentifier: "walletDetail", sender: false)
    }
    //MARK:wallet tableView
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib.init(nibName: "WalletHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHead")
            tableView.register(UINib.init(nibName: "PropertyViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
            tableView.estimatedRowHeight = 70
            tableView.separatorStyle = .none
            tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                self.requestData()
            })
        }
    }
    //MARK:no wallet
    @IBOutlet weak var defaultBackView: UIView!{
        didSet{
            defaultBackView.backgroundColor = JXFfffffColor
        }
    }
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            topConstraint.constant = kNavStatusHeight + 84
        }
    }
    @IBOutlet weak var createButton: JXShadowButton!
    @IBOutlet weak var importButton: UIButton!
    
    
    var count : Int = 0
    var propertyArray = Array<PropertyEntity>()
    
    var prise : Double = 0
    var totalWorth : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "钱包"
 
        NotificationCenter.default.addObserver(self, selector: #selector(walletChange(notify:)), name: NSNotification.Name(rawValue: "NotificationWalletChange"), object: nil)
        
        self.resetMainView()
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
//        case "walletAddress":
//            if let vc = segue.destination as? WalletAddressController {
//                print(sender ?? "")
//            }
        case "transfer":
            if let vc = segue.destination as? TransferViewController, let entity = sender as? PropertyEntity {
                vc.entity = entity
                if entity.shortName == "ETH" {
                    vc.type = .eth
                } else {
                    vc.type = .erc20
                }
                
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
            self.tableView.isHidden = false
            self.headerView.isHidden = false
            
            self.tableView.mj_header.beginRefreshing()
        } else {
            self.title = "钱包"
            self.defaultBackView.isHidden = false
            self.tableView.isHidden = true
            self.tableView.isHidden = true
        }
    }
    @objc func walletChange(notify: Notification) {
        self.requestData()
    }
    override func requestData() {
        
        self.showMBProgressHUD()
        self.count = 2
        self.fetchData(count: count) {
            self.tableView.mj_header.endRefreshing()
            if self.count == 0 {
                self.hideMBProgressHUD()
            }
            
            self.infoLabel.text = "总资产"
            let s = String(format: "%0.2f", self.totalWorth)
            self.totalNumberLabel.text = "≈￥\(s)"
            self.addressLabel.text = WalletManager.shared.entity.address
            self.nameLabel.text = WalletManager.shared.entity.name
            
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
}
extension WalletViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.propertyArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! PropertyViewCell
        let entity = self.propertyArray[indexPath.row]
        
        cell.coinImagView.image = UIImage(named: entity.image!)
        cell.coinNameLabel.text = entity.shortName
        cell.coinLongNameLabel.text = entity.wholeName
        let ether = EthUnit.weiToEther(wei: EthUnit.Wei(entity.coinNum))
        cell.coinNumberLabel.text = "\(EthUnit.decimalNumberHandler(ether))"
        //cell.coinNumberLabel.text = String.init(format: "%.4f", ether as CVarArg) //"\(ether)"
        cell.worthLabel.text = "≈￥" + entity.CNY
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entity = self.propertyArray[indexPath.row]
        self.performSegue(withIdentifier: "property", sender: entity)
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let entity = self.propertyArray[indexPath.row]
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
