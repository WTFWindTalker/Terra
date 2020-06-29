//
//  MainViewController.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/11.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import RxSwift
import AVFoundation

class MainViewController: NiblessNavigationController {
    
    let viewModel: MainViewModel
    
    let disposeBag = DisposeBag()
    
    //Child View Controllers
    let loginViewController: LoginViewController //rootVC
    let agreementViewController: AgreementViewController
    let guideViewController: GuideViewController
    
    var faceRecognizeController: FaceRecognizeController?
    
    init(viewModel: MainViewModel,
         loginViewController: LoginViewController,
        agreementViewController: AgreementViewController,
        guideViewController: GuideViewController) {
        self.viewModel = viewModel
        self.loginViewController = loginViewController
        self.agreementViewController = agreementViewController
        self.guideViewController = guideViewController
        super.init()
    }
    
    override func viewDidLoad() {
        observeViewModel()
        setupNavi()
    }
    
    private func observeViewModel() {
        subscribe(to: viewModel.view)
    }
    
    private func setupNavi() {
        navigationBar.setTitleFont(Font.naviTitleFont, color: .black)
        navigationBar.setColors(background: .white, text: .black)
        navigationBar.shadowImage = UIImage()
    }
    
    
    private func subscribe(to observable: Observable<MainView>) {
        observable
            .subscribe(onNext: { [weak self] view in
                guard let strongSelf = self else { return }
                strongSelf.present(view)
            })
            .disposed(by: disposeBag)
    }
    
    private func present(_ view: MainView) {
        switch view {
        case .login:
            print("login")
            goLoginVC()
//            goDetectSuccess()
        case .agree:
            print("agree")
            goAgreeVC()
        case .guide:
            print("guide")
            goGuideVC()
        case .recognize:
            print("gorecognize")
            goRecognizeVC()
        case .checkface:
            print("checkface")
            dismissRecognizeVC()
        case .cancelCheck:
            dismissRecognizeVC()
        case .checkSuccess:
            goDetectSuccess()
        }
    }
    
    private func goLoginVC() {
        pushViewController(loginViewController, animated: false)
//        test()
    }
    
    private func goAgreeVC() {
        pushViewController(agreementViewController, animated: true)
    }
    
    private func goGuideVC() {
        pushViewController(guideViewController, animated: true)

    }
    
    private func goRecognizeVC() {
        let viewModel = RecognizeViewModel(facepicStringResponser: guideViewController.viewModel)
        let recogVC = FaceRecognizeController(contentViewController: FaceRecognizeViewController(viewModel: viewModel))
        faceRecognizeController = recogVC
        
        guard cameraAuthorization() else {
            return
        }
        present(recogVC, animated: true, completion: nil)
    
    }
    
    private func cameraAuthorization() -> Bool{
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == AVAuthorizationStatus.restricted || status == AVAuthorizationStatus.denied {
            showAlert()
            return false
        }else {
            return true
        }
    }
    
    private func showAlert() {
        let alertVC = MessageAlertViewController(msgtitle: "没有相机权限", message: "请开启设备相机权限", hintImage: nil)
        
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
    
    private func dismissRecognizeVC() {
        guard let recognVC = faceRecognizeController else {
            return
        }
        recognVC.dismiss(animated: true, completion: nil)
    }
    
    private func goDetectSuccess() {
        let successVC = DetectSuccessViewController()
        pushViewController(successVC, animated: true)
    }
    
    private func test() {
        
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        vc.title = "Test"
        
        let nameField = UITextField()
        nameField.placeholder = "请输入身份证号码"
        nameField.textColor = .black
        nameField.backgroundColor = .white //Color.background
        let nameHint = UILabel()
        nameHint.text = "姓名"
        nameHint.font = UIFont.systemFont(ofSize: 16)
        nameHint.textColor = .black
        
        let nameInputStack = UIStackView(arrangedSubviews: [nameHint, nameField])
        nameInputStack.axis = .horizontal
        
        nameInputStack.frame =  CGRect(x: 60, y: 80, width: 280, height: 60)
        vc.view.addSubview(nameInputStack)
        pushViewController(vc, animated: false)

    }

}
