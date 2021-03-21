//
//  OfferRepositoryRequest+Response.swift
//  Credify
//
//  Created by Nalou Nguyen on 09/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation

//MARK: - OfferRepository Request API

/// Offers list for each user
struct OffersForUserRequest: RestAPIRequest {
    var method: RestAPIMethod = .post
    var path: String = "v1/offers/me"
    var parameters: [String : String] = [:]
    var body: [String : Any] = [:]

    init(customeScopeNames: [String],
         standardScope: [CCScopeModel],
         passiveScope: [CCScopeModel]) {
        
        body["custom_scope_names"] = try? customeScopeNames.asArrayDictionary()
        
        
        var standardClaim = [String: Any]()
        for item in standardScope {
            var dict = [String: Any]()
            for claim in item.claims {
                dict[claim.claimName] = claim.claimValueType.orignalValue
            }
            standardClaim[item.name] = dict
        }
        body["standard_claim_values"] = standardClaim
        
        var passiveClaim = [String: Any]()
        for item in passiveScope {
            var dict = [String: Any]()
            for claim in item.claims {
                dict[claim.claimName] = claim.claimValueType.orignalValue
            }
            passiveClaim[item.name] = dict
        }
        body["passive_claim_values"] = passiveClaim
    }
}
/// Offer Evaluation
struct OfferEvaluationRequest: RestAPIRequest {
    var method: RestAPIMethod = .post
    var path: String = "v1/offers/evaluate"
    var parameters: [String : String] = [:]
    var body: [String : Any] = [:]

    init(offerCode: String, customScopeNames: [String], passiveScope: [CCScopeModel]) {
        body["offer_code"] = offerCode
        body["custom_scope_names"] = customScopeNames
        var passiveClaim = [String: Any]()
        for item in passiveScope {
            var dict = [String: Any]()
            for claim in item.claims {
                dict[claim.claimName] = claim.claimValueType.orignalValue
            }
            passiveClaim[item.name] = dict
        }
//        body["passive_claim_values"] = passiveClaim
    }
}

/// Offer redeem
struct OfferRedeemRequest: RestAPIRequest {
    var method: RestAPIMethod = .post
    var path: String = ""
    var parameters: [String : String] = [:]
    var body: [String : Any] = [:]

    init(offerCode: String,
         scopesNames: [String],
         persistedScopes: [String],
         standarAndPassiveScopes: [CCScopeModel],
         approvalToken: String) {
        path = "v1/offers/\(offerCode)/redeem"
        body["approval_token"] = approvalToken
        body["scopes"] = scopesNames
        body["persisted_scopes"] = persistedScopes
        if !persistedScopes.isEmpty {
            body["persisted_scopes"] = persistedScopes
        }
        
        
        var values = [String: Any]()
        for scope in standarAndPassiveScopes {
            var dict = [String: Any]()
            for claim in scope.claims {
                dict[claim.claimName] = claim.claimValue
            }
            values[scope.name] = dict
        }
        body["values"] = values
    }
}

struct CreditScoringRequest: RestAPIRequest {
    var method: RestAPIMethod = .post
    var path: String = "v1/credit-score"
    var parameters: [String : String] = [:]
    var body: [String : Any] = [:]

    init(data: CCAccountProfile, provider: CCCreditScoringProvider) {
        body = [
            "identity": [
                "name": [
                    "first_name": data.name?.firstName.trim(),
                    "last_name": data.name?.lastName.trim(),
                    "middle_name": data.name?.middleName?.trim(),
                ],
                "local_name": [
                    "first_name": data.localName?.firstName.trim(),
                    "last_name": data.localName?.lastName.trim(),
                    "middle_name": data.localName?.middleName?.trim(),
                ],
                "phone": [
                    "phone_number": data.phone?.numberWithoutZero.removingWhitespaces(),
                    "country_code": data.phone?.countryCode,
                ],
                "email": data.emailAddress?.trim(),
                "dob": data.dob,
                "address": [
                    "postal_code": data.address?.postalCode?.trim(),
                    "country": data.address?.country?.trim(),
                    "province": data.address?.province?.trim(),
                    "city": data.address?.city?.trim(),
                    "address_line": data.address?.addressLine?.trim(),
                ],
                "nationality": data.nationality,
            ],
            "provider" : provider.rawValue,
        ]
    }
}

struct ConnectCreditScoreRequest: RestAPIRequest {
    var method: RestAPIMethod = .post
    var path: String = "v1/credit-score"
    var parameters: [String : String] = [:]
    var body: [String : Any] = [:]
    
