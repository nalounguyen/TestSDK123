//
//  RestAPIRequests.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import CredifyCryptoSwift

/// Rest API methods (GET/PUT/POST/DELETE)
public enum RestAPIMethod: String {
    case get = "GET", put = "PUT", post = "POST", delete = "DELETE"
}

/// Rest API protocol
protocol RestAPIRequest {
    var method: RestAPIMethod { get }
    var path: String { get }
    var parameters: [String : String] { get }
    var body: [String: Any] { get }
}

extension RestAPIRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if method == .post || method == .put {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if let accessToken = CCSigner.accessToken() {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        // For sign in with signature
        if let _ = self as? GetAccessToken {
            request.addValue(CCSigner.sign() ?? "", forHTTPHeaderField: "Signature")
        }
        request.addValue(CoreService.shared.environment?.apiKey ?? "", forHTTPHeaderField: "X-API-KEY")
        
        if let _ = self as? RecoveryRefreshKYCStatusRequest {
            request.timeoutInterval = 4
        }
        return request
    }
}

/// Refresh KYC status in Recover Account Without Mnemonic process
struct RecoveryRefreshKYCStatusRequest: RestAPIRequest {
    var method: RestAPIMethod = .post
    var path: String = "v1/recovery/refresh-kyc-status"
    var parameters: [String : String] = [:]
    var body: [String : Any] = [:]
    
    ///Check ID if it's on Onfido.
    init(phoneCode: String, emailCode: String, checkId: String) {
        body = [
            "session": [
                "phone_code": phoneCode,
                "email_code": emailCode
            ],
            "id": checkId,
            "provider_name": "onfido"
        ]
    }
}

/// Gets a new access token with a signature
struct GetAccessToken: RestAPIRequest {
    var method: RestAPIMethod = .get
    var path = "v1/entity/access-token"
    var parameters: [String: String] = [:]
    var body: [String: Any] = [:]
}

