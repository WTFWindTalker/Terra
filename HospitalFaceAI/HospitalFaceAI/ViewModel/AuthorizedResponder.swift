//
//  AuthorizedResponder.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/12.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation

protocol AuthorizedResponder {
    func authorized(to userSession: UserSession)
//    func unAuthorized()
}
