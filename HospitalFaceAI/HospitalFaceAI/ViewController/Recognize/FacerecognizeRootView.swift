//
//  FacerecognizeRootView.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/16.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import AVFoundation
import RxCocoa
import RxSwift

let needTimeOut = false
class FacerecognizeRootView: NiblessView {
    /// 屏幕宽度
    let SCREEN_WIDTH = UIScreen.main.bounds.width
    
    /// 屏幕高度
    let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    let scanRect = CGRect(x: (UIScreen.main.bounds.width - 260)*0.5, y: 104, width: 260, height: 260)
    let viewModel: RecognizeViewModel
    let disposeBag = DisposeBag()
    var hierarchyNotReady = true
    
    ///计时器相关
    var shootImage = false
    var checkInFace = false
    var shootCount: Int = 0
    
    //moveCheck
    var moveCheckCount: Int = 0
    var moveCheckIn = false
    
    var faceImagePics = [UIImage]()
    ///视频相关
    let device: AVCaptureDevice? = {
//        let device = AVCaptureDevice.default(for: .video)
        if #available(iOS 10.0, *) {
//            let device = AVCaptureDevice.default(.builtInDuoCamera, for: .video, position: .front)
//            return device
            let dissession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDuoCamera,.builtInTelephotoCamera,.builtInWideAngleCamera], mediaType: .video, position: .front)
            for deviceItem in dissession.devices {
                if deviceItem.position == .front {
                    return deviceItem
                }
            }
            return AVCaptureDevice.default(for: .video)
        } else {
            // Fallback on earlier versions
            let devices = AVCaptureDevice.devices(for: .video)
            for deviceItem in devices {
                if deviceItem.position == .front {
                    return deviceItem
                }
            }
            return AVCaptureDevice.default(for: .video)
        }
    }()
    
    let session: AVCaptureSession = {
        let session = AVCaptureSession()
        return session
    }()
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    lazy var scanView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    lazy var outImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "scanoutcircle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var midImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "scanmidcircle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var netImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "scannet")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var scanLineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "scanline")
        imageView.contentMode = .center
        return imageView
    }()
    
    
    lazy var recogBtnView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "recognizeBtnBack")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var recogHintImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "recognizeBtnHint")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var recogHitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Color.recognizeText
        label.textAlignment = .center
        label.text = "请正对屏幕"
        return label
    }()
    
    //tflite 人工智能识别
    let modelDataHandler = ModelDataHandler(modelFileInfo: FaceNet.modelInfo)
    
    //test
    lazy var testView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "guidebackground")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    init(frame: CGRect = .zero,
         viewModel: RecognizeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
//        bindViewModelToViews()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = .white
        if constructVideo() {
            startDetect()
        }
        constructScanLayer()
        constructScanViews()
        constructBtnViews()
        test()
//        constructHierarchy()
//        activateConstraints()
//        wireController()
        hierarchyNotReady = false
    }
    
    
    private func constructVideo() -> Bool{
        guard let mydevice = self.device else {
            print("device unuseable")
            return false
        }
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: mydevice)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        //设置像素格式，否则CMSampleBufferRef转换NSImage的时候CGContextRef初始化会出问题
        //        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)]
        //https://www.jianshu.com/p/f280f2fa206c
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
//        let test = videoDataOutput.connection(with: .video)
//        test?.videoScaleAndCropFactor = 10
        
        if self.session.canAddInput(input!) {
            self.session.addInput(input!)
        }
        
        if self.session.canAddOutput(videoDataOutput) {
            self.session.addOutput(videoDataOutput)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        //        self.previewLayer.frame = CGRect(x: 0, y: 0, width:videoView.frame.width, height: videoView.frame.height)
        self.previewLayer.frame = scanRect//CGRect(x: 0, y: 0, width:SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.previewLayer.videoGravity = .resizeAspectFill
        
        //        self.previewLayer.borderWidth = 2
        //        self.previewLayer.borderColor = UIColor.red.cgColor
        self.layer.addSublayer(previewLayer)
        //        self.videoView.layer.addSublayer(previewLayer)
        return true
    }
    
    private  func startDetect() {
        self.session.startRunning()
        MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "GCDTimer", timeInterval: 1, queue: .main, repeats: true) { [unowned self] () -> Void in
            if needTimeOut {
                if self.shootCount <= 30 {
                    self.doDetect()
                    self.shootCount += 1
                }else {
                    self.timeOut()
                }
            }else {
                self.doDetect()
            }

        }
    }
    
    func doDetect() {
        shootImage = true
    }
    
    func stopDetect() {
        self.session.stopRunning()
        MCGCDTimer.shared.cancleTimer(WithTimerName: "GCDTimer")
        removeAllAnimations()
    }
    
    func timeOut() {
        print("timeOut")
    }
    
    func test() {
//        Observable.of("ewree", "cscvfs", "rrrer","sdsad")
//            .delay(3, scheduler: MainScheduler.instance) //元素延迟3秒才发出
//            .subscribe(onNext: { print($0) })
//            .disposed(by: disposeBag)
        addSubview(testView)
        testView.frame = CGRect(x: 30, y: 400, width: 100, height: 100)
    }
    
    func constructScanLayer() {
        //镂空
        let myrect = scanRect
        let path = UIBezierPath(rect: UIScreen.main.bounds)
        let rectPath = UIBezierPath(roundedRect: myrect, cornerRadius: myrect.size.width*0.5)
        path.append(rectPath)
        let roundFrameColor: UIColor = Color.recognizeBackground
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = roundFrameColor.cgColor
        self.layer.addSublayer(fillLayer)
        //画圆
        let ciclePath = UIBezierPath(ovalIn: myrect)
        let cicleLayer = CAShapeLayer()
        let cicleColor: UIColor = Color.recognizeCircle
        cicleLayer.path = ciclePath.cgPath
        cicleLayer.strokeColor = cicleColor.cgColor
        cicleLayer.lineWidth = 1.0
        cicleLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(cicleLayer)
//        netImageView.frame = myrect
//        scanLineImageView.frame = myrect
//        cicleLayer.addSublayer(netImageView.layer)
//        cicleLayer.addSublayer(scanLineImageView.layer)
//        cicleLayer.masksToBounds = true
//        netImageView.layer.masksToBounds = true

    }
    
    func constructScanViews() {
//        addSubview(netImageView)
//        addSubview(scanLineImageView)
        addSubview(scanView)
        scanView.addSubview(netImageView)
        scanView.addSubview(scanLineImageView)
        netImageView.layer.cornerRadius = scanRect.width*0.5
        netImageView.layer.masksToBounds = true
        
        scanLineImageView.layer.cornerRadius = scanRect.width*0.5
        scanLineImageView.layer.masksToBounds = true
        
        addSubview(midImageView)
        addSubview(outImageView)
    }
    
    func constructBtnViews() {
        addSubview(recogBtnView)
        recogBtnView.addSubview(recogHintImage)
        recogBtnView.addSubview(recogHitLabel)
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        addAnimations()
//        sendSubviewToBack(netImageView)
//        sendSubviewToBack(scanLineImageView)
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
//        netImageView.frame = scanRect
//        scanLineImageView.frame = scanRect
        scanView.frame = scanRect
        netImageView.frame = scanView.bounds
        scanLineImageView.frame = scanView.bounds
        
        midImageView.frame = CGRect(x: scanRect.origin.x-8, y: scanRect.origin.y-8, width: scanRect.width+16, height: scanRect.height+16)
        outImageView.frame = CGRect(x: scanRect.origin.x-25, y: scanRect.origin.y-25, width: scanRect.width+50, height: scanRect.height+50)
        
        recogBtnView.frame = CGRect(x: (SCREEN_WIDTH - 200)*0.5, y: scanRect.maxY+100, width: 200, height: 40)
        let imageWH: CGFloat = 24.0
        let labelW: CGFloat = 120.0
        let betweenMargin: CGFloat = 5.0
        let leadMargin = (recogBtnView.frame.width - imageWH - betweenMargin - labelW)*0.5
        recogHintImage.frame = CGRect(x: leadMargin, y: (recogBtnView.frame.height - imageWH)*0.5, width: imageWH, height: imageWH)
        recogHitLabel.frame = CGRect(x: leadMargin+imageWH+betweenMargin, y: (recogBtnView.frame.height - imageWH)*0.5, width: labelW, height: imageWH)        
    }
    
    
    
