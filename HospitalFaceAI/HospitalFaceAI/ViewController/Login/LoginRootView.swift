//
//  LoginRootView.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/12.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginRootView: NiblessView {
    let viewModel: LoginViewModel
    let disposeBag = DisposeBag()
    var hierarchyNotReady = true
    var bottomLayoutConstraint: NSLayoutConstraint?
    
    let scrollView: UIScrollView = UIScrollView()
    let contentView: UIView = UIView()
    
    private var keyBoardStatus: Bool = false
    private var keyboardFrame: CGRect = .zero
    lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "topbackImg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.text = "请确认您的身份信息"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameInputStack,
            idCardInputStack
            ])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    lazy var nameInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameHint, nameField])
        stack.axis = .horizontal
        return stack
    }()
    
    let nameHint:UILabel = {
        let label = UILabel()
        label.text = "    姓名"
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return label
    }()
    
    let nameField: CustomTextField = {
        let field = CustomTextField()
        field.placeholder = "请输入姓名"
        field.backgroundColor = .white //Color.background
        field.textColor = .black
//        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.textAlignment = .right
        return field
    }()
    
    lazy var idCardInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [idcardHint, idcardField])
        stack.axis = .horizontal
        return stack
    }()

    let idcardHint:UILabel = {
        let label = UILabel()
        label.text = "    身份证"
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return label
    }()
    
    let idcardField: CustomTextField = {
        let field = CustomTextField()
        field.placeholder = "请输入身份证号码"
//        field.isSecureTextEntry = true
        field.textColor = .black
        field.backgroundColor = .white //Color.background
        field.textAlignment = .right
        return field
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("实名认证", for: .normal)
        button.titleLabel?.font = Font.mainBtnFont
        button.titleColorForNormal = .white
        button.backgroundColor = Color.mainButtonBackground
        button.layer.cornerRadius = CustomConfig.mainBtnRadius
        button.layer.masksToBounds = true
        return button
    }()
    
    let logInActivityIndicator: UIActivityIndicatorView  = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(frame: CGRect = .zero,
         viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        bindTextFieldsToViewModel()
        bindViewModelToViews()
    }
    
    func bindTextFieldsToViewModel() {
        bindNameField()
        bindidCardField()
    }
    
    func bindNameField() {
        nameField.rx.text
            .asDriver()
            .map{ $0 ?? "" }
            .drive(viewModel.nameInput)
            .disposed(by: disposeBag)
    }
    
    func bindidCardField() {
        idcardField.rx.text
            .asDriver()
            .map{ $0 ?? "" }
            .drive(viewModel.idCardInput)
            .disposed(by: disposeBag)
        
        idcardField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                // 获取非选中状态文字范围
                let selectedRange = self.idcardField.markedTextRange
                // 没有非选中文字，截取多出的文字
                if selectedRange == nil {
                    let text = self.idcardField.text ?? ""
                    if text.count > 18 {
                        let index = text.index(text.startIndex, offsetBy: 18)
                        self.idcardField.text = String(text[..<index])
                    }
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = Color.loginBackground
//        contentView.backgroundColor = .red
//        scrollView.backgroundColor = .yellow
        inputStack.backgroundColor = .blue
        
//        scrollView.isScrollEnabled = false
        constructHierarchy()
        activateConstraints()
        wireController()
//        test()
        hierarchyNotReady = false
        if logInButton.isEnabled {
            print("loginButton is enabled")
        }else {
            print("loginButton is not enabled")
        }
    }
    
    func constructHierarchy() {
        addSubview(backImageView)
        scrollView.addSubview(contentView)
        contentView.addSubview(hintLabel)
        contentView.addSubview(inputStack)
        contentView.addSubview(logInButton)
        logInButton.addSubview(logInActivityIndicator)
        addSubview(scrollView)
    }
    
    func activateConstraints() {
        activateConstraintsBackgroundView()
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsHintLabel()
        activateConstraintsInputStack()
        activateConstraintsLogInButton()
        activateConstraintsLoginInActivityIndicator()
    }
    
    func wireController() {
        logInButton.addTarget(viewModel,
                               action: #selector(LoginViewModel.login),
                               for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(taped))
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(tap)
    }
    @objc func taped() {
        self.endEditing(true)
    }
    
    func configureViewAfterLayout() {
        if keyBoardStatus {
            showKeyBoard()
        }else {
            resetkeyBoard()
        }
        
    }

    
    func setKeyBoardStatus(status: Bool, keyboardFrame: CGRect) {
        keyBoardStatus = status
        if status {//show
            showKeyBoard()
        }else {//hide
            resetkeyBoard()
        }
    }
    
    func resetkeyBoard() {
        let scrollViewBounds = scrollView.bounds
        if UIDevice().isFullScreen {
            scrollView.contentInset = UIEdgeInsets(top: scrollViewBounds.size.height - 380, left: 0, bottom: 0, right: 0)
        }else {
            scrollView.contentInset = UIEdgeInsets(top: scrollViewBounds.size.height - 300, left: 0, bottom: 0, right: 0)
        }

    }
    
    func showKeyBoard() {
        let scrollViewBounds = scrollView.bounds
        if UIDevice().isFullScreen {
            scrollView.contentInset = UIEdgeInsets(top: scrollViewBounds.size.height - 510, left: 0, bottom: 0, right: 0)
        }else {
            scrollView.contentInset = UIEdgeInsets(top: scrollViewBounds.size.height - 430, left: 0, bottom: 0, right: 0)
        }

    }

}

