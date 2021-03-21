//
//  ScopeModel.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
@_implementationOnly import CredifyCore

public struct ScopeModel {
    public let name: String
    public let type: ScopeType
    public let claims: [ClaimModel]
    public let isStandard: Bool
    public let isPassive: Bool
    public let localizedDisplayName: String
    public let displayName: String?
    
    var ccModel: CCScopeModel {
        return CCScopeModel(name: name,
                            type: type.ccModel,
                            claims: claims.map({ $0.ccModel }),
                            displayName: displayName )
    }
    
    public init(name: String,
                claims: [ClaimModel],
                displayName: String?) {
        self.name = name
        self.claims = claims
        if let type = StandardScope(rawValue: name) {
            self.type = .standardScope(type: type)
        }else if let type = PassiveScope(rawValue: name) {
            self.type = .passiveScope(type: type)
        }else {
            self.type = .custom(type: name)
        }
        
        switch type {
        case .standardScope:
            self.isStandard = true
            self.isPassive = false
        case .passiveScope:
            self.isStandard = false
            self.isPassive = true
        case .custom:
            self.isStandard = false
            self.isPassive = false
        }
        
        
        self.localizedDisplayName = ""
        self.displayName = displayName
    }

    init(from model: CCScopeModel) {
        self.name = model.name
        switch model.type {
        case .standardScope(let type):
            switch type {
            case .profile:
                self.type = ScopeType.standardScope(type: StandardScope.profile)
            case .email:
                self.type = ScopeType.standardScope(type: StandardScope.email)
            case .phone:
                self.type = ScopeType.standardScope(type: StandardScope.phone)
            case .address:
                self.type = ScopeType.standardScope(type: StandardScope.address)
            case .openId:
                self.type = ScopeType.standardScope(type: StandardScope.openId)
            }
            
        case .passiveScope(let type):
            switch type {
            case .finscore:
                self.type = ScopeType.passiveScope(type: PassiveScope.finscore)
            case .ekyc:
                self.type = ScopeType.passiveScope(type: PassiveScope.ekyc)
            case .blockChain:
                self.type = ScopeType.passiveScope(type: PassiveScope.blockChain)
            }
        case .custom(let type):
            self.type = ScopeType.custom(type: type)
        }
        self.claims = model.claims.map({ return ClaimModel(from: $0) })
        self.isStandard = model.isStandard
        self.isPassive = model.isPassive
        self.localizedDisplayName = model.localizedDisplayName
        self.displayName = model.displayName
    }
    
}

public enum StandardScope: String {
    case profile = "profile"
    case email = "email"
    case phone = "phone"
    case address = "address"
    case openId = "openid"
    
    var ccModel: CCStandardScope {
        switch self {
        case .profile: return .profile
        case .email: return .email
        case .phone: return .phone
        case .address: return .address
        case .openId: return .openId
        }
    }
    
    func convert(from value: CCStandardScope) -> StandardScope {
        switch value {
        case .profile: return .profile
        case .email: return .email
        case .phone: return .phone
        case .address: return .address
        case .openId: return .openId
        }
    }
}

public enum PassiveScope: String {
    case finscore = "finscore"
    case ekyc = "ekyc"
    case blockChain = "blockchain_id"
    
    func convert(from value: CCPassiveScope) -> PassiveScope {
        switch value {
        case .finscore: return .finscore
        case .ekyc: return .ekyc
        case .blockChain: return .blockChain
        }
    }
    var ccModel: CCPassiveScope {
        switch self {
        case .finscore: return .finscore
        case .ekyc: return .ekyc
        case .blockChain: return .blockChain
        }
    }
}

public enum ScopeType {
    case standardScope(type: StandardScope)
    case passiveScope(type: PassiveScope)
    case custom(type: String)
    
    var ccModel: CCScopeType {
        switch self {
        case .standardScope(let type):
            return CCScopeType.standardScope(type: type.ccModel)
        case .passiveScope(let type):
            return CCScopeType.passiveScope(type: type.ccModel)
        case .custom(let type):
            return CCScopeType.custom(type: type)
        }
    }
}
