//
//  APPUserSessionRepository.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/12.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import PromiseKit

class APPUserSessionRepository: UserSessionRepository {

    
    
    let dataStore: UserSessionDataStore
    let remoteAPI: RemoteAPI
    
    init(dataStore: UserSessionDataStore, remoteAPI: RemoteAPI) {
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }
    
    func login(name: String, idCard: String) -> Promise<UserSession> {
        return remoteAPI.login(name: name, idCard: idCard)
                .then(dataStore.save(userSession:))
    }
    
    func agreement(userSession: UserSession) -> Promise<UserSession> {
        
        return remoteAPI.agreement(userSession: userSession)
                .then(dataStore.save(userSession:))
    }
    
    func readUserSession() -> Promise<UserSession?> {
        return dataStore.readUserSession()
    }
    
    
    func checkInFace(userSession: UserSession, faceStrs: [String]) -> Promise<UserSession> {
        return remoteAPI.checkInFace(userSession: userSession, faceStrs: faceStrs)
    }
    
    func loadAgreeHtml() -> Promise<String> {
        return remoteAPI.loadAgreeHtml()
    }
}
