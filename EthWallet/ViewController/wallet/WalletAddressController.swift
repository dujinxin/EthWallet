//
//  WalletAddressController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/12/16.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletAddressController: BaseViewController {
    
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
    @IBOutlet weak var addressLabel: UILabel!{
        didSet{
            addressLabel.textColor = JXMainTextColor
            
            addressLabel.layer.cornerRadius = 2
            addressLabel.layer.shadowOpacity = 1
            addressLabel.layer.shadowRadius = 10
            addressLabel.layer.shadowColor = JX10101aShadowColor.cgColor
            addressLabel.layer.shadowOffset = CGSize(width: 0, height: -3)
        }
    }
    
    @IBOutlet weak var confirmButton: JXShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = WalletManager.manager.walletEntity.name
        
        self.addressLabel.text = WalletManager.manager.walletEntity.address
        self.codeImageView.image = self.code(WalletManager.manager.walletEntity.address)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 44
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    @IBAction func copyAddress(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = WalletManager.manager.walletEntity.address
        ViewManager.showNotice("复制成功")
        
        self.confirmButton.backgroundColor = UIColor.lightGray
        self.confirmButton.isEnabled = false
        self.confirmButton.setTitle("已复制", for: .normal)
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
