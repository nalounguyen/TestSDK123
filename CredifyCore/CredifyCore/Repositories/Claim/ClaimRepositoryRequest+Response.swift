//
//  ClaimRepositoryRequest+Response.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 17/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation


/// Gets Encrypted Individual Entity's Claim
struct GetEncryptedClaimRequest: RestAPIRequest {
    var method: RestAPIMethod = .get
    var path = "v1/entity/individual/encrypted/claims"
    var parameters: [String: String] = [:]
    var body: [String: Any] = [:]
    
    init() { }
}

struct GetsAttachedCustomClaimRequest: RestAPIRequest {
    var method: RestAPIMethod = .get
    var path = "v1/claim-providers/attached-claims"
    var parameters: [String: String] = [:]
    var body: [String: Any] = [:]
    
    init(providerId: String?) {
        if let id = providerId {
            parameters["provider_id"] = id
        }
    }
}

/// Gets Encrypted Individual Entity's Claim
struct GetEncryptedClaimRestResponse: Codable {
    let success: Bool
    let data: [String: [String: String] ]
}

/// Gets Encrypted Individual Entity's Claim
public struct GetsAttachedCustomClaimRestResponse: Codable {
    let success: Bool
    let data: GetsAttachedCustomClaimData
    
    public struct GetsAttachedCustomClaimData: Codable {
        let providers: [ProviderRestResponse]
        let claims: [ClaimsResResponse]
    }
}



public struct ProviderRestResponse: Codable {
    public let id: String
    public let name: String?
    public let description: String?
    public let appUrl: String?
    public let logoUrl: String?
    public let categories: [CategoryRestResponse]?
    
    public let userCountsApi: String?
    public let encryptedClaimsApi: Bool?
    public let offerEvaluationApi: [String]?
    public let offerFilteringApi: [String]?
    public let scopes: [ScopeRestResponse]

    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case appUrl = "app_url"
        case logoUrl = "logo_url"
        case categories
        case userCountsApi = "user_counts_api"
        case encryptedClaimsApi = "encrypted_claims_api"
        case offerEvaluationApi = "offer_evaluation_api"
        case offerFilteringApi = "offer_filtering_api"
        case scopes
    }
}

public struct CategoryRestResponse: Codable {
    public let id: String
    public let name: String?
}

public struct ScopeRestResponse: Codable {
    public let id: String
    public let providerId: String?
    public let name: String?
    public let displayName: String?
    public let description: String?
    public let isActive: Bool?
    public let isOnetimeCharge: Bool?
    public let claims: [ProviderClaimsRestResponse]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case providerId = "provider_id"
        case name
        case displayName = "display_name"
        case description
        case isActive = "is_active"
        case isOnetimeCharge = "is_onetime_charge"
        case claims
    }
}

public struct ProviderClaimsRestResponse: Codable {
    public let id: String
    public let scopeId: String?
    public let mainClaimId: String?
    public let name: String?
    public let displayName: String?
    public let description: String?
    public let valueType: String?
    public let isActive: Bool?
//    public let minValue: String?
//    public let maxValue: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case scopeId = "scope_id"
        case mainClaimId = "main_claim_id"
        case name
        case displayName = "display_name"
        case description
        case valueType = "value_type"
        case isActive = "is_active"
//        case minValue = "min_value"
//        case maxValue = "max_value"
    }
//    private enum CodingKeys: String, CodingKey {
//        case id = ""
//        case id = ""
//        case id = ""
//        case id = ""
//        case id = ""
//        case id = ""
//        case id = ""
//        case id = ""
//        case id = ""
//        case id = ""
//    }
}



public struct ClaimsResResponse: Codable {
    public let scope_name: String
    public let scope_hash: String?
    public let timestamp: Int
    public let claim_token: String?
}
