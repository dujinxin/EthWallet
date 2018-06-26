//
//  ViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/5/27.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    
    var totalNumber : EthUnit.Ether = 0
    
    var dataArray = Array<PropertyEntity>()
    
    var vm : Web3VM?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
    
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 60), style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 44
        self.tableView.register(UINib(nibName: "WalletHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier1")
        self.tableView.register(UINib(nibName: "PropertyViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier2")
        //        self.tableView.mj_header = MJRefreshHeader(refreshingBlock: {
        //            //self.vm.loadNewMainData(completion: <#T##((Any?, String, Bool) -> ())##((Any?, String, Bool) -> ())##(Any?, String, Bool) -> ()#>)
        //        })
        //        self.tableView.mj_header.beginRefreshing()
        self.view.addSubview(self.tableView)
        
    
        if WalletManager.manager.isWalletExist == false {
            return
        }
        guard let ethereumAddress = EthereumAddress(WalletManager.manager.userEntity.address) else {
            return
        }
        self.vm = Web3VM.init(keystoreBase64Str: WalletManager.manager.userEntity.keystore)
        
        DispatchQueue.global().async {
            let balanceResult = self.vm?.web3?.eth.getBalance(address: ethereumAddress)
            guard case .success(let balance)? = balanceResult else { return }
            print("balance = ",balance)
            DispatchQueue.main.async {
                let ether = EthUnit.weiToEther(wei: EthUnit.Wei(balance))
                self.totalNumber = ether
                
                self.tableView.reloadData()
            }
        }
        
        let entity1 = PropertyEntity()
        entity1.shortName = "ETH"
        entity1.wholeName = "以太币"
        entity1.address = "0x0000000000000000000000000000000000000000"
        
        let entity2 = PropertyEntity()
        entity2.shortName = "ZC"
        entity2.wholeName = "智慧币"
        entity2.address = "0x34a9a46340d0b76e423ea75e5a62b6a81ff35bf6"
        
        self.dataArray.append(entity1)
        self.dataArray.append(entity2)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if WalletManager.manager.isWalletExist == true {
            self.createButton.isHidden = true
            self.importButton.isHidden = true
            self.view.addSubview(self.tableView)
            self.tableView.reloadData()
        } else {
            self.createButton.isHidden = false
            self.importButton.isHidden = false
            self.tableView.removeFromSuperview()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier1", for: indexPath) as! WalletHeadCell
            cell.nameLabel.text = WalletManager.manager.userEntity.name
            cell.addressLabel.text = WalletManager.manager.userEntity.address
            cell.totalNumberLabel.text = "\(self.totalNumber)"
            cell.infoLabel.text = "总资产（￥）"
            cell.addButton.addTarget(self, action: #selector(addProperty), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier2", for: indexPath) as! PropertyViewCell
            let entity = self.dataArray[indexPath.row - 1]
            
            cell.coinNameLabel.text = entity.shortName
            cell.coinNumberLabel.text = entity.coinNum
            cell.worthLabel.text = "100" + "￥"
            
            return cell
        }
        // Configure the cell...
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1{
            self.performSegue(withIdentifier: "transfer", sender: Type.eth)
        } else {
            self.performSegue(withIdentifier: "transfer", sender: Type.erc20)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "createWallet":
            let vc = segue.destination as! CreateWalletController
            vc.backBlock = { ()->() in
                WalletManager.manager.setUserInfo()
            }
        case "transfer":
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.topViewController as! TransferViewController
            
            let type = sender as! Type
            vc.type = type
        default:
            print("11")
        }
    }
    
    func create() {
        ///以太坊节点：192.168.0.129，rpcport：8545
        ///IPT合约地址：0x34a9a46340d0b76e423ea75e5a62b6a81ff35bf6
        
        
        //钱包地址：    0xc166ca53567b84f5bdf3bd42b74106ebec574cfe
        //钱包密钥：123456
    }
    @objc func addProperty() {
        let vc = AddPropertyController()
        vc.backBlock = { entity in
            print("entity = ",entity)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
