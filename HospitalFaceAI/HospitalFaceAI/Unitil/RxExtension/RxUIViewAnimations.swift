//
//  RxUIViewAnimations.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/17.
//  Copyright © 2019 song. All rights reserved.
//
import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base == UIImageView {
    func rotate(duration: TimeInterval) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            UIView.animate(withDuration: duration, animations: {
                self.base.transform = CGAffineTransform(rotationAngle: .pi/2)
            }, completion: { _ in
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func shift(duration: TimeInterval) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            UIView.animate(withDuration: duration, animations: {
                self.base.frame = self.base.frame.offsetBy(dx: 50, dy: 0)
            }, completion: { (_) in
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func fade(duration: TimeInterval) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            UIView.animate(withDuration: duration, animations: {
                self.base.alpha = 0
            }, completion: { (_) in
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func rotateEndlessly(duration: TimeInterval, clockwise: Bool) -> Observable<Void> {
        var disposed = false
        return Observable.create { (observer) -> Disposable in
            func animate() {
                let rotateAngle:CGFloat = clockwise ? .pi : -.pi
                UIView.animate(withDuration: duration, animations: {
                    self.base.transform = self.base.transform.rotated(by: rotateAngle)
                }, completion: { (_) in
                    observer.onNext(())
                    if !disposed {
                        animate()
                    }
                })
            }
            animate()
            return Disposables.create {
                disposed = true
            }
        }
    }


}