//    func constructHierarchy() {
//        addSubview(scanframe)
//    }
}

extension FacerecognizeRootView:AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
        if checkInFace {
            return
        }
        
        if moveCheckIn {
            moveCheckCount += 1
            print("计数开始。。。。。。。。\(moveCheckCount)")
            let fetcheImage: Bool = (moveCheckCount%3 == 0)
            if fetcheImage {
                print("shootImage")
                guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                    print("Failed to get image buffer from sample buffer.")
                    return
                }
                if let cropImage = imageFromBuffer(imageBuffer) {
                    if checkFaceImage(image: cropImage) {
                        if faceImagePics.count < 5 {
                            faceImagePics.append(cropImage)
                        }else {
                             perpareToCompareFace(faceImages: faceImagePics)
                        }
                    }
                }
            }
        }
        
        if shootImage && !moveCheckIn {
            print("shootImage")
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                print("Failed to get image buffer from sample buffer.")
                return
            }
            if let cropImage = imageFromBuffer(imageBuffer) {
                if checkFaceImage(image: cropImage) {
                    moveCheckIn = true
//                    perpareToCompareFace(faceImage: cropImage)
                }
            }
            
            
            shootImage = false
        }
        
    }
    
    func imageFromBuffer(_ imageBuffer: CVImageBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        let imageResult = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
        let faceImage = cropImage(image: imageResult)
        return faceImage
    }

}

