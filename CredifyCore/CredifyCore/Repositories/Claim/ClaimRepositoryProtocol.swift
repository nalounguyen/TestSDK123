//
//  ClaimRepositoryProtocol.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 17/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//


import Foundation
import RxSwift
import CredifyCryptoSwift


protocol ClaimRepositoryProtocol: class {
    /// `[Used for SDK]` Gets Encrypted Individual Entity's Claim.
    func getEncryptedClaim() -> Observable<GetEncryptedClaimRestResponse>
    
    /// `[Used for SDK]` Gets attached custom claim values
    func getAttachedCustomClaims(providerId: String?) -> Observable<GetsAttachedCustomClaimRestResponse>
}

public class ClaimRepositoryManager: ClaimRepositoryProtocol {
    private let service: ClaimRepository = ClaimRepository()
    
    func getEncryptedClaim() -> Observable<GetEncryptedClaimRestResponse> {
        service.getEncryptedClaim()
    }
    
    func getAttachedCustomClaims(providerId: String?) -> Observable<GetsAttachedCustomClaimRestResponse> {
        service.getAttachedCustomClaims(providerId: providerId)
    }
}
