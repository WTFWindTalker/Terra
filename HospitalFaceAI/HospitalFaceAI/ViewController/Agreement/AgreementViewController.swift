//
//  AgreementViewController.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/11.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import RxSwift
import PromiseKit

class AgreementViewController: NiblessViewController {
    let disposeBag = DisposeBag()
    let viewModel: AgreeViewModel
    
    init(viewModel: AgreeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = AgreeRootView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "协议签署"
        observeErrorMessages()
//        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        navigationItem.backBarButtonItem = item
        setupBackButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.agreeCheckSeleted.onNext(false)
        viewModel.agreeCheckEnabled.onNext(true)
        viewModel.agreeButtonEnabled.onNext(false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
