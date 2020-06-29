//
//  GuideRootView.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/16.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GuideRootView: NiblessView {
    let viewModel: GuideViewModel
    let disposeBag = DisposeBag()
    var hierarchyNotReady = true
    
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "guidebackground")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    lazy var loadingView: LoadingView = {
        let loadFrame = CGRect(x: (UIScreen.main.bounds.width - 200)*0.5, y: (UIScreen.main.bounds.height - 90)*0.5-30, width: 200, height: 90)
        let loadView = LoadingView(frame: loadFrame, textHint: "正在识别中")
        loadView.alpha = 0
        loadView.beginAnimation()
//        let loadView = LoadingView(textHint: "正在识别中")
        return loadView
    }()
    
//    var loadingView: LoadingView?
    
    let warnHint:UILabel = {
        let label = UILabel()
        label.text = "注意事项"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let bageView1: BageView = {
        let image = #imageLiteral(resourceName: "bage1")
        let hint = "保证光线充足"
        let bage = BageView(bageImage: image, textHint: hint)
        return bage
    }()
    
    let bageView2: BageView = {
        let image = #imageLiteral(resourceName: "bage2")
        let hint = "正脸置于识别框内"
        let bage = BageView(bageImage: image, textHint: hint)
        return bage
    }()
    
    let bageView3: BageView = {
        let image = #imageLiteral(resourceName: "bage3")
        let hint = "不能遮挡脸部"
        let bage = BageView(bageImage: image, textHint: hint)
        return bage
    }()
    
    let bageView4: BageView = {
        let image = #imageLiteral(resourceName: "bage4")
        let hint = "眼镜不能反光"
        let bage = BageView(bageImage: image, textHint: hint)
        return bage
    }()
    
    let recognizeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("开始识别", for: .normal)
        button.titleLabel?.font = Font.mainBtnFont//.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.mainButtonBackground
        button.layer.cornerRadius = CustomConfig.mainBtnRadius
        button.layer.masksToBounds = true
        return button
    }()
    
    init(frame: CGRect = .zero,
         viewModel: GuideViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        bindViewModelToViews()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
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
        viewModel.recognizeButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(recognizeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.checkInActivityIndicatorAnimating
            .subscribe(onNext: { [unowned self] valid in
                self.showCheckprocess(show: valid)
            })
            .disposed(by: disposeBag)
    }
    
    
    func constructHierarchy() {
        addSubview(topImageView)
        addSubview(contentView)
        contentView.addSubview(warnHint)
        contentView.addSubview(bageView1)
        contentView.addSubview(bageView2)
        contentView.addSubview(bageView3)
        contentView.addSubview(bageView4)
        contentView.addSubview(recognizeButton)
        addSubview(loadingView)
    }
    
    func activateConstraints() {
        activateConstraintsTopImageView()
        activateConstraintsContentView()
        activateConstraintsWarnHint()
        activateConstraintsBageViews()
        activateConstraintsRecognizeButton()
    }

    func wireController() {
        recognizeButton.addTarget(viewModel, action: #selector(GuideViewModel.recognize), for: .touchUpInside)
    }
//
//    @objc func checkButtonClicked() {
//        //        AgreeViewModel.check
//        agreeCheckButton.isSelected = !agreeCheckButton.isSelected
//        viewModel.check(isSelected: agreeCheckButton.isSelected)
//    }
    
    
    func activateConstraintsTopImageView() {
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        topImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
    }
    
    func activateConstraintsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topImageView.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func activateConstraintsWarnHint() {
        warnHint.translatesAutoresizingMaskIntoConstraints = false
        warnHint.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 25).isActive = true
        warnHint.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 15).isActive = true
        warnHint.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -15).isActive = true
        warnHint.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func activateConstraintsBageViews() {
        bageView1.translatesAutoresizingMaskIntoConstraints = false
        bageView2.translatesAutoresizingMaskIntoConstraints = false
        bageView3.translatesAutoresizingMaskIntoConstraints = false
        bageView4.translatesAutoresizingMaskIntoConstraints = false
        
        let widthBetweenSpace:CGFloat = 30.0
        let heightBetweenSpace:CGFloat = 10.0
        
        let topSpace:CGFloat = 35.0
        let leadSpace: CGFloat = 50.0
        
        let bageWidth = (UIScreen.main.bounds.size.width - 2*leadSpace - widthBetweenSpace)*0.5
        let bageHeight = bageWidth - 20
        
        bageView1.widthAnchor.constraint(equalToConstant: bageWidth).isActive = true
        bageView1.heightAnchor.constraint(equalToConstant: bageHeight).isActive = true
        bageView1.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: leadSpace).isActive = true
        bageView1.topAnchor.constraint(equalTo: warnHint.topAnchor,constant: topSpace).isActive = true
        
        bageView2.widthAnchor.constraint(equalToConstant: bageWidth).isActive = true
        bageView2.heightAnchor.constraint(equalToConstant: bageHeight).isActive = true
        bageView2.leftAnchor.constraint(equalTo: bageView1.rightAnchor,constant: widthBetweenSpace).isActive = true
        bageView2.topAnchor.constraint(equalTo: warnHint.topAnchor,constant: topSpace).isActive = true
        
        bageView3.widthAnchor.constraint(equalToConstant: bageWidth).isActive = true
        bageView3.heightAnchor.constraint(equalToConstant: bageHeight).isActive = true
        bageView3.leftAnchor.constraint(equalTo: bageView1.leftAnchor).isActive = true
        bageView3.topAnchor.constraint(equalTo: bageView1.bottomAnchor,constant: heightBetweenSpace).isActive = true
        
        bageView4.widthAnchor.constraint(equalToConstant: bageWidth).isActive = true
        bageView4.heightAnchor.constraint(equalToConstant: bageHeight).isActive = true
        bageView4.leftAnchor.constraint(equalTo: bageView3.rightAnchor,constant: widthBetweenSpace).isActive = true
        bageView4.topAnchor.constraint(equalTo: bageView3.topAnchor).isActive = true
    }
    
    func activateConstraintsRecognizeButton() {
        recognizeButton.translatesAutoresizingMaskIntoConstraints = false
        recognizeButton.leftAnchor.constraint(equalTo: warnHint.leftAnchor).isActive = true
        recognizeButton.rightAnchor.constraint(equalTo: warnHint.rightAnchor).isActive = true
        recognizeButton.heightAnchor.constraint(equalToConstant: CustomConfig.mainBtnHeight).isActive = true
        recognizeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -15).isActive = true
    }

}

extension GuideRootView {
    func showCheckprocess(show:Bool) {
        if show {
            print("检测中")
//            if (loadingView == nil) {
//                let loadFrame = CGRect(x: (UIScreen.main.bounds.width - 200)*0.5, y: (UIScreen.main.bounds.height - 90)*0.5-30, width: 200, height: 90)
//                let loadView = LoadingView(frame: loadFrame, textHint: "正在识别中")
//                self.addSubview(loadView)
//                loadView.beginAnimation()
//            }
            UIView.animate(withDuration: 0.5) { [unowned self] in
                self.loadingView.alpha = 1
            }
        }else {
            print("检测完毕")
            UIView.animate(withDuration: 0.5) { [unowned self] in
                self.loadingView.alpha = 0
            }
//            guard let loadView = loadingView else {
//                return
//            }
//            loadView.stopAnimation()
//            loadView.removeFromSuperview()
//            loadingView = nil
        }
        
    }

}