extension FacerecognizeRootView {
    //face Check
    func cropImage(image:UIImage) -> UIImage {
        let oriImage = image
        print("oriImageSize = \(oriImage.size)")
        let widthScale: CGFloat = oriImage.size.width/SCREEN_WIDTH
        let heightScale: CGFloat = oriImage.size.height/SCREEN_HEIGHT
        
        let orignWidth = scanRect.width
//        let orinHeight = scanRect.height
        
        let x = scanRect.origin.x*widthScale
        let y = scanRect.origin.y*heightScale
        
        let width = orignWidth*widthScale
//        let height = orinHeight*heightScale
        let endCut = (width + 440) > orignWidth ? oriImage.size.width: (width + 440)
        
        let resultRect = CGRect(x: x-200, y: y+160, width: endCut, height: endCut)
        print("resultRect = \(resultRect)")
        let resultImage = oriImage.cropped(to: resultRect)
        print("resultImageSize = \(resultImage.size)")
        return resultImage
    }
    
    func checkFaceImage(image:UIImage) -> Bool {
        testView.image = image
        let ciImage = CIImage.init(image: image)
        let faceDetector:CIDetector = CIDetector.init(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow,CIDetectorTracking:true])!
        let featureArray:[CIFeature] = faceDetector.features(in: ciImage!)
        print("识别个数：\(featureArray.count)")
        if featureArray.count == 1 {
            return true
        }
        return false
    }
    
    func checkFaceImageWithTF(image: UIImage) -> Bool {
        testView.image = image
        let result = modelDataHandler?.runModelWithImage(onImage: image)
        if result != nil {
            print("有脸")
            return true
        }else {
            print("无脸")
            return false
        }
    }
    
    func perpareToCompareFace(faceImages: [UIImage])  {
        checkInFace = true
        var faceStrs = [String]()
        for image in faceImages {
            let resizeFaceImage = image.imageWithNewSize(size: CGSize(width: 300, height: 300))
            guard let resizeImage = resizeFaceImage else {
                print("error in resizeImage")
                return
            }
            let baseImageString = fetchImageString(image: resizeImage)
            guard let baseImgString  = baseImageString else {
                print("error in baseImageString")
                return
            }
            faceStrs.append(baseImgString)
        }
//        let oriFaceImage = faceImage
//        let resizeFaceImage = oriFaceImage.imageWithNewSize(size: CGSize(width: 300, height: 300))
//        guard let resizeImage = resizeFaceImage else {
//            print("error in resizeImage")
//            return
//        }
//        let baseImageString = fetchImageString(image: resizeImage)
//        guard let baseImgString  = baseImageString else {
//            print("error in baseImageString")
//            return
//        }
        print("=====baseImgStrings=====")
        print("pics count = \(faceStrs.count)")
        print(faceStrs)
        viewModel.imageStringInput.onNext(faceStrs)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [unowned self] in
            self.viewModel.goToDetect()
            self.stopDetect()
        }

        
    }
    
    func fetchImageString(image: UIImage) -> String? {
        //将图片转成base64格式
        let imgData = image.jpegData(compressionQuality: 0.3)
        let baseImgString = imgData?.base64EncodedString()
        return baseImgString
    }
    
    

}

