//
//  MainViewModel.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/11.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel: AuthorizedResponder,RecognizefaceResponder {
    
    var view: Observable<MainView> { return viewSubject.asObservable() }
    private let viewSubject = BehaviorSubject<MainView>(value: .login)
    public init() {}
    
    func authorized(to userSession: UserSession) {
        print(print("agreementSessionafter: \(String(describing: userSession))"))
        if userSession.authorized {
            viewSubject.onNext(.guide)
        }else {
            viewSubject.onNext(.agree)
        }
        
    }
    
    func recognizeFace(name: String, idCard: String) {
        viewSubject.onNext(.recognize)
    }
    
    func checkface(imagestrs: [String]) {
        viewSubject.onNext(.checkface)
    }
    
    func cancleCheck() {
        viewSubject.onNext(.cancelCheck)
    }
    
    func checkSuccess() {
        viewSubject.onNext(.checkSuccess)
    }
    
//    func unAuthorized() {
//        viewSubject.onNext(.agree)
//    }
}
