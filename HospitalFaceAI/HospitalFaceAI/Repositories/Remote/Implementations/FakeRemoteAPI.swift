//
//  FakeRemoteAPI.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/12.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import PromiseKit

struct FakeRemoteAPI: RemoteAPI {

    
    func login(name: String, idCard: String) -> Promise<UserSession> {
        guard name == "test" && idCard == "123456" else {
            return Promise(error: FaceDetectError.remoteError(message: "此demo全部使用假数据，请用姓名：test，身份证：123456登录"))
        }
        return Promise<UserSession> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let encrypInfo = EncrypInfo(nameEncryp: "fake", idCardEncryp: "fake", passMsgEncryp: "fake")
                let userSession = UserSession(userInfo: UserInfo(name: "test", idCard: "123456"),encrypInfo: encrypInfo,authorized: false,faceCheckSuccess: false)
                seal.fulfill(userSession)
            }
        }
    }
    
    func agreement(userSession: UserSession) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let encrypInfo = EncrypInfo(nameEncryp: "fake", idCardEncryp: "fake", passMsgEncryp: "fake")
                let userSession = UserSession(userInfo: UserInfo(name: "test", idCard: "123456"),encrypInfo: encrypInfo,authorized: true,faceCheckSuccess: false)
                seal.fulfill(userSession)
            }
        }
    }
    
//    func recognizeFace(name: String, idCard: String) -> Promise<UserSession> {
//        return Promise<UserSession> { seal in
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                let userSession = UserSession(userInfo: UserInfo(name: "test", idCard: "123456"),authorized: true,faceCheckSuccess: true)
//                seal.fulfill(userSession)
//            }
//        }
//    }
    
    func checkInFace(userSession: UserSession,faceStrs: [String]) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                let encrypInfo = EncrypInfo(nameEncryp: "fake", idCardEncryp: "fake", passMsgEncryp: "fake")
                let userSession = UserSession(userInfo: UserInfo(name: "test", idCard: "123456"),encrypInfo: encrypInfo,authorized: false,faceCheckSuccess: false)
                seal.fulfill(userSession)
            }
        }
    }
    
    func loadAgreeHtml() -> Promise<String> {
        return Promise<String> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let html = "测试返回的Html数据（假数据）"
                seal.fulfill(html)
            }
        }
    }

}
