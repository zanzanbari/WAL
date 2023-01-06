//
//  MoyaLoggerPlugin.swift
//  WAL
//
//  Created by heerucan on 2022/05/05.
//

import Foundation

import Moya
import KakaoSDKAuth

final class MoyaLoggerPlugin: PluginType {
    
    // Request를 보낼 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("--> 유효하지 않은 요청")
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var log = "----------------------------------------------------\n1️⃣[\(method)] \(url)\n----------------------------------------------------\n"
        log.append("2️⃣API: \(target)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("header: \(headers)\n")
        }
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("\(bodyString)\n")
        }
        log.append("------------------- END \(method) -------------------")
        print(log)
    }
    
    // Response가 왔을 때
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSucceed(response)
        case let .failure(error):
            onFail(error)
        }
    }
    
    func onSucceed(_ response: Response) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var log = "------------------- 네트워크 통신 성공했는가? -------------------"
        log.append("\n3️⃣[\(statusCode)] \(url)\n----------------------------------------------------\n")
        log.append("response: \n")
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("4️⃣\(reString)\n")
        }
        print("5️⃣[\(statusCode)]\n")
        log.append("============================================= END HTTP =============================================\n\n")
        print(log)
        
        switch statusCode {
        case 401:
            print("1-1. 앗! 액세스토큰이 만료됐으니 갱신API 호출할게요!")
            refreshTokenAPI()
        default:
            return
        }
    }
    
    func onFail(_ error: MoyaError) {
        if let response = error.response {
            onSucceed(response)
            return
        }
        var log = "네트워크 오류"
        log.append("<-- \(error.errorCode)\n")
        log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        log.append("<-- END HTTP")
        print(log)
    }
}

extension MoyaLoggerPlugin {
    func refreshTokenAPI() {
        AuthAPI.shared.postReissue { [weak self] tokenData, status in
            guard let self = self else { return }
            /// 성공적으로 액세스 토큰이 갱신됐다면,
            if let tokenData = tokenData?.data {
                print("1-2. 성공적으로 액세스 토큰이 갱신되었구요, 일단 로그아웃을 시켜볼게요!")
                /// 일단 시험삼아 로그아웃 시키기
                self.pushToLoginView()
                UserDefaultsHelper.standard.accesstoken = tokenData.accesstoken
                print("1-3. 액세스토큰 새롭게 저장 - ", UserDefaultsHelper.standard.accesstoken)
                
            }

            /// 401이 뜨면 리프레시 토큰도 만료
            /// 로그아웃 서버통신 + 액세스 토큰 삭제
            // TODO: - 여기서 리프레쉬 토큰도 삭제할 필요가 있나?
            if let statusCode = tokenData?.status, statusCode == 401 {
                print("2-1. 리프레시 토큰 만료! -> 로그아웃")
                self.pushToLoginView()
            }
        }
    }
    
    /// 이거 필요없음 일단 써둔 것임 -> 그냥 로그아웃 시에 리무브 해주는 걸로 변경
    func logoutAPI() {
        AuthAPI.shared.getLogout { [weak self] logoutData, status in
            guard let self = self else { return }
            if let logoutData = logoutData {
                print("로그아웃 - ", logoutData)
                self.pushToLoginView()
            }
        }
    }
    
    func pushToLoginView() {
        print(#function, "로그인뷰로 이동")
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let viewController = LoginViewController()
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
        UserDefaultsHelper.standard.removeAccessToken()
    }
}
