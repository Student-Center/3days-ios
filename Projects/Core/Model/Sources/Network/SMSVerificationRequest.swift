//
//  SMSVerificationRequest.swift
//  NetworkKit
//
//  Created by 김지수 on 9/1/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation

public struct SMSVerificationRequest {
    /// SMS 전송시 발급 받은 내부 식별 ID
    public let verificationId: String
    /// 유저의 SMS로 전송 받은 인증코드
    public let verificationCode: String
    
    public init(
        verificationId: String,
        verificationCode: String
    ) {
        self.verificationId = verificationId
        self.verificationCode = verificationCode
    }
}