extension FacerecognizeRootView {
    
    func addAnimations() {
        rotateForever(view: outImageView, clockwise: true)
        rotateForever(view: midImageView, clockwise: false)
        moveForever(view: scanLineImageView)
    
        UIView.animate(withDuration: 1.8) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.netImageView.alpha = 0.5
        }
    }
    
    func removeAllAnimations() {
        scanLineImageView.layer.removeAllAnimations()
        outImageView.layer.removeAllAnimations()
        midImageView.layer.removeAllAnimations()
        netImageView.stopAnimating()
        
    }
    
    func rotateForever(view: UIView,clockwise: Bool) {
        // 1. 创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2. 设置动画属性
        rotationAnim.fromValue = 0 // 开始角度
        rotationAnim.toValue = clockwise ? Double.pi * 2 :  -Double.pi * 2//结束角度
        rotationAnim.repeatCount = MAXFLOAT // 重复次数
        rotationAnim.duration = 2 // 一圈所需要的时间
        rotationAnim.isRemovedOnCompletion = false //默认是true，切换到其他控制器再回来，动画效果会消失，需要设置成false，动画就不会停了
        
        view.layer.add(rotationAnim, forKey: nil) // 给需要旋转的view增加动画
    }
    
    
    func moveForever(view: UIView) {
        // 1. 创建动画
        let animationMove = CABasicAnimation(keyPath: "transform.translation.y")
        animationMove.fromValue = -80
        animationMove.toValue = 80
        animationMove.duration = 2
        animationMove.repeatCount = MAXFLOAT
        animationMove.isRemovedOnCompletion = false
        view.layer.add(animationMove, forKey: "LineAnimation")
    }
//
//
//    func rotate(_ view: UIView, duration: TimeInterval) -> Observable<Void> {
//        return Observable.create { (observer) -> Disposable in
//            UIView.animate(withDuration: duration, animations: {
//                view.transform = CGAffineTransform(rotationAngle: .pi/2)
//            }, completion: { (_) in
//                observer.onNext(())
//                observer.onCompleted()
//            })
//            return Disposables.create()
//        }
//    }
//
//    func shift(_ view: UIView, duration: TimeInterval) -> Observable<Void> {
//        return Observable.create { (observer) -> Disposable in
//            UIView.animate(withDuration: duration, animations: {
//                view.frame = view.frame.offsetBy(dx: 50, dy: 0)
//            }, completion: { (_) in
//                observer.onNext(())
//                observer.onCompleted()
//            })
//            return Disposables.create()
//        }
//    }
//
//    func fade(_ view: UIView, duration: TimeInterval) -> Observable<Void> {
//        return Observable.create { (observer) -> Disposable in
//            UIView.animate(withDuration: duration, animations: {
//                view.alpha = 0
//            }, completion: { (_) in
//                observer.onNext(())
//                observer.onCompleted()
//            })
//            return Disposables.create()
//        }
//    }
//
//    func rotateEndlessly(_ view: UIView, duration: TimeInterval, clockwise: Bool) -> Observable<Void> {
//        var disposed = false
//        return Observable.create { (observer) -> Disposable in
//            func animate() {
//                let rotateAngle:CGFloat = clockwise ? .pi/2 : -.pi/2
//                UIView.animate(withDuration: duration, animations: {
//                    view.transform = view.transform.rotated(by: rotateAngle)
//                }, completion: { (_) in
//                    observer.onNext(())
//                    if !disposed {
//                        animate()
//                    }
//                })
//            }
//            animate()
//            return Disposables.create {
//                disposed = true
//            }
//        }
//    }
//
//

}
