//
//  ClaProviderRepositoryRequest+Response.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation


//MARK: - ProviderRestResponse Request API

struct GetOffersFromProviderRequest: RestAPIRequest {
    var method: RestAPIMethod = .get
    var path = "v1/claim-providers/offers"
    var parameters: [String: String] = [:]
    var body: [String: Any] = [:]
    
    init(phoneNumber: String?, countryCode: String?, localId: String, credifyId: String?) {
        parameters["local_id"] = localId
        if let p = phoneNumber { parameters["phone_number"] = p }
        if let cc = countryCode { parameters["country_code"] = cc }
        if let ci = credifyId { parameters["credify_id"] = ci }
        
        
    }
}

struct CreatesIndividualEntityRequest: RestAPIRequest {
    var method: RestAPIMethod = .get
    var path = "v1/claim-providers/offers"
    var parameters: [String: String] = [:]
    var body: [String: Any] = [:]
    
    init(profile: CCProfileModel,
         signingPublicKey: String,
         signingSecret: String,
         encryptionPublicKey: String,
         encryptionSecret: String,
         password: String) {
        
        if let profileDict = try? profile.asDictionary() {
            body["profile"] = profileDict
        }
        body["signing_public_key"] = signingPublicKey
        body["signing_secret"] = signingSecret
        body["encryption_secret"] = encryptionPublicKey
        body["encryption_public_key"] = encryptionSecret
        body["password"] = password
    }
}

/// Gets a new access token with password
struct GetAccessTokenRequest: RestAPIRequest {
    var method: RestAPIMethod = .post
    var path = "v1/entity/access-token"
    var parameters: [String: String] = [:]
    var body: [String: Any] = [:]
    
    init(mode: CCLoginMode, password: String) {
        switch mode {
        case .withEntityId(let id):
            body = [
                "entity_id": id,
                "password": password.trim()
            ]
            break
        case .withPhone(let phone):
            body = [
                "phone": [
                    "phone_number": phone.phoneNumber.trim(),
                    "country_code": phone.countryCode
                ],
                "password": password.trim(),
            ]
            break
        case .withCredifyId(let id):
            body = [
                "credify_id": id,
                "password": password.trim()
            ]
            break
            
        }
    }
}


struct GetCredifyIdFromProviderRequest:RestAPIRequest {
    var method: RestAPIMethod = .post
    var path = ""
    var parameters: [String: String] = [:]
    var body: [String: Any] = [:]
    
    init(userExternalInfo: CCUserExternalModel,
         signingPublicKey: String,
         signingSecret: String,
         encryptionPublicKey: String,
         encryptionSecret: String,
         password: String) {
        

        body["id"] = userExternalInfo.id
        body["password"] = password
        //TODO: we will update when server stable
//        body["profile"] = profile
//        body["signing_public_key"] = signingPublicKey
//        body["signing_secret"] = signingSecret
//        body["encryption_secret"] = encryptionPublicKey
//        body["encryption_public_key"] = encryptionSecret
        
    }
}



//MARK: - ClaimRepository Api Response

public struct CreatesIndividualEntityResponse: Codable {
    public let success: Bool
    public let data: CredifyInfo
}

public struct CredifyInfo: Codable {
    public let id: String
}


public struct AccessTokenRestResponse: Codable {
    let success: Bool
    let data: AccessTokenResponse
    
    private enum CodingKeys: String, CodingKey {
        case success
        case data
    }
    
    public struct AccessTokenResponse: Codable {
        let accessToken: String
        
        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }
}


public struct GetCredifyIdFromProviderResponse: Codable {
    let id: String
}
