//
//  GuideViewModel.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/16.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import RxSwift

class GuideViewModel: FacepicStringResponser {
    
    let userSessionRepository: UserSessionRepository
    let recognizefaceResponder: RecognizefaceResponder
    
    init(userSessionRepository: UserSessionRepository,recognizefaceResponder: RecognizefaceResponder) {
        self.userSessionRepository = userSessionRepository
        self.recognizefaceResponder = recognizefaceResponder
    }
    
    var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObserver()
    }
    let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
//    var successMessages: Observable<ErrorMessage> {
//        return successMessagesSubject.asObserver()
//    }
//    let successMessagesSubject = PublishSubject<ErrorMessage>()
    
    let recognizeButtonEnabled = BehaviorSubject<Bool>(value: true)
    let checkInActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    
    @objc func recognize() {
        print("beginRecognize")
        recognizeButtonEnabled.onNext(false)
        loadUserSession()
    }
    
    
    func loadUserSession(){
        userSessionRepository.readUserSession()
            .done(goFaceCheck(userSession:))
            .catch({ error in
                print("出现 loadUserSession 错误")
            })
    }
    
    func goFaceCheck(userSession: UserSession?) {
        print("goFaceCheckbefore: \(String(describing: userSession))")
        
        switch userSession {
        case .none:
            print("no userSession")
        case .some(let userSession):
            let name = userSession.userInfo.name
            let idCard = userSession.userInfo.idCard
            recognizefaceResponder.recognizeFace(name: name, idCard: idCard)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [unowned self] in
                self.recognizeButtonEnabled.onNext(true)
            }
            
        }
    }
    
    func fetchFacePicString(facepicStrings: [String]) {
        print("go fetchFacePicString")
        recognizefaceResponder.checkface(imagestrs: facepicStrings)
        indicateCheckIn()
        userSessionRepository.readUserSession()
            .done({ [unowned self] session in
                self.goCheckFace(faceStrs: facepicStrings, userSession: session)
            })
            .catch(fetchError)
    }
    
    func cancelFaceFetch() {
        recognizefaceResponder.cancleCheck()
        checkInDone()
    }

    
    func goCheckFace(faceStrs: [String],userSession: UserSession?) {
        guard let session = userSession else {
            print("处理userSession 错误")
            return
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [unowned self] in
            self.userSessionRepository.checkInFace(userSession: session, faceStrs: faceStrs)
                .done(self.fetchCheckResult(userSession:))
                .catch(self.fetchError)
        }

    }
    
    func indicateCheckIn() {
        checkInActivityIndicatorAnimating.onNext(true)
        recognizeButtonEnabled.onNext(false)
    }
    
    func checkInDone() {
        checkInActivityIndicatorAnimating.onNext(false)
        recognizeButtonEnabled.onNext(true)
    }
    
    func fetchCheckResult(userSession: UserSession) {
        checkInDone()
        showSuccess()
    }
    
    func showSuccess() {
//        successMessagesSubject.onNext(ErrorMessage(title: "识别成功",
//                                                 message: "人脸比对成功"))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [unowned self] in
            self.recognizefaceResponder.checkSuccess()
        }
    }
    func fetchError(_ error: Error) {
        checkInDone()
        let msgTitle: String = "识别失败"
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
                msg = "服务器繁忙"
            }
        }
        
        errorMessagesSubject.onNext(ErrorMessage(title: msgTitle,
                                                 message: msg))

    }
    
}
