//
//  UIBarButtonItemExtensions.swift
//  Scanpro1
//
//  Created by song on 2019/6/16.
//  Copyright © 2019年 song. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UIBarButtonItem {
    class func creatBarButtonItemImagePic(target:Any?,action:Selector?,ImageNormal:UIImage,ImageSel:UIImage, tag:Int = 0) -> UIBarButtonItem {
        let Btn = UIButton()
        Btn.setImage(ImageNormal, for: .normal)
        Btn.setImage(ImageSel, for: .highlighted)
        guard let act = action else {
            return UIBarButtonItem(customView: Btn)
        }
        Btn.tag = tag
        
        Btn.addTarget(target, action: act, for: .touchUpInside)
        return UIBarButtonItem(customView: Btn)
    }
    
    class func creatBarButtonItemImage(target:Any?,action:Selector,ImageName:String,ImageSelName:String) -> UIBarButtonItem {
        let Btn = UIButton()
        Btn.setImage(UIImage(named: ImageName), for: .normal)
        Btn.setImage(UIImage(named: ImageSelName), for: .highlighted)
        Btn.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: Btn)
    }
    
    class func creatBarButtonItemTitle(target:Any?,action:Selector,title:String,titleColorNomal:UIColor = .black,titleColorSel:UIColor = .black) -> UIBarButtonItem {
        let Btn = UIButton()
        Btn.setTitle(title, for: .normal)
        Btn.setTitleColor(titleColorNomal, for: .normal)
        Btn.setTitleColor(titleColorSel, for: .highlighted)
        Btn.addTarget(target, action:action, for: .touchUpInside)
        
        return UIBarButtonItem(customView:Btn)
    }
    
    class func creatBarButtonItemTitleAndImage(target:Any?,action:Selector,ImageName:String,ImageSelName:String,title:String,titleColorNomal:UIColor = .black,titleColorSel:UIColor = .black) -> UIBarButtonItem {
        let Btn = UIButton()
        Btn.setTitle(title, for: .normal)
        Btn.setImage(UIImage(named: ImageName), for: .normal)
        Btn.setImage(UIImage(named: ImageSelName), for: .highlighted)
        Btn.setTitleColor(titleColorSel, for: .normal)
        Btn.setTitleColor(UIColor.red, for: .highlighted)
        Btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        Btn.titleEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        Btn.addTarget(target, action:action, for: .touchUpInside)
        Btn.sizeToFit()
        
        return UIBarButtonItem(customView:Btn)
    }
    
    
    /// SwifterSwift: Add Target to UIBarButtonItem
    ///
    /// - Parameters:
    ///   - target: target.
    ///   - action: selector to run when button is tapped.
    func addTargetForAction(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    
}

#endif
