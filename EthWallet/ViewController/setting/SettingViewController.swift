//
//  SettingViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SettingViewController: MyTableViewController {

    var defaultArray = [
        [
            ["image":"IPE","title":""]
        ],
        [
            ["image":"icon-collection","title":"更换钱包"],
            ["image":"icon-help","title":"修改密码"],
            ["image":"icon-protect","title":"交易记录"],
            ["image":"icon-system","title":"导出私钥"]
        ]
    ]
    lazy var vm: Web3VM = {
        let vm = Web3VM.init(keystoreBase64Str: WalletManager.shared.entity.keystore)//自己的钱包
        return vm
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"

        self.tableView.register(UINib(nibName: "ImageTitleCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.estimatedRowHeight = 64
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = WalletListController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
           // self.vm.web3?.eth.getTransactionDetails(<#T##txhash: String##String#>)
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return defaultArray.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultArray[section].count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableViewAutomaticDimension
        if indexPath.section == 0 {
            return 70
        } else {
            return 50
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ImageTitleCell
        let dict = defaultArray[indexPath.section][indexPath.row]
        
        cell.iconView.image = UIImage(named: dict["image"]!)
        if indexPath.section == 0 {
            cell.titleView.text = WalletManager.shared.entity.name
        } else {
            cell.titleView.text = dict["title"]
        }
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
