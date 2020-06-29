//
//  FacepicStringResponser.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/17.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation

protocol FacepicStringResponser {
    func fetchFacePicString(facepicStrings: [String])
    func cancelFaceFetch()
}

