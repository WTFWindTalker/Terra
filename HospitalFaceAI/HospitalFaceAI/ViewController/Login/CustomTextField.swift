//
//  CustomTextField.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/23.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
////未编辑状态下的起始位置
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectInset(bounds, 5, 0);
//    }
//    // 编辑状态下的起始位置
//    - (CGRect)editingRectForBounds:(CGRect)bounds {
//        return CGRectInset(bounds, 5, 0);
//        }
//        //placeholder起始位置
//        - (CGRect)placeholderRectForBounds:(CGRect)bounds {
//            return CGRectInset(bounds, 5, 0);
//}

class CustomTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width-15, height: bounds.height)
        return inset
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width-15, height: bounds.height)
        return inset
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width-15, height: bounds.height)
        return inset
    }
    

}
