//
//  DetectSuccessViewController.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/20.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class DetectSuccessViewController: UIViewController {
    
    lazy var midMsgContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleHint:UILabel = {
        let label = UILabel()
        label.text = "认证成功"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let msgHint:UILabel = {
        let label = UILabel()
        label.text = "您已通过实名认证"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    let hintImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "successhint")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let finishedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("完成", for: .normal)
        button.titleLabel?.font = Font.mainBtnFont//.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.mainButtonBackground
        button.addTarget(self, action: #selector(backTaped), for: .touchUpInside)
        button.layer.cornerRadius = CustomConfig.mainBtnRadius
        button.layer.masksToBounds = true
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupNavi()
        constructHierarchy()
        activateConstraints()
    }
    
    private func setupNavi() {
        self.title = "认证结果"
        self.navigationItem.backBarButtonItem?.addTargetForAction(self, action: #selector(backTaped))
//        self.navigationController?.navigationBar.delegate = self as! UINavigationBarDelegate//
//        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        navigationItem.backBarButtonItem = item
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,
                                         action: #selector(backTaped))
        leftBarBtn.image = #imageLiteral(resourceName: "navi-black")

        //用于消除左边空隙，要不然按钮顶不到最前面
//        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
//                                     action: nil)
//        spacer.width = -10
//
//        self.navigationItem.leftBarButtonItems = [spacer, leftBarBtn]
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }

    private func constructHierarchy() {
        view.addSubview(midMsgContainer)
        midMsgContainer.addSubview(hintImageView)
        midMsgContainer.addSubview(titleHint)
        midMsgContainer.addSubview(msgHint)
        view.addSubview(finishedButton)
    }
    
    private func activateConstraints() {
        finishedButton.translatesAutoresizingMaskIntoConstraints = false
        finishedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -160).isActive = true
        finishedButton.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 15).isActive = true
        finishedButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -15).isActive = true
        finishedButton.heightAnchor.constraint(equalToConstant: CustomConfig.mainBtnHeight).isActive = true
        
        midMsgContainer.translatesAutoresizingMaskIntoConstraints = false
        midMsgContainer.topAnchor.constraint(equalTo: view.topAnchor,constant: 102).isActive = true
        midMsgContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        midMsgContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        midMsgContainer.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        hintImageView.translatesAutoresizingMaskIntoConstraints = false
        hintImageView.widthAnchor.constraint(equalToConstant: 105).isActive = true
        hintImageView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        hintImageView.centerXAnchor.constraint(equalTo: midMsgContainer.centerXAnchor).isActive = true
        hintImageView.topAnchor.constraint(equalTo: midMsgContainer.topAnchor).isActive = true
        
        titleHint.translatesAutoresizingMaskIntoConstraints = false
        titleHint.topAnchor.constraint(equalTo: hintImageView.bottomAnchor,constant: 25).isActive = true
        titleHint.leftAnchor.constraint(equalTo: midMsgContainer.leftAnchor).isActive = true
        titleHint.rightAnchor.constraint(equalTo: midMsgContainer.rightAnchor).isActive = true
        titleHint.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        msgHint.translatesAutoresizingMaskIntoConstraints = false
        msgHint.topAnchor.constraint(equalTo: titleHint.bottomAnchor,constant: 8).isActive = true
        msgHint.leftAnchor.constraint(equalTo: titleHint.leftAnchor).isActive = true
        msgHint.rightAnchor.constraint(equalTo: titleHint.rightAnchor).isActive = true
        msgHint.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    @objc private func backTaped() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}

//extension UINavigationController: UINavigationBarDelegate {
//    
//    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
//        print("go root")
////        if (self.navigationController?.viewControllers.count ?? 0) < (navigationBar.items?.count ?? 0) {
////            return true
////        }
//        if ((topViewController as? DetectSuccessViewController) != nil) {
//            print("top vc = DetectSuccessViewController")
//            popToRootViewController(animated: true)
//            return true
//        }else {
//            print("top vc =  not DetectSuccessViewController")
//            popViewController(animated: true)
//            return true
//        }
////        self.navigationController?.topViewController  ==
////        DispatchQueue.main.async() {
////            self.navigationController?.popToRootViewController(animated: true)
////        }
////        return false
//        return true
//    }
//    
////    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
////        print("did go root")
////    }
//}
