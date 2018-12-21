//
//  ExportPKViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/22.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class ExportPKViewController: JXBaseViewController,JXTopBarViewDelegate,JXHorizontalViewDelegate {
    
    var topBar : JXTopBarView?
    var horizontalView : JXHorizontalView?
    
    lazy var pkTextVC: ExportPKTextController = {
        let storyboard = UIStoryboard(name: "Export", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pkTextVC") as! ExportPKTextController
        return vc
    }()
    lazy var pkCodeVC: ExportPKCodeController = {
        let storyboard = UIStoryboard(name: "Export", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pkCodeVC") as! ExportPKCodeController
        return vc
    }()
    
    var privateKeyStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "导出私钥"
        
        self.pkTextVC.privateKeyStr = self.privateKeyStr
        self.pkTextVC.backBlock = { ()->() in
            if let block = self.backBlock {
                block()
            }
        }
        self.pkCodeVC.privateKeyStr = self.privateKeyStr
        self.pkCodeVC.backBlock = { ()->() in
            if let block = self.backBlock {
                block()
            }
        }
        
        topBar = JXTopBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: 44), titles: ["私钥","二维码"])
        topBar?.delegate = self
        topBar?.isBottomLineEnabled = true
        
        view.addSubview(topBar!)
        
        horizontalView = JXHorizontalView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 44, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 44), containers: [pkTextVC,pkCodeVC], parentViewController: self)
        view.addSubview(horizontalView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ExportPKViewController {
    func jxTopBarView(topBarView: JXTopBarView, didSelectTabAt index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        self.horizontalView?.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
    }
    func horizontalViewDidScroll(scrollView:UIScrollView) {
        var frame = self.topBar?.bottomLineView.frame
        let offset = scrollView.contentOffset.x
        frame?.origin.x = (offset / view.bounds.width ) * (view.bounds.width / 2)
        self.topBar?.bottomLineView.frame = frame!
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        //
        if self.topBar?.selectedIndex == indexPath.item {
            return
        }
        resetTopBarStatus(index: indexPath.item)
    }
    
    func resetTopBarStatus(index:Int) {
        
        self.topBar?.selectedIndex = index
        self.topBar?.subviews.forEach { (v : UIView) -> () in
            
            if (v is UIButton){
                let btn = v as! UIButton
                if (v.tag != self.topBar?.selectedIndex){
                    btn.isSelected = false
                }else{
                    btn.isSelected = !btn.isSelected
                }
            }
        }
    }
}
