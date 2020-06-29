//
//  UserSessionDataStore.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/12.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import PromiseKit

protocol UserSessionDataStore {
    func readUserSession() -> Promise<UserSession?>
    func save(userSession: UserSession) -> Promise<UserSession>
    func delete(userSession: UserSession) -> Promise<UserSession>
}
