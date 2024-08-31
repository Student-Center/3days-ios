//
//  EndpointType.swift
//  NetworkKit
//
//  Created by 김지수 on 8/24/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation
import Alamofire

public protocol EndpointType {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Encodable? { get }
    var body: Encodable? { get }
    func request<T: Decodable>(_ type: T.Type) async throws -> T
    func request() async throws
}