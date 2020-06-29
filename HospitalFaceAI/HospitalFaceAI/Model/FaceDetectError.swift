//
//  FaceDetectError.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/12.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
//error 留给以后扩展
enum FaceDetectError: Error {
    case httpError
    case remoteError(message:String)
    case localJsonNotExist
    case any
}

//enum RemoteAPIError: Error {
//    case unknown
//    case httpError
//    case remoteError
//}
