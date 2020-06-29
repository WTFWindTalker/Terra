//
//  AgreeViewModel.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/16.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class AgreeViewModel {
    let userSessionRepository: UserSessionRepository
    let authorizedResponder: AuthorizedResponder
    
    init(userSessionRepository: UserSessionRepository,authorizedResponder: AuthorizedResponder) {
        self.userSessionRepository = userSessionRepository
        self.authorizedResponder = authorizedResponder
    }
    var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObserver()
    }
    let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    let agreeCheckSeleted = BehaviorSubject<Bool>(value: false)
    let agreeCheckEnabled = BehaviorSubject<Bool>(value: true)
    let agreeButtonEnabled = BehaviorSubject<Bool>(value: false)
    
    @objc func agree() {
        indicateAgreed()
//        loadUserSession()
        takeAgreement()
    }
    
    @objc func check(isSelected: Bool) {
//        if isSelected {
//            print("checked")
//        }else {
//            print("unChecked")
//        }
        
        agreeCheckSeleted.onNext(isSelected)
//        agreeCheckEnabled.onNext(isSelected)
        
    }
    
    func loadAgreementHtml() -> Promise<String> {
        return userSessionRepository.loadAgreeHtml()
    }
    
    
    func takeAgreement() {
        userSessionRepository.readUserSession()
            .done(goAgreement(userSession:))
            .catch(indicateErrorAgree)
    }
    
//    func loadUserSession(){
//        userSessionRepository.readUserSession()
//            .done(goAgreement(userSession:))
//            .catch({ error in
//                print("出现 loadUserSession 错误")
//            })
//    }
//
    func goAgreement(userSession: UserSession?) {
        print("agreementSessionbefore: \(String(describing: userSession))")
        switch userSession {
        case .none:
            print("no userSession")
        case .some(let userSession):
            userSessionRepository.agreement(userSession: userSession)
                .done(authorizedResponder.authorized(to:))
                .catch(indicateErrorAgree)
        }
    }
    
    func indicateAgreed() {
        agreeCheckEnabled.onNext(false)
        agreeButtonEnabled.onNext(false)
    }
    
    func indicateErrorAgree(_ error: Error) {
        let msgTitle: String = "签约失败"
        var msg: String = "网络不可用"
        if let theError = error as? FaceDetectError {
            switch theError {
            case .any:
                print("anyError")
                msg = "未知原因"
            case .remoteError(let message):
                print("签约失败:\(message)")
                msg = message
            case .localJsonNotExist:
                print("localJsonNotExist")
                msg = "本地错误"
            case .httpError:
                print("httperror")
                msg = "网络错误"
            }
        }
        
        errorMessagesSubject.onNext(ErrorMessage(title: msgTitle,
                                                 message: msg))
        agreeCheckEnabled.onNext(true)
        agreeCheckSeleted.onNext(false)
    }
}
