//
//  LoginViewController.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/11.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import RxSwift
import PromiseKit

class LoginViewController: NiblessViewController {
    let disposeBag = DisposeBag()
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = LoginRootView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "实名认证"
        observeErrorMessages()
        setupBackButton()
    }
    
    func testFaceAI() {
        let testImg = UIImage(named: "facetest2.png")
        guard let image = testImg else {
            print("没有找到test图片")
            return
        }
        let modelDataHandler = ModelDataHandler(modelFileInfo: FaceNet.modelInfo)
        let result = modelDataHandler?.runModelWithImage(onImage: image)
        if result != nil {
            print("有脸")
        }else {
            print("无脸")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (view as! LoginRootView).configureViewAfterLayout()
    }
    
    func observeErrorMessages() {
        viewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
//                self?.present(errorMessage: errorMessage)
                self?.showAlert(errorMessage: errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    func showAlert(errorMessage:ErrorMessage) {
        let alertVC = MessageAlertViewController(msgtitle: errorMessage.title, message: errorMessage.message, hintImage: nil)
        
        let button1 = UIButton()
        button1.titleForNormal = "确定"
        button1.titleColorForNormal = Color.alertBtnBlue
        button1.addTouchUpInSideBtnAction { _ in
            print("dasdad addTouchUpInSideBtnAction")
            alertVC.dismiss(animated: false, completion: nil)
        }
        
        alertVC.modalPresentationStyle = .overCurrentContext
        self.modalPresentationStyle = .currentContext

        alertVC.addButton(button: button1)
        present(alertVC, animated: false, completion: nil)
    }
}

extension LoginViewController {
    
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                print("键盘隐藏")
//                (view as! LoginRootView).moveContentForDismissedKeyboard()
                (view as! LoginRootView).setKeyBoardStatus(status: false,keyboardFrame: convertedKeyboardEndFrame)
            }
            
            if notification.name == UIResponder.keyboardWillShowNotification {
                print("键盘显示")
//                (view as! LoginRootView).moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
                (view as! LoginRootView).setKeyBoardStatus(status: true,keyboardFrame: convertedKeyboardEndFrame)
            }
        }
    }

}
