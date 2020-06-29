//
//  FaceRecognizeController.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/16.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class FaceRecognizeController: UINavigationController {
    
    // MARK: - Methods
    init(contentViewController: FaceRecognizeViewController) {
        super.init(rootViewController: contentViewController)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    @available(*, unavailable, message: "Loading nibless view controllers from a nib is unsupported in favor of initializer dependency injection.")
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable, message: "Loading nibless view controllers from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading nibless view controllers from a nib is unsupported in favor of initializer dependency injection.")
    }
}
