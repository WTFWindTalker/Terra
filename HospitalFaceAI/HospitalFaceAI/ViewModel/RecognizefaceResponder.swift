//
//  RecognizefaceResponder.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/16.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation

protocol RecognizefaceResponder {
    func recognizeFace(name: String, idCard: String)
    func checkface(imagestrs: [String])
    func cancleCheck()
    func checkSuccess()
}
