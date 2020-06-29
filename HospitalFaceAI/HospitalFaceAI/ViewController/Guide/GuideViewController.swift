//
//  GuideViewController.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/12.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import RxSwift
import PromiseKit

class GuideViewController: NiblessViewController {
    let disposeBag = DisposeBag()
    let viewModel: GuideViewModel
    
    init(viewModel: GuideViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = GuideRootView(viewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let naviVCs = self.navigationController?.viewControllers.filter {
            return !($0 is AgreementViewController)
        }
        self.navigationController?.viewControllers = naviVCs!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "人脸识别"
        observeErrorMessages()
//        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        navigationItem.backBarButtonItem = item
        setupBackButton()
        
    }
    override func navigationShouldPopMethod() -> Bool {
        print("执行返回操作")
        self.navigationController?.popToRootViewController(animated: true)
        return false
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
//    func observeMessages() {
//        observeErrorMessages()
//        observeSuccessMessages()
//    }
//    
//    func observeSuccessMessages() {
//        viewModel
//            .successMessages
//            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
//            .drive(onNext: { [weak self] errorMessage in
//                //                self?.present(errorMessage: errorMessage)
//                self?.showSuccess(errorMessage: errorMessage)
//            })
//            .disposed(by: disposeBag)
//    }
//
    
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
        let hintImge = #imageLiteral(resourceName: "default_alert_hint")
        let alertVC = MessageAlertViewController(msgtitle: errorMessage.title, message: errorMessage.message, hintImage: hintImge)
        
        let button1 = UIButton()
        button1.titleForNormal = "退出"
        button1.titleColorForNormal = .darkGray
        button1.addTouchUpInSideBtnAction { [unowned self] _ in
            print("退出")
            alertVC.dismiss(animated: false, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        let button2 = UIButton()
        button2.titleForNormal = "重试"
        button2.titleColorForNormal = Color.alertBtnBlue
        button2.addTouchUpInSideBtnAction { [unowned self] _ in
            print("重试")
            alertVC.dismiss(animated: false, completion: nil)
            self.viewModel.recognize()
        }
        
        alertVC.modalPresentationStyle = .overCurrentContext
        self.modalPresentationStyle = .currentContext
        
        alertVC.addButton(button: button1)
        alertVC.addButton(button: button2)
        present(alertVC, animated: false, completion: nil)
    }
    
}

