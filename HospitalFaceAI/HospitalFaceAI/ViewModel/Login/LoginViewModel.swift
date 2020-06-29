//
//  LoginViewModel.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/12.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    let userSessionRepository: UserSessionRepository
    let authorizedResponder: AuthorizedResponder
    
    init(userSessionRepository: UserSessionRepository,authorizedResponder: AuthorizedResponder) {
        self.userSessionRepository = userSessionRepository
        self.authorizedResponder = authorizedResponder
    }
    
    let nameInput = BehaviorSubject<String>(value: "")
    let idCardInput = BehaviorSubject<String>(value: "")
    
    var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObserver()
    }
    let errorMessagesSubject = PublishSubject<ErrorMessage>()
//    let errorPresentation: BehaviorSubject<ErrorPresentation?> =
//        BehaviorSubject(value: nil)
    
    let nameInputEnabled = BehaviorSubject<Bool>(value: true)
    let idCardInputEnabled = BehaviorSubject<Bool>(value: true)
    let logInButtonEnabled = BehaviorSubject<Bool>(value: true)
    let logInActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    
    @objc
    func login() {
        indicateSigningIn()
        let (name, idCard) = getUserInfo()
        userSessionRepository.login(name: name, idCard: idCard)
            .done(loginSuccess(to:))
            .catch(indicateErrorLogIn)
    }
    
    func indicateSigningIn() {
        nameInputEnabled.onNext(false)
        idCardInputEnabled.onNext(false)
        logInButtonEnabled.onNext(false)
        logInActivityIndicatorAnimating.onNext(true)
    }
    
    func getUserInfo() -> (String, String) {
        do {
            let name = try nameInput.value()
            let idCard = try idCardInput.value()
            return (name, idCard)
        } catch {
            fatalError("Error reading email and password from behavior subjects.")
        }
    }
    
    func loginSuccess(to userSession: UserSession) {
        authorizedResponder.authorized(to:userSession)
        nameInputEnabled.onNext(true)
        idCardInputEnabled.onNext(true)
        logInButtonEnabled.onNext(true)
        logInActivityIndicatorAnimating.onNext(false)
    }
    
    func indicateErrorLogIn(_ error: Error) {
        let msgTitle: String = "验证失败"
        var msg: String = "网络不可用"
        if let theError = error as? FaceDetectError {
            switch theError {
            case .any:
                print("anyError")
                msg = "未知原因"
            case .remoteError(let message):
                print("服务器错误\(message)")
                msg = message
            case .localJsonNotExist:
                print("localJsonNotExist")
                msg = "本地错误"
            case .httpError:
                print("httperror")
                msg = "网络不可用"
            }
        }

        errorMessagesSubject.onNext(ErrorMessage(title: msgTitle,
                                                 message: msg))
        
        nameInputEnabled.onNext(true)
        idCardInputEnabled.onNext(true)
        logInButtonEnabled.onNext(true)
        logInActivityIndicatorAnimating.onNext(false)
    }
}
