//
//  OfficalRemoteAPI.swift
//  HospitalFaceDetect
//
//  Created by song on 2019/9/18.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
import PromiseKit
enum DomainType {
    case UATTest //内网测试
    case OUTTest //外网测试
    case Offical  //正式
}

enum UrlPath {
    case login
    case agree
    case facecheck
    case downAgreement
}

//以后有时间扩展为 moya + rxswift
struct OfficalRemoteAPI: RemoteAPI {

    let uatTestBase = "http://99.xx.xxx.xx:xxxx"
    let outTestBase = "http://99.xx.xxx.xx:xxxx"
    let officalBase = "http://99.xx.xxx.xx:xxxx"
    //环境切换
    let urlType = DomainType.Offical
    
    func getURLBase(urlType: DomainType) -> String {
        switch urlType {
        case .UATTest:
            return uatTestBase
        case .OUTTest:
            return outTestBase
        case .Offical:
            return officalBase
        }
    }
    
    func getAppID(urlType: DomainType) -> String {
        switch urlType { // 请求基本/公共数据
        case .UATTest:
            return "uattest-app-id"
        case .OUTTest:
            return "outtest-app-id"
        case .Offical:
            return "offical-app-id"
        }
    }
    
    func getFullUrlPath(urlpath: UrlPath) -> String {
        let basePath = getURLBase(urlType: urlType)
        var partPath = ""
        switch urlpath { // 接口路径
        case .login:
            partPath = "/login"
        case .agree:
            partPath = "/agree"
        case .facecheck:
            partPath = "/facecheck"
        case .downAgreement:
            partPath = "/downAgreement"
        }
        let fullurlPath = basePath + partPath
        return fullurlPath
    }
    
    
    func verifyId(idCard: String) -> Bool{
        var value = idCard
        
        value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        var length : Int = 0
        
        length = value.count
        
        if length != 15 && length != 18{
            //不满足15位和18位，即身份证错误
            return false
        }
        
        // 省份代码
        let areasArray = ["11","12", "13","14", "15","21", "22","23", "31","32", "33","34", "35","36", "37","41", "42","43", "44","45", "46","50", "51","52", "53","54", "61","62", "63","64", "65","71", "81","82", "91"]
        
        // 检测省份身份行政区代码
        let index = value.index(value.startIndex, offsetBy: 2)
        let valueStart2 = value[..<index]
//        let valueStart2 = value.substring(to: index)
        
        //标识省份代码是否正确
        var areaFlag = false
        
        for areaCode in areasArray {
            
            if areaCode == valueStart2 {
                areaFlag = true
                break
            }
        }
        
        if !areaFlag {
            return false
        }
        
        var regularExpression : NSRegularExpression?
        
        var numberofMatch : Int?
        
        var year = 0
        
        switch length {
        case 15:
            
            //获取年份对应的数字
            let valueNSStr = value as NSString
            
            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 2)) as NSString
            
