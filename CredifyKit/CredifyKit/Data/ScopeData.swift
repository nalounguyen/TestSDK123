//
//  ScopeData.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
@_implementationOnly import CredifyCore


public struct ScopeData {
    public let id: String

    public let name: String

    public let displayName: String

    public let key: String

    public let claims: [ClaimValue]

    public let providerLogoUrl: String

    public let isCustom: Bool

    public var localizedDisplayName: String
    
    static func convert(from model: CCScopeData) -> ScopeData {
        return ScopeData(id: model.id,
                         name: model.name,
                         displayName: model.displayName,
                         key: model.key,
                         claims: model.claims.map({ return ClaimValue.convert(from: $0) }),
                         providerLogoUrl: model.providerLogoUrl,
                         isCustom: model.isCustom,
                         localizedDisplayName: model.localizedDisplayName)
    }
}
