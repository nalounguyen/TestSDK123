//
//  CCScopeModel.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation

public struct CCScopeModel {
    public let name: String
    public let type: CCScopeType
    public let claims: [CCClaimModel]
    public let displayName: String?
    
    public init(name: String,
               type: CCScopeType,
               claims: [CCClaimModel],
               displayName: String?) {
        self.name = name
        self.type = type
        self.claims = claims
        self.displayName = displayName
    }
    
    public init(name: String,
                displayName: String?,
                claims: [CCClaimModel]) {
        self.name = name
        self.claims = claims
        if let type = CCStandardScope(rawValue: name) {
            self.type = .standardScope(type: type)
        }else if let type = CCPassiveScope(rawValue: name) {
            self.type = .passiveScope(type: type)
        }else {
            self.type = .custom(type: name)
        }
        self.displayName = displayName
    }
    
    public var isStandard: Bool {
        switch type {
        case .standardScope:
            return true
        default:
            return false
        }
    }
    
    public var isPassive: Bool {
        switch type {
        case .passiveScope:
            return true
        default:
            return false
        }
    }
    
    public var localizedDisplayName: String {
        let tn = "Structs"
        return name.localized(tableName: tn, defaultValue: name)
    }
    
    public static func converToScopes(with listClaim: [CCClaimModel]) -> [CCScopeModel]{
        let groupingDictionary = Dictionary(grouping: listClaim) { $0.scopeName }
        var result = [CCScopeModel]()
        
        groupingDictionary.forEach { item in
            let scope = CCScopeModel(name: item.key, displayName: nil, claims: item.value)
            result.append(scope)
        }
        return result
    }
}

public enum CCStandardScope: String {
    case profile = "profile"
    case email = "email"
    case phone = "phone"
    case address = "address"
    case openId = "openid"
}

public enum CCPassiveScope: String {
    case finscore = "finscore"
    case ekyc = "ekyc"
    case blockChain = "blockchain_id"
}

public enum CCScopeType {
    case standardScope(type: CCStandardScope)
    case passiveScope(type: CCPassiveScope)
    case custom(type: String)
}
