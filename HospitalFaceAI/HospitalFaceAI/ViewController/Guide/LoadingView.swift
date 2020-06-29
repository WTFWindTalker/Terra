//
//  LoadingView.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/19.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class LoadingView: NiblessView{
    let textHint: String
    
    var hierarchyNotReady = true
    let activityIndicator: UIActivityIndicatorView  = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let textHintLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    init(frame: CGRect = .zero,textHint: String) {
        self.textHint = textHint
        super.init(frame: frame)
    }
    
    func beginAnimation() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimation() {
        activityIndicator.stopAnimating()
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false
    }
    
    
    func constructHierarchy() {
        addSubview(activityIndicator)
        addSubview(textHintLabel)
        textHintLabel.text = textHint
    }
    
    func activateConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: self.topAnchor,constant: 15).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        textHintLabel.translatesAutoresizingMaskIntoConstraints = false
        textHintLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textHintLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textHintLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor,constant: 10).isActive = true
        textHintLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
}
