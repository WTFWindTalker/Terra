//
//  RecognizeViewModel.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/17.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import RxSwift

class RecognizeViewModel {
    let facepicStringResponser: FacepicStringResponser
    
    init(facepicStringResponser: FacepicStringResponser) {
        self.facepicStringResponser = facepicStringResponser
    }
    
    let imageStringInput = BehaviorSubject<[String]>(value: [])
    
    func goToDetect() {
        let faceStrings = getFaceImageString()
        facepicStringResponser.fetchFacePicString(facepicStrings: faceStrings)
    }
    
    @objc func cancelDetect() {
        facepicStringResponser.cancelFaceFetch()
    }
    
    func getFaceImageString() -> [String] {
        do {
            let imageString = try imageStringInput.value()
//            print("====!!viewModel!!====")
//            print(imageString)
            return imageString
        } catch {
            fatalError("Error imageStringInput from behavior subjects.")
        }
    }
    
}
