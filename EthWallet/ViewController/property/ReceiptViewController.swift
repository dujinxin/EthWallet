//
//  RecipeViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/12/15.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import BigInt

class ReceiptViewController: BaseViewController {
    
    @IBOutlet weak internal var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var codeImageView: UIImageView!{
        didSet{
            codeImageView.layer.cornerRadius = 2
            codeImageView.layer.shadowOpacity = 1
            codeImageView.layer.shadowRadius = 10
            codeImageView.layer.shadowColor = JX10101aShadowColor.cgColor
            codeImageView.layer.shadowOffset = CGSize(width: 0, height: -3)
        }
    }
    
    @IBOutlet weak var noticeLabel: UILabel!{
        didSet{
            noticeLabel.textColor = JXMainTextColor
            
            noticeLabel.layer.cornerRadius = 2
            noticeLabel.layer.shadowOpacity = 1
            noticeLabel.layer.shadowRadius = 10
            noticeLabel.layer.shadowColor = JX10101aShadowColor.cgColor
            noticeLabel.layer.shadowOffset = CGSize(width: 0, height: -3)
        }
    }
    
  
    @IBOutlet weak var changeButton: JXShadowButton!
    @IBOutlet weak var numberButton: JXShadowButton!
    
    
    var type : Type = .eth
    var contractAddress : String = ""
    var tokenName : String = "ETH"
    
    var receiptStr = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "收款"
        
        
        //self.noticeLabel.text = WalletManager.manager.walletEntity.address
        
        self.noticeLabel.text = "请转入\(tokenName)"
        self.receiptStr = self.getReceiptStr(t: type, contractAddress: contractAddress, value: 0)
        
        self.codeImageView.image = self.code(self.receiptStr)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 44
    }
    func getReceiptStr(t: Type, contractAddress: String = "", value: BigInt = 0) -> String {
        var s = ""
        if t == .eth {
            s = "ethereum:\(WalletManager.manager.walletEntity.address)?decimal=\(18)&value=\(value)"
            
        } else {
            s  = "ethereum:\(WalletManager.manager.walletEntity.address)?contractAddress=\(contractAddress)&decimal=\(18)&value=\(value)"
        }
        print(s)
        return s
    }
    
    @IBAction func changeProperty(_ sender: Any) {
        print("更换资产")
        
        self.receiptStr = self.getReceiptStr(t: type, contractAddress: contractAddress, value: 0)
        self.codeImageView.image = self.code(self.receiptStr)
    }
    @IBAction func setNumber(_ sender: Any) {
        print("设定金额")
        let alertVC = UIAlertController(title: nil, message: "输入金额", preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.keyboardType = .decimalPad
            //textField.placeholder = "请输入数量"
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
            if
                let textField = alertVC.textFields?[0],
                let text = textField.text,
                text.isEmpty == false, let doubleNum = Double(text){
                
                let bigInt = EthUnit.etherToWei(ether: Decimal(doubleNum))
                
                self.receiptStr = self.getReceiptStr(t: self.type, contractAddress: self.contractAddress, value: bigInt)
                self.codeImageView.image = self.code(self.receiptStr)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        self.present(alertVC, animated: true, completion: nil)
        
        
    }
    
    func code(_ string:String) -> UIImage {
        //二维码滤镜
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        //设置滤镜默认属性
        filter?.setDefaults()
        
        let data = string.data(using: .utf8)
        
        //设置内容
        filter?.setValue(data, forKey: "inputMessage")
        //设置纠错级别
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        //获取滤镜输出图像
        guard let outImage = filter?.outputImage else{
            return UIImage()
        }
        //转换CIIamge为UIImage,并放大显示
        guard let image = self.createNonInterpolatedUIImage(outImage, size: CGSize(width: kScreenWidth - 50 * 2, height: kScreenWidth - 50 * 2)) else {
            return UIImage()
        }
        return image
    }
    func createNonInterpolatedUIImage(_ ciImage : CIImage,size:CGSize) -> UIImage? {
        let a = size.height
        
        let extent = ciImage.extent.integral
        let scale = min(a / extent.size.width, a / extent.size.height)
        //创建bitmap
        let width = extent.width * scale
        let height = extent.height * scale
        
        let cs = CGColorSpaceCreateDeviceGray()
        guard let bitmapRef = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
            return nil
        }
        let context = CIContext.init()
        guard let bitmapImage = context.createCGImage(ciImage, from: extent) else {
            return nil
        }
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        //保存bitmap到图片
        guard let scaledImage = bitmapRef.makeImage() else {
            return nil
        }
        let image = UIImage.init(cgImage: scaledImage)
        return image
    }
}
