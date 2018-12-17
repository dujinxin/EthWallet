//
//  ConstantHeader.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/7/3.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import Foundation
import UIKit
import JXFoundation

//MARK:尺寸类
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kScreenBounds = UIScreen.main.bounds

let kStatusBarHeight = UIScreen.main.isIphoneX ? CGFloat(44) : CGFloat(20)
let kNavBarHeight = CGFloat(44)
let kNavStatusHeight = kStatusBarHeight + kNavBarHeight
let kBottomMaginHeight : CGFloat = UIScreen.main.isIphoneX ? 34 : 0
let kTabBarHeight : CGFloat = kBottomMaginHeight + 49

let kHWPercent = (kScreenHeight / kScreenWidth)//高宽比例
let kPercent = kScreenWidth / 375.0
//
////MARK:颜色
//
//let JX333333Color = UIColor.rgbColor(rgbValue: 0x333333)
//let JX666666Color = UIColor.rgbColor(rgbValue: 0x666666)
//let JX999999Color = UIColor.rgbColor(rgbValue: 0x999999)
//let JXEeeeeeColor = UIColor.rgbColor(rgbValue: 0xeeeeee)
//let JXFfffffColor = UIColor.rgbColor(rgbValue: 0xffffff)
//let JXF1f1f1Color = UIColor.rgbColor(rgbValue: 0xf1f1f1)
//
//let JXMainColor = UIColor.rgbColor(rgbValue: 0x0469c8)
//let JXGrayColor = UIColor.rgbColor(from: 177, 178, 177)
//let JXOrangeColor = UIColor.rgbColor(from: 219, 80, 8)
//let JXTextColor = UIColor.rgbColor(from: 59, 67, 104)
//
////tableView SeparatorView backgroundColor R:0.78 G:0.78 B:0.8 A:1
//let JXSeparatorColor = UIColor.init(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)


//1黑色系
let JXOrangeColor = UIColor.rgbColor(rgbValue: 0xff9300)
let JXRedColor = UIColor.rgbColor(rgbValue: 0xEF4262)
let JXGreenColor = UIColor.rgbColor(rgbValue: 0x30DA51)

let JXPlaceHolerColor = UIColor.rgbColor(rgbValue: 0x686883)

let JX22222cShadowColor = UIColor.rgbColor(rgbValue: 0x22222c, alpha: 0.25)
let JX10101aShadowColor = UIColor.rgbColor(rgbValue: 0x10101a, alpha: 0.15)

//2蓝色系
let JXBlueColor = UIColor.rgbColor(rgbValue: 0x0089f9)
let JXBlue60Color = UIColor.rgbColor(rgbValue: 0x0089f9, alpha: 0.6)


let JXMainColor = JXBlueColor
let JXMainTextColor = UIColor.rgbColor(rgbValue: 0x383838)
let JXMainText50Color = UIColor.rgbColor(rgbValue: 0x383838, alpha: 0.5)

let JXViewBgColor = JXFfffffColor
let JXTextViewBgColor = UIColor.rgbColor(rgbValue: 0xe8e8e8)
let JXTextViewBg1Color = JXTextViewBgColor
let JXTextViewBg2Color = UIColor.rgbColor(rgbValue: 0xb7b7b7, alpha: 0.44)
let JXUIBarBgColor = JXFfffffColor
let JXMerchantIconBgColor = JXMainColor
let JXMerchantIconTextColor = JXFfffffColor

let JXLargeTitleColor = JXBlueColor
let JXLittleTitleColor = JXBlue60Color
let JXOrderDetailBgColor = JXFfffffColor

let JXSeparatorColor = UIColor.rgbColor(rgbValue: 0xd3dfef)


