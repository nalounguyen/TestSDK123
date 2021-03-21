//
//  ClaimUseCaseProtocol.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 17/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import CredifyCryptoSwift
import RxSwift
import RxCocoa

public protocol ClaimUseCaseProtocol: class {
    /// `[Used for SDK]`
    var getEncryptedClaimEvent: Observable<[CCScopeModel]> { get }
    var getCustomScopeEvent: Observable<[CCScopeModel]> { get }
    var errorEvent: Observable<CCError> { get }
    
    
    /// `[Used for SDK]`
    func getEncryptedClaim()
    
    /// `[Used for SDK]` Gets attached custom claim values
    func getAttachedCustomClaims(providerId: String?)
}
