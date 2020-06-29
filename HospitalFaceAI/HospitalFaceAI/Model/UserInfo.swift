//
//  UserInfo.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/11.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation

struct UserInfo: Equatable, Codable {
    let name: String
    let idCard: String
    
    init(name: String, idCard: String) {
        self.name = name
        self.idCard = idCard
    }
}

struct EncrypInfo: Equatable, Codable {
    let nameEncryp: String
    let idCardEncryp: String
    let passMsgEncryp: String
    
    init(nameEncryp: String, idCardEncryp: String, passMsgEncryp: String) {
        self.nameEncryp = nameEncryp
        self.idCardEncryp = idCardEncryp
        self.passMsgEncryp = passMsgEncryp
    }
}
