//
//  WalletListController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletListController: JXTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "钱包列表"
        
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(walletAction))
        
        self.tableView?.register(UINib(nibName: "JXActionCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        
        self.tableView?.rowHeight = 50
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let date1 = Date()
        
        dataArray = WalletDB.shared.selectData()!
        let date2 = Date()
        
        
        print(date1)
        print(date2)
        print(dataArray)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "createWallet":
            let vc = segue.destination as! CreateWalletController
            vc.backBlock = { ()->() in
                self.dataArray.removeAll()
                self.dataArray = WalletDB.shared.selectData()!
                self.tableView?.reloadData()
            }
        case "importWallet":
            let vc = segue.destination as! ImportWalletController
            vc.backBlock = { ()->() in
                self.dataArray.removeAll()
                self.dataArray = WalletDB.shared.selectData()!
                self.tableView?.reloadData()
            }
        case "walletDetail":
            let vc = segue.destination as! WalletDetailController
            let dict = sender as! Dictionary<String, Any>
            vc.dict = dict
        default:
            print("11")
        }
        //
    }
    @objc func walletAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "创建钱包", style: .default, handler: { (action) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "createVC") as! CreateWalletController
            vc.backBlock = {
                self.dataArray = WalletDB.shared.selectData()!
                self.tableView?.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "导入钱包", style: .default, handler: { (action) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "importVC") as! ImportWalletController
            vc.backBlock = {
                self.dataArray = WalletDB.shared.selectData()!
                self.tableView?.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! JXActionCell

        let dict = dataArray[indexPath.row] as! Dictionary<String,Any>
        cell.coinNameLabel.text = dict["name"] as? String

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard
            let dict = dataArray[indexPath.row] as? Dictionary<String, Any>,
            WalletDB.shared.createTable(keys: Array(dict.keys)) == true,
            WalletManager.shared.switchWallet(dict: dict) == true else {
              return
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationWalletChange"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
