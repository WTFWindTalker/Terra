//
//  FileUserSessionDataStore.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/16.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import PromiseKit

class FileUserSessionDataStore: UserSessionDataStore {
    
    // MARK: - Properties
    var docsURL: URL? {
        return FileManager
            .default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                          in: FileManager.SearchPathDomainMask.allDomainsMask).first
    }
    
    public init() {}
    
    func readUserSession() -> Promise<UserSession?> {
        return Promise() { seal in
            guard let docsURL = docsURL else {
                seal.reject(FaceDetectError.localJsonNotExist)
                return
            }
            guard let jsonData = try? Data(contentsOf: docsURL.appendingPathComponent("user_session.json")) else {
                seal.fulfill(nil)
                return
            }
            let decoder = JSONDecoder()
            let userSession = try! decoder.decode(UserSession.self, from: jsonData)
            seal.fulfill(userSession)
        }
    }
    
    func save(userSession: UserSession) -> Promise<UserSession> {
        return Promise() { seal in
            let encoder = JSONEncoder()
            let jsonData = try! encoder.encode(userSession)
            
            guard let docsURL = docsURL else {
                seal.reject(FaceDetectError.localJsonNotExist)
                return
            }
            try? jsonData.write(to: docsURL.appendingPathComponent("user_session.json"))
            seal.fulfill(userSession)
        }
    }
    
    func delete(userSession: UserSession) -> Promise<UserSession> {
        return Promise() { seal in
            guard let docsURL = docsURL else {
                seal.reject(FaceDetectError.localJsonNotExist)
                return
            }
            do {
                try FileManager.default.removeItem(at: docsURL.appendingPathComponent("user_session.json"))
            } catch {
                seal.reject(FaceDetectError.any)
                return
            }
            seal.fulfill(userSession)
        }
    }
    
    
}
