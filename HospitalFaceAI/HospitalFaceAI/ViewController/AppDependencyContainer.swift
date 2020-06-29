//
//  AppDependencyContainer.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/11.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import RxSwift

class AppDependencyContainer {
    
    let sharedUserSessionRepository: UserSessionRepository //数据层
    let sharedMainViewModel: MainViewModel //逻辑层
    
    init() {
        func makeUserSessionRepository() -> UserSessionRepository {
            let dataStore = makeUserSessionDataStore()
            let remoteAPI = makeRemoteAPI()
            return APPUserSessionRepository(dataStore: dataStore, remoteAPI: remoteAPI)
        }
        
        // 用户数据切换，安全原因，用户数据也是假数据
        func makeUserSessionDataStore() -> UserSessionDataStore {
            return FakeUserSessionDataStore()
//            return FileUserSessionDataStore()
        }
        
        //真实数据接口因为安全原因已经被删除，如果需要你可以直接套用
        func makeRemoteAPI() -> RemoteAPI { //切换开发使用的加数据
            return FakeRemoteAPI() //切换开发使用的加数据
//            return OfficalRemoteAPI() //切换真实数据
        }
        
        func makeMainViewModel() -> MainViewModel {
            return MainViewModel()
        }
        self.sharedMainViewModel = makeMainViewModel()
        self.sharedUserSessionRepository = makeUserSessionRepository()
    }
    
    func makeMainViewController() -> MainViewController {
        let loginViewControler = makeLoginViewController()
        let agreeViewController = makeAgreeViewController()
        let guideViewController = makeGuideViewController()
        
        return MainViewController(viewModel: sharedMainViewModel,loginViewController: loginViewControler,agreementViewController: agreeViewController,guideViewController: guideViewController)
    }
    
    //login
    func makeLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel(userSessionRepository: sharedUserSessionRepository, authorizedResponder: sharedMainViewModel)
        return LoginViewController(viewModel: viewModel)
    }
    
    //agreement
    func makeAgreeViewController() -> AgreementViewController {
        let viewModel = AgreeViewModel(userSessionRepository: sharedUserSessionRepository, authorizedResponder: sharedMainViewModel)
        return AgreementViewController(viewModel: viewModel)
    }
    
    //guide
    func makeGuideViewController() -> GuideViewController {
        let viewModel = GuideViewModel(userSessionRepository: sharedUserSessionRepository, recognizefaceResponder: sharedMainViewModel)
        return GuideViewController(viewModel: viewModel)
    }
}
