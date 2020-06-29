/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import UIKit
import RxSwift
//enum AlertType {
//    case noPic
//    case hitPic
//}

extension UIViewController {
//
//  // MARK: - Methods
//  func present(errorMessage: ErrorMessage) {
//
//    let image = #imageLiteral(resourceName: "default_alert_hint")
//    let messageVC = MessageAlertViewController(msgtitle: errorMessage.title, message: errorMessage.message, hintImage: image)
//    messageVC.modalPresentationStyle = .overCurrentContext
//    self.modalPresentationStyle = .currentContext
//
//    let button1 = UIButton()
//    button1.titleForNormal = "rightBtn"
//    button1.titleColorForNormal = .black
//
//    let button2 = UIButton()
//    button2.titleForNormal = "rightBtn"
//    button2.titleColorForNormal = .black
//
//    button1.addTouchUpInSideBtnAction { _ in
//        print("!!!rightBtn!!! clicked")
//    }
//
//    button2.addTouchUpInSideBtnAction { _ in
//        print("dismiss clicked")
//        messageVC.dismiss(animated: false, completion: nil)
//    }
//
//    messageVC.addButton(button: button1)
//    messageVC.addButton(button: button2)
//    present(messageVC, animated: false, completion: nil)
//  }
//
//      func present(errorMessage: ErrorMessage,
//                          withPresentationState errorPresentation: BehaviorSubject<ErrorPresentation?>) {
//        errorPresentation.onNext(.presenting)
//        let errorAlertController = MessageAlertViewController(msgtitle: errorMessage.title, message: errorMessage.message, hintImage: nil)
//        errorAlertController.modalPresentationStyle = .overCurrentContext
//        self.modalPresentationStyle = .currentContext
//
//        let button1 = UIButton()
//        button1.titleForNormal = "rightBtn"
//        button1.titleColorForNormal = .black
//        button1.addTouchUpInSideBtnAction { _ in
//            print("Btn clicked")
//            errorPresentation.onNext(.dismissed)
//            errorPresentation.onNext(nil)
//        }
//
//        errorAlertController.addButton(button: button1)
//        present(errorAlertController, animated: true, completion: nil)
//      }
//
//    func present(errorMessage: ErrorMessage,
//                 withAlertType alertType: AlertType,
//                 alertBtns buttons:[UIButton],
//                 alertController alertVC: MessageAlertViewController) {
////        var alertController: MessageAlertViewController!
////        let hitImage = #imageLiteral(resourceName: "default_alert_hint")
////        switch alertType {
////            case .noPic:
////            alertController =  MessageAlertViewController(msgtitle: errorMessage.title, message: errorMessage.message, hintImage: nil)
////            case .hitPic:
////            alertController =  MessageAlertViewController(msgtitle: errorMessage.title, message: errorMessage.message, hintImage: hitImage)
////        }
//        alertVC.modalPresentationStyle = .overCurrentContext
//        self.modalPresentationStyle = .currentContext
//
////        let button1 = UIButton()
////        button1.titleForNormal = "退出"
////        button1.titleColorForNormal = .darkGray
////        button1.addTouchUpInSideBtnAction { _ in
////            print("Btn clicked")
////        }
////
////        let button2 = UIButton()
////        button2.titleForNormal = "重试"
////        button2.titleColorForNormal = Color.alertBtnBlue
////        button2.addTouchUpInSideBtnAction { _ in
////            print("Btn clicked")
////        }
//
////        switch alertType {
////        case .noPicOneBtn,.noPicTwoBtn:
////            alertController =  MessageAlertViewController(msgtitle: errorMessage.title, message: errorMessage.message, hintImage: nil)
////        case .picOneBtn, .picTwoBtn:
////            alertController =  MessageAlertViewController(msgtitle: errorMessage.title, message: errorMessage.message, hintImage: hitImage)
////        }
//
//        for btn in buttons {
//            alertVC.addButton(button: btn)
//        }
//
//        present(alertVC, animated: false, completion: nil)
//    }
//
//    func present(errorMessage: ErrorMessage,
//                 withPresentationState errorPresentation: BehaviorSubject<ErrorPresentation?>,
//                 withAlertType alertType: AlertType) {
//        errorPresentation.onNext(.presenting)
//        let errorAlertController = MessageAlertViewController(msgtitle: errorMessage.title, message: errorMessage.message, hintImage: nil)
//        errorAlertController.modalPresentationStyle = .overCurrentContext
//        self.modalPresentationStyle = .currentContext
//
//        let button1 = UIButton()
//        button1.titleForNormal = "rightBtn"
//        button1.titleColorForNormal = .black
//        button1.addTouchUpInSideBtnAction { _ in
//            print("Btn clicked")
//            errorPresentation.onNext(.dismissed)
//            errorPresentation.onNext(nil)
//        }
//
//        errorAlertController.addButton(button: button1)
//        present(errorAlertController, animated: true, completion: nil)
//    }
    
    

}
