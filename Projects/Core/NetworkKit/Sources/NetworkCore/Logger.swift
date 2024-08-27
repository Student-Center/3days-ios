//
//  Logger.swift
//  NetworkKit
//
//  Created by 김지수 on 8/25/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation
import Alamofire

class NetworkLogger: EventMonitor {
    var queue: DispatchQueue = DispatchQueue(label: "myNetworkLogger")
    
    func requestDidFinish(_ request: Request) {
        print("")
        print("======================== 👉 Network Request Log 👈 ==========================")
        debugPrint("✅ [URL] : \(request.request?.url?.absoluteString ?? "")")
        debugPrint("✅ [Method] : \(request.request?.httpMethod ?? "")")
        debugPrint("✅ [Headers] : \(request.request?.allHTTPHeaderFields ?? [:])")
        
        if let body = request.request?.httpBody?.toPrettyPrintedString {
            debugPrint("✅ [Body] : \(body)")
        } else {
            debugPrint("✅ [Body] : body 없음")
        }
        print("==============================================================================")
        print("")
    }
    
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        print("")
        print("======================== 👉 Network Response Log 👈 ========================")
        
        switch response.result {
        case .success:
            debugPrint("✅ [StatusCode] : \(response.response?.statusCode ?? 0)")
        case .failure:
            debugPrint("🚨 요청 실패")
        }
        
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 400..<500:
                debugPrint("🚨 클라이언트 오류")
            case 500..<600:
                debugPrint("🚨 서버 오류")
            default:
                break
            }
        }
        
        if let response = response.data?.toPrettyPrintedString {
          debugPrint("✅ [Response] : \(response)")
        }

        print("============================================================================")
        print("")
    }
}


fileprivate extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        else {
            return nil
        }
        return prettyPrintedString as String
    }
}
