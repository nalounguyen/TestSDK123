//
//  ClaimRepository.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 17/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift


class ClaimRepository {
    /// `[Used for SDK]` Gets Encrypted Individual Entity's Claim.
    func getEncryptedClaim() -> Observable<GetEncryptedClaimRestResponse> {
        return RestAPIClient.send(apiRequest: GetEncryptedClaimRequest())
    }
    
    /// `[Used for SDK]` Gets attached custom claim values
    func getAttachedCustomClaims(providerId: String?) -> Observable<GetsAttachedCustomClaimRestResponse> {
        let req = GetsAttachedCustomClaimRequest(providerId: providerId)
        return RestAPIClient.send(apiRequest: req)
    }
}
