//
//  MessageAlertViewController.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/18.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class MessageAlertViewController: NiblessViewController {
    var hintImage: UIImage?
    let msgtitle: String
    let message: String
    
    lazy var msgContainer: UIView = {
        let containView = UIView()
        containView.backgroundColor = .white
        containView.layer.cornerRadius = 12
        containView.layer.masksToBounds = true
        return containView
    }()
    
//    lazy var leftButton: UIButton = {
//        let button = UIButton()
//        button.titleForNormal = "leftbtn"
//        button.titleColorForNormal = .black
//        return button
//    }()
//
//    lazy var rightButton: UIButton = {
//        let button = UIButton()
//        button.titleForNormal = "rightBtn"
//        button.titleColorForNormal = .black
//        return button
//    }()
    
    private var buttons = [UIButton]()
    
    lazy var hintImagView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "default_alert_hint")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let lineView: UIView = {
       let line = UIView()
        line.backgroundColor = Color.alertLine
       return line
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let msgLabel:UILabel = {
        let label = UILabel()
        label.text = "message"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    init(msgtitle: String, message: String, hintImage: UIImage?) {
        self.msgtitle = msgtitle
        self.message = message
        self.hintImage = hintImage
        super.init()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        constructHierarchy()
        
    }
    
    func addButton(button:UIButton) {
        msgContainer.addSubview(button)
        buttons.append(button)
    }
    
    private func constructHierarchy() {
        if hintImage != nil {
            constructHintImage()
        }else {
            constructNoHintImage()
        }
        view.addSubview(msgContainer)
        msgContainer.addSubview(lineView)
    }
    
    private func constructNoHintImage() {
        titleLabel.text = msgtitle
        msgLabel.text = message
        msgContainer.addSubview(titleLabel)
        msgContainer.addSubview(msgLabel)
//        msgContainer.addSubview(leftButton)
//        msgContainer.addSubview(rightButton)
        
        msgContainer.frame = CGRect(x: (UIScreen.main.bounds.width - 270)*0.5, y: (UIScreen.main.bounds.height - 136) * 0.5 - 65, width: 270, height: 136)
        titleLabel.frame = CGRect(x: 0, y: 15, width: msgContainer.frame.width, height: 25)
        msgLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY , width: msgContainer.frame.width, height: 44)
        lineView.frame = CGRect(x: 0, y: msgContainer.frame.height - 44, width: msgContainer.frame.width, height: 1)
        
//        leftButton.frame = CGRect(x: 0, y: lineView.frame.maxY, width: msgContainer.frame.width*0.5, height: 44)
//        rightButton.frame = CGRect(x: leftButton.frame.maxX, y: lineView.frame.maxY, width: msgContainer.frame.width*0.5, height: 44)
    }
    
    private func constructHintImage() {
        guard let image = hintImage else {
            return
        }
        hintImagView.image = image
        msgContainer.addSubview(hintImagView)
        titleLabel.text = msgtitle
        msgLabel.text = message
        msgContainer.addSubview(titleLabel)
        msgContainer.addSubview(msgLabel)
//        msgContainer.addSubview(leftButton)
//        msgContainer.addSubview(rightButton)
        
        msgContainer.frame = CGRect(x: (UIScreen.main.bounds.width - 270)*0.5, y: (UIScreen.main.bounds.height - 242) * 0.5 - 20, width: 270, height: 242)
        hintImagView.frame = CGRect(x: (msgContainer.frame.width - 67)*0.5, y: 20, width: 67, height: 67)
        titleLabel.frame = CGRect(x: 0, y: hintImagView.frame.maxY + 15, width: msgContainer.frame.width, height: 25)
        msgLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY , width: msgContainer.frame.width, height: 44)
        lineView.frame = CGRect(x: 0, y: msgContainer.frame.height - 44, width: msgContainer.frame.width, height: 1)
        
//        leftButton.frame = CGRect(x: 0, y: lineView.frame.maxY, width: msgContainer.frame.width*0.5, height: 44)
//        rightButton.frame = CGRect(x: leftButton.frame.maxX, y: lineView.frame.maxY, width: msgContainer.frame.width*0.5, height: 44)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard buttons.count > 0 else {
            return
        }
        let btnWidth: CGFloat = msgContainer.frame.width/CGFloat(buttons.count)
        let btnHeight: CGFloat = 44
        for (idx, btn) in buttons.enumerated() {
            btn.frame = CGRect(x: CGFloat(idx)*btnWidth, y: msgContainer.frame.height - 44, width: btnWidth, height: btnHeight)
        }
    }
}
