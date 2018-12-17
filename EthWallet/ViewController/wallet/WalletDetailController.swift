//
//  WalletDetailController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/21.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift
import BigInt


class WalletDetailController: JXTableViewController {
    
    var defaultArray = [
        [
            ["image":"IPE","title":""]
        ],
        [
            ["image":"icon-collection","title":"密码提示语"],
            ["image":"icon-help","title":"导出助记词"],
            ["image":"icon-protect","title":"导出keystone"],
            ["image":"icon-system","title":"导出私钥"]
        ]
    ]
    
    var dict = Dictionary<String,Any>()
    
    var vm : Web3VM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "管理"
        
        //self.tableView?.register(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier1")
        //self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier1")
        self.tableView?.register(UINib(nibName: "ImageTitleCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier2")
        self.tableView?.estimatedRowHeight = 64
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        
        switch segue.identifier {
        
        case "modifyPassword":
            let vc = segue.destination as! ModifyPasswordController
            vc.dict = self.dict
        default:
            print("none")
        }
    }
    @IBAction func scan(_ sender: Any) {
    }
    @IBAction func deleteWallet(_ sender: Any) {
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < 1 {
            return UIView()
        } else {
            let v = UIView()
            v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 74)
            
            
            let button = JXShadowButton(frame: CGRect(x: 20, y: 30, width: kScreenWidth - 40, height: 44))
            v.addSubview(button)
            
            button.setTitle("删除钱包", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = JXMainColor
            
            return v
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < 1 {
            return 30
        } else {
            return 50
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier2", for: indexPath) as! ImageTitleCell
        let dict = defaultArray[indexPath.section][indexPath.row]
        
        cell.iconView.image = UIImage(named: dict["image"]!)
        if indexPath.section == 0 {
            cell.titleView.text = WalletManager.manager.walletEntity.name
        } else {
            cell.titleView.text = dict["title"]
        }
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            
            let alertVC = UIAlertController(title: nil, message: "修改钱包名称", preferredStyle: .alert)
            //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
            alertVC.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "请输入"
            })
            alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                
                if
                    let textField = alertVC.textFields?[0],
                    let text = textField.text,
                    text.isEmpty == false {
                    
                    if WalletDB.shareInstance.updateWalletName(text) == true {
                        tableView.reloadSections([0], with: .automatic)
                    }
                }
            }))
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            }))
            self.present(alertVC, animated: true, completion: nil)
            
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                self.performSegue(withIdentifier: "modifyPassword", sender: nil)
            } else if indexPath.row > 1 {
                let alertVC = UIAlertController(title: nil, message: "请输入密码", preferredStyle: .alert)
                //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
                alertVC.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "password"
                })
                alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                    
                    if
                        let textField = alertVC.textFields?[0],
                        let text = textField.text,
                        text.isEmpty == false{
                        self.export(password:text, indexPath: indexPath)
                    }
                }))
                alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                }))
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    func export(password:String,indexPath:IndexPath) {

        self.showMBProgressHUD()
        
        do {
            try self.vm?.keystore?.regenerate(oldPassword: password, newPassword: password)
        } catch let error {
            self.hideMBProgressHUD()
            print("原钱包密码错误")
            print(error)
            return
        }
        //        let jsonStr = String.init(data: keyStore.serialize(), encoding:.utf8)
        //        let jsonDict = JSONSerialization.jsonObject(with: keyStore.serialize(), options: [])
        //

        if indexPath.row == 2 { //导出keystore
            guard let keystoreBase64Str = self.dict["keystore"] as? String else {return}
            
            let vc = ExportKSViewController()
            vc.keystoreStr = String.convertBase64Str(keystoreBase64Str)
            self.navigationController?.pushViewController(vc, animated: true)
         
        } else if indexPath.row == 3 { //导出私钥
            guard let keystoreBase64Str = self.dict["keystore"] as? String else {return}
            self.vm = Web3VM.init(keystoreBase64Str: keystoreBase64Str)
            let address = self.vm.keystore?.addresses![0]
            
            if let privateKey = try? self.vm?.keystore?.UNSAFE_getPrivateKeyData(password: password, account: address!).toHexString() {
                
                let vc = ExportPKViewController()
                vc.privateKeyStr = privateKey ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        self.hideMBProgressHUD()
    }

}
