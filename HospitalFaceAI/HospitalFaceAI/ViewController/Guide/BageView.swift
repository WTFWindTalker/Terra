//
//  BageView.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/16.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class BageView: NiblessView{
    let bageImage: UIImage
    let textHint: String
    
    var hierarchyNotReady = true
    lazy var bageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()
    
    let textHintLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    init(frame: CGRect = .zero,bageImage: UIImage,textHint: String) {
        self.bageImage = bageImage
        self.textHint = textHint
        super.init(frame: frame)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = .white
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false
    }
    
    
    func constructHierarchy() {
        addSubview(bageImageView)
        addSubview(textHintLabel)
        textHintLabel.text = textHint
        bageImageView.image = bageImage
    }
    
    func activateConstraints() {
        bageImageView.translatesAutoresizingMaskIntoConstraints = false
        bageImageView.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -60).isActive = true
        bageImageView.heightAnchor.constraint(equalTo: self.widthAnchor,constant: -60).isActive = true
        bageImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 6).isActive = true
        bageImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 30).isActive = true
        
        textHintLabel.translatesAutoresizingMaskIntoConstraints = false
        textHintLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textHintLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        textHintLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textHintLabel.topAnchor.constraint(equalTo: bageImageView.bottomAnchor,constant: 10).isActive = true
    }
}
