//
//  FakeUserSessionDataStore.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/12.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import PromiseKit

class FakeUserSessionDataStore: UserSessionDataStore {
    func save(userSession: UserSession) -> Promise<(UserSession)> {
        return .value(userSession)
    }
    
    func delete(userSession: UserSession) -> Promise<(UserSession)> {
        return .value(userSession)
    }
    
    func readUserSession() -> Promise<UserSession?> {
        let encrypInfo = EncrypInfo(nameEncryp: "fake", idCardEncryp: "fake", passMsgEncryp: "fake")
        let remoteSession = UserSession(userInfo: UserInfo(name: "fakeTest",idCard: "12312321312321"), encrypInfo: encrypInfo,authorized: false,faceCheckSuccess: false)
        return .value(remoteSession)
    }
}
