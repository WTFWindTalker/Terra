//
//  AgreeRootView.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/16.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WebKit
import PromiseKit

class AgreeRootView: NiblessView {
    let viewModel: AgreeViewModel
    let disposeBag = DisposeBag()
    var hierarchyNotReady = true
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        return bottomView
    }()
    
    lazy var webView: WKWebView = {
        let web = WKWebView()
//        let html = "<h1>欢迎来到:<a href='https://www.jianshu.com/u/5ab366f0368f'>Swift学习</a></h1>"
//        web.loadHTMLString(html, baseURL: nil)
        web.backgroundColor = Color.webBackground
        return web
    }()
    
    let agreeCheckButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "unChecked"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "checked"), for: .selected)
        button.setEnlargeEdge(top: 5, bottom: 5, left: 5, right: 5)
        return button
    }()
    
    let agreeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("下一步", for: .normal)
        button.titleLabel?.font = Font.mainBtnFont
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.mainButtonBackground
        button.layer.cornerRadius = CustomConfig.mainBtnRadius
        button.layer.masksToBounds  = true
        return button
    }()
    
    let agreeHint:UILabel = {
        let label = UILabel()
        label.text = "我已阅读并同意《人脸认证服务协议》"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    
    init(frame: CGRect = .zero,
         viewModel: AgreeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        bindViewModelToViews()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        UIView.animate(withDuration: 0.25) {
            self.webView.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = .white
        constructHierarchy()
        activateConstraints()
        wireController()
        hierarchyNotReady = false
        
    }
    
    func bindViewModelToViews() {
        viewModel.agreeCheckSeleted
            .asDriver(onErrorJustReturn: false)
            .drive(agreeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.agreeCheckEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(agreeCheckButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.agreeCheckSeleted
            .subscribe(onNext: { [unowned self] valid in
                self.agreeButton.alpha = valid ? 1 : 0.5
                self.agreeCheckButton.isSelected = valid
            })
            .disposed(by: disposeBag)
        
        viewModel.agreeButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(agreeButton.rx.isEnabled)
            .disposed(by: disposeBag)


        
        //根据按钮的状态创建 Observable
        
//        let agreeBtnObserver = Observable.from(optional: agreeButton.rx.isEnabled)
//        agreeBtnObserver.subscribe({ [unowned self] valid in
//            self.agreeButton.alpha = valid ? 1 : 0.5
//        }).disposed(by: disposeBag)
        
//        agreeButton.rx.isEnabled.bin
//        let agreeBtnObserver = { (element: Bool) -> Observable<Bool> in
//            return Observable.create { observer in
//                observer.onNext(element)
//                observer.onCompleted()
//                return Disposables.create()
//            }
//        }
//        agreeBtnObserver(agreeButton.isEnabled)
//            .subscribe(onNext: { [unowned self] valid in
//                self.agreeButton.alpha = valid ? 1 : 0.5
//            })
//            .disposed(by: disposeBag)
        


    }
    
    func constructHierarchy() {
        addSubview(bottomView)
        bottomView.addSubview(agreeCheckButton)
        bottomView.addSubview(agreeHint)
        bottomView.addSubview(agreeButton)
        getHtmlAgreement()
        addSubview(webView)
    }
    
    func activateConstraints() {
        activateConstraintsBottomView()
        activateConstraintsCheckButton()
        activateConstraintsAgreeHint()
        activateConstraintsAgreeButton()
        activateConstraintsWebView()
    }
    
    func wireController() {
        agreeButton.addTarget(viewModel, action: #selector(AgreeViewModel.agree), for: .touchUpInside)
        agreeCheckButton.addTarget(self, action: #selector(checkButtonClicked), for: .touchUpInside)
    }
    
//    func getAgreeH5() -> String {
//        return viewModel.loadAgreementHtml()
//    }
    func getHtmlAgreement() {
        viewModel.loadAgreementHtml()
            .done(loadHtmlWeb(html:))
            .catch({ error in
                print("出现 loadHtmlWeb 错误")
            })
    }
    
    func loadHtmlWeb(html:String) {
        let headerString : String = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>"
        webView.loadHTMLString(headerString + html, baseURL: nil)
    }
    
    @objc func checkButtonClicked() {
//        AgreeViewModel.check
        agreeCheckButton.isSelected = !agreeCheckButton.isSelected
        viewModel.check(isSelected: agreeCheckButton.isSelected)
    }
    
    
    func activateConstraintsBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 108).isActive = true
    }
    
    func activateConstraintsCheckButton() {
        agreeCheckButton.translatesAutoresizingMaskIntoConstraints = false
        agreeCheckButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor,constant: 15).isActive = true
        agreeCheckButton.topAnchor.constraint(equalTo: bottomView.topAnchor,constant: 13).isActive = true
        agreeCheckButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        agreeCheckButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func activateConstraintsAgreeHint() {
        agreeHint.translatesAutoresizingMaskIntoConstraints = false
        agreeHint.leftAnchor.constraint(equalTo: agreeCheckButton.rightAnchor,constant: 10).isActive = true
        agreeHint.topAnchor.constraint(equalTo: agreeCheckButton.topAnchor).isActive = true
        agreeHint.rightAnchor.constraint(equalTo: bottomView.rightAnchor,constant: -15).isActive = true
        agreeHint.heightAnchor.constraint(equalToConstant: 20)
    }
    
    func activateConstraintsAgreeButton() {
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        agreeButton.leftAnchor.constraint(equalTo: agreeCheckButton.leftAnchor).isActive = true
        agreeButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor,constant: -15).isActive = true
        agreeButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor,constant: -20).isActive = true
        agreeButton.heightAnchor.constraint(equalToConstant: CustomConfig.mainBtnHeight).isActive = true
    }
    
    func activateConstraintsWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
    }
}
