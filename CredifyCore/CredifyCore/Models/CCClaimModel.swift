//
//  CCClaimModel.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation

public struct CCClaimModel: Codable {
    public let scopeName: String
    public let claimName: String
    public let claimValue: String
    public let claimValueType: CCMetadataType
    public let displayName: String?
    
    public init(scopeName: String,
         claimName: String,
         claimValue: String,
         claimValueType: CCMetadataType,
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
