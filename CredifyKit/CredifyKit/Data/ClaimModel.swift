//
//  ClaimModel.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
@_implementationOnly import CredifyCore


public struct ClaimModel: Codable {
    public let scopeName: String
    public let claimName: String
    public let claimValue: String
    public let claimValueType: MetadataType
    public let displayName: String?
    
    var ccModel: CCClaimModel {
        return CCClaimModel(scopeName: scopeName,
                            claimName: claimName,
                            claimValue: claimValue,
                            claimValueType: claimValueType.ccModel, displayName: displayName)
    }
    
    init(from model: CCClaimModel) {
        self.scopeName = model.scopeName
        self.claimName = model.claimName
        self.claimValue = model.claimValue
        self.claimValueType = MetadataType.convert(from: model.claimValueType)
        self.displayName = model.displayName
    }
    
    public init(scopeName: String,
         claimName: String,
         claimValue: String,
         claimValueType: MetadataType,
         displayName: String?) {
        
        self.scopeName = scopeName
        self.claimName = claimName
        self.claimValue = claimValue
        self.claimValueType = claimValueType
        self.displayName = displayName
    }
    
    public var isStandardClaim: Bool {
        return CCStandardScope(rawValue: self.scopeName) != nil
    }
    
    public var isPassiveClaim: Bool {
        return CCPassiveScope(rawValue: self.scopeName) != nil
    }
    
}