    init(profile: CCProfileModel, provider: CCCreditScoringProvider) {
        var profileDict: [String:Any] = [:]
        var nameDict: [String:Any] = [:]
        if let firstName = profile.name?.firstName?.trim() { nameDict["first_name"] = firstName }
        if let lastName = profile.name?.lastName?.trim() { nameDict["last_name"] = lastName }
        if let middleName = profile.name?.middleName?.trim() { nameDict["middle_name"] = middleName }
        nameDict.removeValue(forKey: "verified")
        profileDict["name"] = nameDict
        
        var localNameDict: [String:Any] = [:]
        if let firstName = profile.name?.firstName?.trim() { nameDict["first_name"] = firstName }
        if let lastName = profile.name?.lastName?.trim() { nameDict["last_name"] = lastName }
        if let middleName = profile.name?.middleName?.trim() { nameDict["middle_name"] = middleName }
        localNameDict.removeValue(forKey: "verified")
        
        if !localNameDict.isEmpty {
            profileDict["local_name"] = localNameDict
        }
        
        
        if var phones = profile.phones {
            for(index, value) in phones.enumerated() {
                phones[index].phoneNumber = value.phoneNumber.cutPrefixZero().trim()
                phones[index].verified = nil
            }
            profileDict["phones"] = try? phones.asArrayDictionary()
        }
        if var emails = profile.emails {
            for(index, value) in emails.enumerated() {
                emails[index].emailAddress = value.emailAddress.trim()
                emails[index].verified = nil
            }
            profileDict["emails"] = try? emails.asArrayDictionary()
        }
        
        if var address = profile.address {
            address.addressLine = address.addressLine?.trim() ?? ""
            address.verified = nil
        }
        
        if let address = profile.address {
            profileDict["address"] = try? address.asDictionary()
        }
        
        if var dob = profile.dob {
            dob.verified = nil
            profileDict["dob"] = try? dob.asDictionary()
        }
        
        if var nationality = profile.nationality {
            nationality.verified = nil
            profileDict["nationality"] = try? nationality.asDictionary()
        }
        if var giid = profile.giid {
            profileDict["giid"] = try? giid.asDictionary()
        }
        
        body["identity"] = profileDict
        body["provider"] = provider.rawValue
    }
}









//MARK: - OfferRepository Api Response

/// Offers list for each user
public struct OfferListRestResponse: Codable {
    public let success: Bool
    public let data: OfferListResponse
    
    public struct OfferListResponse: Codable {
        public let offers: [CCOfferData]
        
        private enum CodingKeys: String, CodingKey {
            case offers
        }
    }
}

public struct CCOfferData: Codable {
    public let id: String
    public let code: String
    public let campaign: CCOfferCampaign
    public let evaluationResult: CCEvaluationResult
    public let credifyId: String?
    public let providerId: String?
    
    public init(id: String,
                code: String,
                campaign: CCOfferCampaign,
                evaluationResult: CCEvaluationResult,
                credifyId: String?,
                providerId: String?) {
        self.id = id
        self.code = code
        self.campaign = campaign
        self.evaluationResult = evaluationResult
        self.credifyId = credifyId
        self.providerId = providerId
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case code
        case campaign
        case evaluationResult = "evaluation_result"
        case credifyId = "credify_id"
        case providerId = "provider_id"
    }
}

public struct CCEvaluationResult: Codable {
    public let rank: Int
    public let usedScopes: [String]
    public let requiredScopes: [String]
    
    public init(rank: Int,
                usedScopes: [String],
                requiredScopes: [String]) {
        self.rank = rank
        self.usedScopes = usedScopes
        self.requiredScopes = requiredScopes
    }
    private enum CodingKeys: String, CodingKey {
        case rank
        case usedScopes = "used_scopes"
        case requiredScopes = "requested_scopes"
    }
}

public struct OfferListResponse: Codable {
    public let offers: [CCOfferData]
    
    private enum CodingKeys: String, CodingKey {
        case offers
    }
}

public struct OfferEvaluationRestResponse: Codable {
    public let success: Bool
    public let data: OfferLevel
    
    public struct OfferLevel: Codable {
        public let rank: Int
    }
}

public struct OfferRedeemRestResponse: Codable {
    public let success: Bool
    public let data: CCOfferRedeem
}

public struct CCOfferRedeem: Codable {
    public let approval: CCOfferApproval?
    public let redirectUrlStr: String?
    
    private enum CodingKeys: String, CodingKey {
        case approval = "approval"
        case redirectUrlStr = "redirect_url"
    }
    
    public var redirectUrl: URL? {
        if let url = redirectUrlStr {
            return URL(string: url)
        }
        return nil
    }
}

public struct CCOfferApproval: Codable {
    public let id: String
    public let appliedAt: String?
    public let clientId: String?
    public let offerId: String?
    public let entityId: String?
    public let offerLevel: Int?
    public let scopes: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case appliedAt = "applied_at"
        case clientId = "client_id"
        case offerId = "offer_id"
        case entityId = "entity_id"
        case offerLevel = "offer_level"
        case scopes = "scopes"
    }
    
    public var appliedAtlocalizedDate: String {
        return appliedAt?.toDate()?.toDetailString() ?? ""
    }
}

public struct ConnectFinscoreRestResponse: Codable {
    public let success: Bool
    public let data: FinscoreRestResponse
    
    public struct FinscoreRestResponse: Codable {
        public let provider: String
        public let claims: [String: [String: CCMetadataType] ]
    }
}
