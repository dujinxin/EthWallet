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

    var tokenArray = Array<TokenEntity>()
    var tokenResultArray = Array<TokenEntity>()
    
    var finishBlock : ((_ array: Array<PropertyEntity>) -> Void)?
    
    lazy var searchVC : UISearchController = {
        let vc = UISearchController(searchResultsController: nil)
        vc.searchResultsUpdater = self
        //        vc.hidesNavigationBarDuringPresentation = true
        vc.dimsBackgroundDuringPresentation = false
        
        vc.searchBar.backgroundColor = UIColor.groupTableViewBackground
        //vc.searchBar.backgroundImage = UIImage.imageWithColor(JXViewBgColor)
        //vc.searchBar.setSearchFieldBackgroundImage(UIImage.imageWithColor(JXViewBgColor, size: CGSize(width: kScreenWidth, height: 44)), for: .normal)
        
        vc.searchBar.tintColor = JXMainColor
        vc.searchBar.placeholder = "输入token名称"
        vc.searchBar.showsCancelButton = false
        vc.searchBar.isTranslucent = false
        vc.searchBar.keyboardType = .namePhonePad
        vc.searchBar.showsScopeBar = true
        
        let searchField = vc.searchBar.value(forKey: "searchField") as? UITextField
        searchField?.textColor = JXMainTextColor
        searchField?.font = UIFont.systemFont(ofSize: 14)
        searchField?.textAlignment = .center
        
        return vc
    }()
    lazy var titleView: UIView = {
        let v = UIView()
        v.addSubview(self.searchVC.searchBar)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.register(UINib.init(nibName: "AddPropertyCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        self.tableView?.separatorColor = JXSeparatorColor
        self.tableView?.separatorStyle = .singleLine
        
        let searchField = self.searchVC.searchBar.value(forKey: "searchField") as? UITextField
        var rect = searchField?.frame
        rect?.size.height = 44
        searchField?.frame = rect ?? CGRect()
        self.titleView.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 60, height: 44)
        
        self.customNavigationItem.titleView = self.titleView

        
//        let entity = PropertyEntity()
//        entity.shortName = "ZC"
//        entity.wholeName = "智慧币"
////        entity.address = "0x34a9a46340d0b76e423ea75e5a62b6a81ff35bf6"
//        self.propertyArray.append(entity)
        
        self.requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func requestData() {
        self.showMBProgressHUD()
        Web3VM.getEthTokens { (array, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                self.tokenArray = array
            }
            self.tableView?.reloadData()
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tokenArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! AddPropertyCell
        cell.selectionStyle = .none
        
        let entity = tokenArray[indexPath.row]
        cell.entity = entity
        cell.clickBlock = {
//            if let block = self.finishBlock {
//                block(self.propertyArray)
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let dict = dataArray[indexPath.row]
//        self.performSegue(withIdentifier: "walletDetail", sender: dict)
    }
}
extension AddPropertyController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if tokenResultArray.count > 0 {
            tokenResultArray.removeAll()
        }
        if let text = searchController.searchBar.text {
            for entity in tokenArray {
                if
                    let str = entity.symbol,
                    let range = str.lowercased().range(of: text.lowercased()), range.isEmpty == false {
                    
                    tokenResultArray.append(entity)
                    
                }
            }
        }
        self.tableView?.reloadData()
    }
}
