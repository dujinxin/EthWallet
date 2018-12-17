//
//  AddPropertyController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift

class AddPropertyController: JXTableViewController {

    var propertyArray = Array<PropertyEntity>()
    var finishBlock : ((_ array: Array<PropertyEntity>) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.register(UINib.init(nibName: "AddPropertyCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        
        let entity = PropertyEntity()
        entity.shortName = "ZC"
        entity.wholeName = "智慧币"
//        entity.address = "0x34a9a46340d0b76e423ea75e5a62b6a81ff35bf6"
        self.propertyArray.append(entity)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return propertyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! AddPropertyCell
        cell.selectionStyle = .none
        
        let entity = propertyArray[indexPath.row]
        cell.entity = entity
        cell.clickBlock = {
            if let block = self.finishBlock {
                block(self.propertyArray)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let dict = dataArray[indexPath.row]
//        self.performSegue(withIdentifier: "walletDetail", sender: dict)
    }
}