// MARK: - Layout
extension LoginRootView {
    func activateConstraintsBackgroundView() {
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        backImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        backImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backImageView.heightAnchor.constraint(equalToConstant: 273).isActive = true
    }
    
    func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    func activateConstraintsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func activateConstraintsHintLabel() {
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        hintLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 15).isActive = true
        hintLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -15).isActive = true
    }
    
    func activateConstraintsInputStack() {
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        inputStack.topAnchor.constraint(equalTo: hintLabel.bottomAnchor,constant: 10).isActive = true
        inputStack.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        inputStack.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    func activateConstraintsLogInButton() {
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.topAnchor.constraint(equalTo: inputStack.bottomAnchor,constant: 20).isActive = true
        logInButton.leftAnchor.constraint(equalTo: hintLabel.leftAnchor).isActive = true
        logInButton.rightAnchor.constraint(equalTo: hintLabel.rightAnchor).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: CustomConfig.mainBtnHeight).isActive = true
        contentView.bottomAnchor.constraint(equalTo: logInButton.bottomAnchor).isActive = true
    }
    
    func activateConstraintsLoginInActivityIndicator() {
        logInActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        logInActivityIndicator.centerXAnchor.constraint(equalTo: logInButton.centerXAnchor).isActive = true
        logInActivityIndicator.centerYAnchor.constraint(equalTo: logInButton.centerYAnchor).isActive = true
        
    }
}

extension LoginRootView {
    func bindViewModelToViews() {
        bindViewModelToNameField()
        bindViewModelToIdCardField()
        bindViewModelToLogInButton()
        bindViewModelToLogInActivityIndicator()
    }
    
    func bindViewModelToNameField() {
        viewModel
            .nameInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(nameField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToIdCardField() {
        viewModel
            .idCardInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(idcardField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToLogInButton() {
        viewModel
            .logInButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(logInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let nameValid: Observable = nameField.rx.text.orEmpty.map { value in
            return value.count > 0
        }
        
        let idcardValid: Observable = idcardField.rx.text.orEmpty.map { value in
            return value.count > 0
        }
        
        //登录按钮的可用与否
        let loginObserver = Observable.combineLatest(nameValid,idcardValid){(name,idcard) in
            name && idcard
        }
        
        //绑定按钮
        loginObserver.bind(to: logInButton.rx.isEnabled).disposed(by: disposeBag)
        loginObserver.subscribe(onNext: { [unowned self] valid in
            self.logInButton.alpha = valid ? 1 : 0.5
        }).disposed(by: disposeBag)
    }
    
    func bindViewModelToLogInActivityIndicator() {
        viewModel
            .logInActivityIndicatorAnimating
            .asDriver(onErrorJustReturn: false)
            .drive(logInActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
