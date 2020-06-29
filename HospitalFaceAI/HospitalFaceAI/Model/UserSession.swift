//
//  UserSession.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/11.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation

struct UserSession: Codable {
    let userInfo: UserInfo
    let authorized: Bool
    let faceCheckSuccess: Bool
    let encrypInfo: EncrypInfo
    init(userInfo: UserInfo, encrypInfo: EncrypInfo, authorized: Bool, faceCheckSuccess: Bool) {
        self.userInfo = userInfo
        self.encrypInfo = encrypInfo
        self.authorized = authorized
        self.faceCheckSuccess = faceCheckSuccess
    }
}

