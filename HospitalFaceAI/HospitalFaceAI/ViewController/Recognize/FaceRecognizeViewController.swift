//
//  FaceRecognizeViewController.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/16.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import RxSwift

class FaceRecognizeViewController: NiblessViewController {
    
    let disposeBag = DisposeBag()
    let viewModel: RecognizeViewModel
    
    init(viewModel: RecognizeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    override func loadView() {
        view = FacerecognizeRootView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "人脸识别"
//        //设置导航栏背景透明
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),
//                                                                    for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        setupNavi()

    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (view as! FacerecognizeRootView).stopDetect()
    }

    func setupNavi() {
        self.navigationController?.navigationBar.setTitleFont(UIFont.systemFont(ofSize: 16), color: .white)
        self.navigationController?.navigationBar.setColors(background: Color.recognizeBackground, text: .white)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //左侧按钮
        let leftButImg = #imageLiteral(resourceName: "navi")
        let leftbarButton = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(tap3(_:)), ImageNormal: (leftButImg.scaled(toHeight: 20))!, ImageSel: (leftButImg.scaled(toHeight: 14))!)
        
        //用于消除左边空隙，要不然按钮顶不到最前面
        let spacerLeft = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                         action: nil)
        spacerLeft.width = -10
        
        self.navigationItem.leftBarButtonItems = [spacerLeft, leftbarButton]
    }
    
    @objc func tap3(_ button: UIButton) {
        print("back 点击")
        viewModel.cancelDetect()
//        func wireController() {
//            recognizeButton.addTarget(viewModel, action: #selector(GuideViewModel.recognize), for: .touchUpInside)
//        }

    }
    
    deinit {
        print("--deinit---")
    }

}
