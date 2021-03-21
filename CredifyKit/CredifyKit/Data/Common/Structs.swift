//
//  Structs.swift
//  Credify
//
//  Created by Nalou Nguyen on 10/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
@_implementationOnly import CredifyCore


//public typealias OfferRedeem = CCOfferRedeemModel



public struct ClaimValue {
    public let id: String
    public let name: String
    public let displayName: String
    public let value: Any?
    
    static func convert(from model: CCClaimValue) -> ClaimValue {
        return ClaimValue(id: model.id,
                          name: model.name,
                          displayName: model.displayName,
                          value: model.value)
    }
}

public struct OfferRedeem {
    public let approval: OfferApproval?
    public let redirectUrlStr: String?
    
    
    static func convert(from model: CCOfferRedeem) -> OfferRedeem {
        return OfferRedeem(approval: OfferApproval.convert(from: model.approval),
                           redirectUrlStr: model.redirectUrlStr)
    }
    
    public struct OfferApproval {
        public let id: String
        public let appliedAt: String?
        public let clientId: String?
        public let offerId: String?
        public let entityId: String?
        public let offerLevel: Int?
        public let scopes: [String]?
        
        static func convert(from model: CCOfferApproval?) -> OfferApproval? {
            guard let model = model else { return nil }
            return OfferApproval(id: model.id,
                                 appliedAt: model.appliedAt,
                                 clientId: model.clientId,
                                 offerId: model.offerId,
                                 entityId: model.entityId,
                                 offerLevel: model.offerLevel,
                                 scopes: model.scopes)
        }
    }
}



public struct OfferData : Codable {

    public let id: String

    public let code: String

    public let campaign: OfferCampaign

    public let evaluationResult: EvaluationResult

    public var credifyId: String?
    
    public let providerId: String?
    
    
    var ccModel: CCOfferData {
        return CCOfferData(id: self.id,
                           code: self.code,
                           campaign: self.campaign.ccModel,
                           evaluationResult: self.evaluationResult.ccModel,
                           credifyId: self.credifyId,
                           providerId: self.providerId)
    }
    
    init(from ccModel: CCOfferData) {
        self.id = ccModel.id
        self.code = ccModel.code
        self.campaign = OfferCampaign(from: ccModel.campaign)
        self.evaluationResult = EvaluationResult(from: ccModel.evaluationResult)//ccModel.evaluationResult
        self.credifyId = ccModel.credifyId
        self.providerId = ccModel.providerId
    }
    
    
    public init(id: String,
                code: String,
                campaign: OfferCampaign,
                evaluationResult: EvaluationResult,
                credifyId: String,
                providerId: String?) {
        
        self.id = id
        self.code = code
        self.campaign = campaign
        self.evaluationResult = evaluationResult
        self.credifyId = credifyId
        self.providerId = providerId
    }

    
}

public struct OfferCampaign : Codable {

    public let id: String?

    public let consumer: OfferConsumer?

    public let name: String?

    public let description: String?

    public let isPublished: Bool?

    public let startAt: String?

    public let endAt: String?

    public let extraSteps: Bool?

    public let levels: [String]?

    public let thumbnailUrl: String?
    
    var ccModel: CCOfferCampaign {
        return CCOfferCampaign(id: id,
                               consumer: consumer?.ccModel,
                               name: name,
                               description: description,
                               isPublished: isPublished,
                               startAt: startAt,
                               endAt: endAt,
                               extraSteps: extraSteps,
                               levels: levels,
                               thumbnailUrl: thumbnailUrl)
    }
    
    init(from ccModel: CCOfferCampaign) {
        self.id = ccModel.id
        self.consumer = ccModel.consumer == nil ? nil : OfferConsumer(from: ccModel.consumer!)
        self.name = ccModel.name
        self.description = ccModel.description
        self.isPublished = ccModel.isPublished
        self.startAt = ccModel.startAt
        self.endAt = ccModel.endAt
        self.extraSteps = ccModel.extraSteps
        self.levels = ccModel.levels
        self.thumbnailUrl = ccModel.thumbnailUrl
    }
    
    public init(id: String,
                consumer: OfferConsumer,
                name: String,
                description: String,
                isPublished: Bool,
                startAt: String,
                endAt: String,
                extraSteps: Bool,
                levels: [String],
                thumbnailUrl: String) {
        
        self.id = id
        self.consumer = consumer
        self.name = name
        self.description = description
        self.isPublished = isPublished
        self.startAt = startAt
        self.endAt = endAt
        self.extraSteps = extraSteps
        self.levels = levels
        self.thumbnailUrl = thumbnailUrl
    }

    
}

public struct EvaluationResult : Codable {

    public let rank: Int

    public let usedScopes: [String]

    public let requiredScopes: [String]
    
    var ccModel: CCEvaluationResult {
        return CCEvaluationResult(rank: rank,
                                  usedScopes: usedScopes,
                                  requiredScopes: requiredScopes)
    }
    
    init(from ccModel: CCEvaluationResult) {
        self.rank = ccModel.rank
        self.usedScopes = ccModel.usedScopes
        self.requiredScopes = ccModel.requiredScopes
    }
    
    public init(rank: Int,
                usedScopes: [String],
                requiredScopes: [String]) {
        self.rank = rank
        self.usedScopes = usedScopes
        self.requiredScopes = requiredScopes
    }
}

public struct OfferConsumer : Codable {

    public let id: String

    public let name: String

    public let description: String?

    public let logoUrlStr: String

    public let appUrlStr: String

    public let scopes: [String]?
    
    var ccModel : CCOfferConsumer {
        return CCOfferConsumer(id: id,
                               name: name,
                               description: description,
                               logoUrlStr: logoUrlStr,
                               appUrlStr: appUrlStr,
                               scopes: scopes)
    }
    
    init(from ccModel: CCOfferConsumer) {
        self.id = ccModel.id
        self.name = ccModel.name
        self.description = ccModel.description
        self.logoUrlStr = ccModel.logoUrlStr
        self.appUrlStr = ccModel.appUrlStr
        self.scopes = ccModel.scopes
    }
    
    public init(id: String,
                name: String,
                description: String,
                logoUrlStr: String,
                appUrlStr: String,
                scopes: [String]) {
        
        self.id = id
        self.name = name
        self.description = description
        self.logoUrlStr = logoUrlStr
        self.appUrlStr = appUrlStr
        self.scopes = scopes
    }
    
    
}



