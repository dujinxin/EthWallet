//
//  ImportWalletController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class ImportWalletController: MyBaseViewController,JXBarViewDelegate,JXHorizontalViewDelegate {

    var topBar : JXBarView!
    var horizontalView : JXHorizontalView?
    
    lazy var keystoreVC: KeyStoreController = {
        let storyboard = UIStoryboard(name: "Import", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "keystoreVC") as! KeyStoreController
        return vc
    }()
    lazy var privateVC: PrivateKeyController = {
        let storyboard = UIStoryboard(name: "Import", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "privateVC") as! PrivateKeyController
        return vc
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "导入钱包"
        
        
        self.keystoreVC.backBlock = { ()->() in
            if let block = self.backBlock {
                block()
            }
        }
        self.privateVC.backBlock = { ()->() in
            if let block = self.backBlock {
                block()
            }
        }
        
        topBar = JXBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: 44), titles: ["keystore导入","明文私钥导入"])
        topBar.delegate = self
        topBar.backgroundColor = JXFfffffColor
        topBar.bottomLineSize = CGSize(width: 60, height: 2)
        topBar.bottomLineView.backgroundColor = JXSeparatorColor
        topBar.isBottomLineEnabled = true
        let att = JXAttribute()
        att.normalColor = JXMainText50Color
        att.selectedColor = JXMainTextColor
        att.font = UIFont.systemFont(ofSize: 17)
        topBar.attribute = att
        view.addSubview(topBar)

        
        horizontalView = JXHorizontalView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 44, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 44), containers: [keystoreVC,privateVC], parentViewController: self)
        view.addSubview(horizontalView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ImportWalletController {
    
    func jxBarView(barView: JXBarView, didClick index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView?.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
    }
    func horizontalViewDidScroll(scrollView:UIScrollView) {
//        var frame = self.topBar?.bottomLineView.frame
//        let offset = scrollView.contentOffset.x
//        frame?.origin.x = (offset / view.bounds.width ) * (view.bounds.width / 2)
//        self.topBar?.bottomLineView.frame = frame!
        
        let offset = scrollView.contentOffset.x
        var x : CGFloat
        let count = CGFloat(self.topBar.titles.count)
        
        x = (kScreenWidth / count  - self.topBar.bottomLineSize.width) / 2 + (offset / kScreenWidth ) * ((kScreenWidth / count))
        
        self.topBar.bottomLineView.frame.origin.x = x
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        //
        if self.topBar?.selectedIndex == indexPath.item {
            return
        }
        self.topBar.scrollToItem(at: indexPath)
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