            year = yearStr.integerValue + 1900
            
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            }else{
                
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            }
            
            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            
            if numberofMatch! > 0 {
                return true
            }else{
                
                return false
            }
            
        case 18:
            
            let valueNSStr = value as NSString
            
            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 4)) as NSString
            
            year = yearStr.integerValue
            
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
                
            }else{
                
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
            }
            
            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            
            if numberofMatch! > 0 {
                
                let a = getStringByRangeIntValue(Str: valueNSStr, location: 0, length: 1) * 7
                
                let b = getStringByRangeIntValue(Str: valueNSStr, location: 10, length: 1) * 7
                
                let c = getStringByRangeIntValue(Str: valueNSStr, location: 1, length: 1) * 9
                
                let d = getStringByRangeIntValue(Str: valueNSStr, location: 11, length: 1) * 9
                
                let e = getStringByRangeIntValue(Str: valueNSStr, location: 2, length: 1) * 10
                
                let f = getStringByRangeIntValue(Str: valueNSStr, location: 12, length: 1) * 10
                
                let g = getStringByRangeIntValue(Str: valueNSStr, location: 3, length: 1) * 5
                
                let h = getStringByRangeIntValue(Str: valueNSStr, location: 13, length: 1) * 5
                
                let i = getStringByRangeIntValue(Str: valueNSStr, location: 4, length: 1) * 8
                
                let j = getStringByRangeIntValue(Str: valueNSStr, location: 14, length: 1) * 8
                
                let k = getStringByRangeIntValue(Str: valueNSStr, location: 5, length: 1) * 4
                
                let l = getStringByRangeIntValue(Str: valueNSStr, location: 15, length: 1) * 4
                
                let m = getStringByRangeIntValue(Str: valueNSStr, location: 6, length: 1) * 2
                
                let n = getStringByRangeIntValue(Str: valueNSStr, location: 16, length: 1) * 2
                
                let o = getStringByRangeIntValue(Str: valueNSStr, location: 7, length: 1) * 1
                
                let p = getStringByRangeIntValue(Str: valueNSStr, location: 8, length: 1) * 6
                
                let q = getStringByRangeIntValue(Str: valueNSStr, location: 9, length: 1) * 3
                
                let S = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q
                
                let Y = S % 11
                
                var M = "F"
                
                let JYM = "10X98765432"
                
                M = (JYM as NSString).substring(with: NSRange.init(location: Y, length: 1))
                
                let lastStr = valueNSStr.substring(with: NSRange.init(location: 17, length: 1))
                
                if lastStr == "x" {
                    if M == "X" {
                        return true
                    }else{
                        
                        return false
                    }
                }else{
                    
                    if M == lastStr {
                        return true
                    }else{
                        
                        return false
                    }
                }
            }else{
                
                return false
            }
            
        default:
            return false
        }
    }

    func getStringByRangeIntValue(Str : NSString,location : Int, length : Int) -> Int{
        
        let a = Str.substring(with: NSRange(location: location, length: length))
        
        let intValue = (a as NSString).integerValue
        
        return intValue
    }

    
    func login(name: String, idCard: String) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            guard verifyId(idCard: idCard) else {
                seal.reject(FaceDetectError.remoteError(message:"请输入正确的身份证号码"))
                return
            }
            
            let fullPath = self.getFullUrlPath(urlpath: .login)
            // Build Request
            var request = URLRequest(url: URL(string: fullPath)!)
            request.httpMethod = "POST"
            // Build APPID Header
            let appid = self.getAppID(urlType: urlType)
            request.addValue(appid, forHTTPHeaderField: "appid")
            //Params
            let params = ["name": name,"idcard": idCard.uppercased(),"xx": "XXXXXX"]
            request.httpBody = self.buildParams(params).data(using: .utf8)
            
            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in

                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    seal.reject(FaceDetectError.any)
                    return
                }
                

                guard 200..<300 ~= httpResponse.statusCode else {
                    seal.reject(FaceDetectError.httpError)
                    return
                }
                
                let userInfo = UserInfo(name: name, idCard: idCard.uppercased())
                var encrypInfo = EncrypInfo(nameEncryp: "", idCardEncryp: "", passMsgEncryp: "")
                if let data = data {
                    do {
                        let result: [String: Any] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                        print("json ==\(result)") //数据解析
                        let code = result["code"] as! String
                        if code == "1111111" {
                            let contentDic = result["content"] as? NSDictionary
                            let idCardEncryp = contentDic?["idcard"] as? String
                            let nameEncryp = contentDic?["name"] as? String
                            let passMsgEncryp = contentDic?["passmsg"] as? String
                            encrypInfo = EncrypInfo(nameEncryp: nameEncryp ?? "", idCardEncryp: idCardEncryp ?? "", passMsgEncryp: passMsgEncryp ?? "")
                            let userSession = UserSession(userInfo: userInfo, encrypInfo: encrypInfo, authorized: true, faceCheckSuccess: false)
                            seal.fulfill(userSession)
                        }else if code == "2222222" {
                            let userSession = UserSession(userInfo: userInfo, encrypInfo: encrypInfo, authorized: false, faceCheckSuccess: false)
                            seal.fulfill(userSession)
                        }else {
                            let msg = result["msg"] as? String
                            seal.reject(FaceDetectError.remoteError(message: msg ?? "未知原因验证失败"))
                        }
                        
                    } catch {
                        seal.reject(error)
                    }
                }else {
                   seal.reject(FaceDetectError.any)
                }

                }.resume()
        }
    }
    
    func loadAgreeHtml() -> Promise<String> {
        return Promise<String> { seal in
            let fullPath = self.getFullUrlPath(urlpath: .downAgreement)
            // Build Request
            var request = URLRequest(url: URL(string: fullPath)!)
            request.httpMethod = "POST"
            // Build APPID Header
            let appid = self.getAppID(urlType: urlType)
            request.addValue(appid, forHTTPHeaderField: "appid")
            //Params
            let params = ["xx": "xxxxx"]
            request.httpBody = self.buildParams(params).data(using: .utf8)
            
            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    seal.reject(FaceDetectError.any)
                    return
                }
                
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    seal.reject(FaceDetectError.httpError)
                    return
                }
                
                if let data = data {
                    do {
                        let result: [String: Any] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                        let code = result["code"] as! String
                        if code == "111111" {
                            let agreeDic = result["content"] as? NSDictionary
                            let htmlStr = agreeDic?["xxxxx"] as? String
//                            print("contentDic= \(String(describing: agreeDic)))")
//                            print("htmlStr = \(String(describing: htmlStr))")
                            guard let htmlResult = htmlStr else {
                                seal.reject(FaceDetectError.httpError)
                                return
                            }
                            seal.fulfill(htmlResult)
                        }else {
                            let msg = result["msg"] as? String
                            seal.reject(FaceDetectError.remoteError(message: msg ?? "未知原因验证失败"))
                        }
                        
                    } catch {
                        seal.reject(error)
                    }
                }else {
                    seal.reject(FaceDetectError.any)
                }
                
                }.resume()
        }
    }
    
    func agreement(userSession: UserSession) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            let fullPath = self.getFullUrlPath(urlpath: .agree)
            // Build Request
            var request = URLRequest(url: URL(string: fullPath)!)
            request.httpMethod = "POST"
            // Build APPID Header
            let appid = self.getAppID(urlType: urlType)
            request.addValue(appid, forHTTPHeaderField: "appid")
            //Params
            let name = userSession.userInfo.name
            let idCard = userSession.userInfo.idCard
            let params = ["name": name,"idcard": idCard,"xx": "xxxxxxx"]
            request.httpBody = self.buildParams(params).data(using: .utf8)
            
            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    seal.reject(FaceDetectError.any)
                    return
                }
                
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    seal.reject(FaceDetectError.httpError)
                    return
                }
                
                let userInfo = UserInfo(name: name, idCard: idCard)
                if let data = data {
                    do {
                        let result: [String: Any] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                        print("agree json ==\(result)")
                        let code = result["code"] as! String
                        if code == "111111" {
                            let contentDic = result["content"] as? NSDictionary
                            let idCardEncryp = contentDic?["idcard"] as? String
                            let nameEncryp = contentDic?["name"] as? String
                            let passMsgEncryp = contentDic?["passmsg"] as? String
                            let encrypInfo = EncrypInfo(nameEncryp: nameEncryp ?? "", idCardEncryp: idCardEncryp ?? "", passMsgEncryp: passMsgEncryp ?? "")
                            let userSession = UserSession(userInfo: userInfo, encrypInfo: encrypInfo ,authorized: true, faceCheckSuccess: false)
                            seal.fulfill(userSession)
                        }else {
                            let msg = result["msg"] as? String
                            seal.reject(FaceDetectError.remoteError(message: msg ?? "未知原因验证失败"))
                        }

                    } catch {
                        seal.reject(error)
                    }
                }else {
                    seal.reject(FaceDetectError.any)
                }
                
                }.resume()
        }
    }
    
    func checkInFace(userSession: UserSession,faceStrs: [String]) -> Promise<UserSession> {

        return Promise<UserSession> { seal in
            let fullPath = self.getFullUrlPath(urlpath: .facecheck)
            // Build Request
            var request = URLRequest(url: URL(string: fullPath)!)
            request.httpMethod = "POST"
            // Build APPID Header
            let appid = self.getAppID(urlType: urlType)
            request.addValue(appid, forHTTPHeaderField: "appid")
            //Params
            var frames = [String]()
            let secFrame: String = faceStrs[1]
            let thirdFrame: String = faceStrs[2]
            frames.append(secFrame)
            frames.append(thirdFrame)
            
            let frameStr = frames.joined(separator: ",")
            let faceImgstr: String = faceStrs.first!
            let name = userSession.userInfo.name
            let idCard = userSession.userInfo.idCard
            
            let nameEncryp = userSession.encrypInfo.nameEncryp
            let idCardEncryp = userSession.encrypInfo.idCardEncryp
            let passMsgEncryp = userSession.encrypInfo.passMsgEncryp
            
            let params = ["name": nameEncryp,"idcard": idCardEncryp,"xx": "xxxxxx","image": faceImgstr, "frames":frameStr, "xxxxx": "2", "passmsg": passMsgEncryp, "xxxxxx":"xxxxx", "xxxxx":"xxxx"]
            request.httpBody = self.buildParams(params).data(using: .utf8)
            
            print("params:%@",params)

            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    seal.reject(FaceDetectError.any)
                    return
                }
                
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    print("httpResponse.statusCode = %@",httpResponse.statusCode)
                    print("image:%@",faceImgstr)
                    print("imageFrame: %@",frameStr)
                    seal.reject(FaceDetectError.httpError)
                    return
                }
                
                let userInfo = UserInfo(name: name, idCard: idCard)
                let encrypInfo = EncrypInfo(nameEncryp: nameEncryp, idCardEncryp: idCardEncryp, passMsgEncryp: passMsgEncryp)
                if let data = data {
                    do {
                        let result: [String: Any] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                        print("check in face json ==\(result)")
                        let code = result["code"] as! String
                        if code == "0000" {
                            let userSession = UserSession(userInfo: userInfo, encrypInfo: encrypInfo, authorized: true, faceCheckSuccess: true)
                            seal.fulfill(userSession)
                        }else {
                            let msg = result["msg"] as? String
                            seal.reject(FaceDetectError.remoteError(message: msg ?? "未知原因验证失败"))
                        }
                        
                    } catch {
                        seal.reject(FaceDetectError.remoteError(message: "未知原因验证失败"))
//                        seal.reject(error)
                    }
                }else {
                    seal.reject(FaceDetectError.httpError)
//                    seal.reject(FaceDetectError.any)
                }
                
                }.resume()
        }
    }
    
    private func buildParams(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.boolValue {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
}
