//
//  VerifyMnemonicController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/12/17.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class VerifyMnemonicController: JXBaseViewController {
    
    var unInputMnemonics = [String]()
    var inputMnemonics = [String]()
    
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            topConstraint.constant = kNavStatusHeight + 30
        }
    }
    @IBOutlet weak var textLabel1: UILabel!{
        didSet{
            textLabel1.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var textLabel2: UILabel!{
        didSet{
            textLabel2.textColor = JXRedColor
            textLabel2.text = ""
        }
    }
    
    @IBOutlet weak var inputMnemonicView: UIView!
    @IBOutlet weak var inputMnemonicViewHeight: NSLayoutConstraint!
    @IBOutlet weak var unInputMnemonicView: UIView!
    @IBOutlet weak var unInputMnemonicViewHeight: NSLayoutConstraint!
    
    var mnemonicStr = "1 2 34 567 89 00 88 7 6678 ghjk hhgy8ih 8 jbhkj 8998 bhghghkjj"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "验证助记词"
        
        let titles = mnemonicStr.components(separatedBy: " ")
        print(self.unInputMnemonicView)
        self.unInputMnemonics = titles
        self.unInputMnemonicViewHeight.constant = self.setupMnemonicView(self.unInputMnemonicView, subViewsWithTitles: titles)
    }
    
    func setupMnemonicView(_ mnemonicContentView: UIView, subViewsWithTitles titles: Array<String>) -> CGFloat{
        
        mnemonicContentView.removeAllSubView()
        
        let rangeRect = CGRect(x: 24, y: 0, width: kScreenWidth - 48, height: 65)
        let lineSpace : CGFloat = 10
        let itemSpace : CGFloat = 6
        let itemWidth : CGFloat = 35
        
        
        var frontRect = CGRect()
        
        for i in 0..<titles.count {
            
            let size = self.calculate(text: titles[i], width: rangeRect.width, fontSize: 14, lineSpace: 0)
            var frame = CGRect()
            
            let label = UILabel()
            
            label.tag = i
            label.text = titles[i]
            label.textColor = JXMainTextColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.layer.cornerRadius = 2
            label.layer.borderColor = JXSeparatorColor.cgColor
            label.layer.borderWidth = 1
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addTap(tap:))))
            
            if i == 0 {
                frame = CGRect(x: rangeRect.minX, y: 15, width: size.width, height: itemWidth)
            } else {
                if frontRect.maxX + itemSpace + size.width <= rangeRect.maxX {
                    frame = CGRect(x: frontRect.maxX + itemSpace, y: frontRect.minY, width: size.width, height: itemWidth)
                } else {
                    frame = CGRect(x: rangeRect.minX, y: frontRect.maxY + lineSpace, width: size.width, height: itemWidth)
                }
            }
            
            label.frame = frame
            mnemonicContentView.addSubview(label)
            frontRect = label.frame
            //unInputMnemonics.append(titles[i])
        }
        //var rect = mnemonicContentView.frame
        //rect.size.height = (frontRect.maxY + 15) <= 65 ? 65 : (frontRect.maxY + 15)
        //mnemonicContentView.frame = rect
        return (frontRect.maxY + 15) <= 65 ? 65 : (frontRect.maxY + 15)
    }
    func calculate(text: String, width: CGFloat, fontSize: CGFloat, lineSpace: CGFloat = -1) -> CGSize {
        
        if text.isEmpty {
            return CGSize()
        }
        
        var attributes : Dictionary<NSAttributedString.Key, Any>
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = lineSpace
        
        if lineSpace < 0 {
            attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)]
        }else{
            attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize),NSAttributedString.Key.paragraphStyle:paragraph]
        }
        let rect = text.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: attributes, context: nil)
        
        let height : CGFloat
        if rect.origin.x < 0 {
            height = abs(rect.origin.x) + rect.height
        }else{
            height = rect.height
        }
        
        return CGSize(width: rect.width + 20, height: height)
    }

    @objc func addTap(tap: UITapGestureRecognizer) {
        guard let v = tap.view, let label = v as? UILabel else { return }
        
        if let superview = label.superview {
            if superview == self.inputMnemonicView {
                inputMnemonics.remove(at: label.tag)
                unInputMnemonics.append(label.text ?? "")
            } else {
                unInputMnemonics.remove(at: label.tag)
                inputMnemonics.append(label.text ?? "")
            }
            self.setupInputView()
            self.setupUnInputView()
            
            
            
            if self.compareMnemonic() == false {
                self.textLabel2.text = "助记词顺序不正确，请校对"
            } else {
                self.textLabel2.text = ""
            }
        }
    }
    
    func setupInputView() {
        self.inputMnemonicViewHeight.constant = self.setupMnemonicView(self.inputMnemonicView, subViewsWithTitles: inputMnemonics)
    }
    func setupUnInputView() {
        self.unInputMnemonicViewHeight.constant = self.setupMnemonicView(self.unInputMnemonicView, subViewsWithTitles: unInputMnemonics)
    }
    func compareMnemonic() -> Bool {
        if self.inputMnemonics.count == 0 {
            return false
        }
        var importStr = ""
        for i in 0..<self.inputMnemonics.count {
            importStr += self.inputMnemonics[i]
            if i != self.inputMnemonics.count - 1 {
                importStr += " "
            }
        }
        
        return self.mnemonicStr.hasPrefix(importStr)
    }
    
}
