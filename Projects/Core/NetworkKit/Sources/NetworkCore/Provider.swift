//
//  Provider.swift
//  NetworkKit
//
//  Created by 김지수 on 8/24/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation
import Alamofire

fileprivate enum Provider {
    static var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let monitor = NetworkLogger()
        let session = Session(
            configuration: configuration,
            eventMonitors: [monitor]
        )
        return session
    }()
}

extension EndpointType {
    private func baseURL() -> String {
        return ServerType.current.baseURL
    }
    
    private func makeDataRequest() -> DataRequest {
        let urlString = "\(baseURL())\(path)"
        let headers: HTTPHeaders = HTTPHeaders(makeDefaultHeader())
        let interceptor = AuthInterceptor()
        
        switch method {
        case .get:
            return Provider.session.request(
                urlString,
                method: .get,
                parameters: parameters?.toDictionary(),
                headers: headers,
                interceptor: interceptor
            )
        case .post:
            if let body {
                return Provider.session.request(
                    urlString,
                    method: method,
                    parameters: body,
                    headers: headers,
                    interceptor: interceptor
                )
            } else {
                return Provider.session.request(
                    urlString,
                    method: .post,
                    headers: headers,
                    interceptor: interceptor
                )
            }
        default:
            return Provider.session.request(
                urlString,
                method: method,
                headers: headers,
                interceptor: interceptor
            )
        }
    }
    
    private func makeDefaultHeader() -> [String: String] {
        // 기본 헤더 설정
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    //MARK: - Request
    public func request<T: Decodable>(_ type: T.Type) async throws -> T {
        let dataRequest = makeDataRequest()
        return try await dataRequest
            .serializingDecodable(type)
            .value
    }
    
    public func request() async throws {
        let dataRequest = makeDataRequest()
        _ = try await dataRequest
            .serializingData()  // 데이터만 가져오고 별도 디코딩하지 않음
            .value
    }
}

extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
              let dictionary = json as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
