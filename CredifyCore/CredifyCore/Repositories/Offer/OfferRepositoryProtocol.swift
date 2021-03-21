//
//  OfferRepositoryProtocol.swift
//  Credify
//
//  Created by Nalou Nguyen on 09/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
import RxSwift

public protocol OfferRepositoryProtocol: class {
    /// This calculates what level of the specified offer is to be unlocked
    func getOfferEvaluation(_ offerCode: String,
                            customScopeNames: [String],
                            passiveScope: [CCScopeModel]) -> Observable<OfferEvaluationRestResponse>
    /**
     This redeems a specified offer. This is to be called by a mobile idPass app.
     Parameters:
     - approvalToken:
     - scopes: is a list of scopes that users are going to share with the OIDC client. It might contain some custom scopes provided by claim providers, and in that case Credify will fetch the custom claim values from the claim provider.
     - standarAndPassiveScopes: has encrypted standard & passive claim values with the OIDC client's public key. Each field is encrypted.
     */
    func getOfferRedeem(offerCode: String,
                        scopesNames: [String],
                        persistedScopes: [String],
                        standarAndPassiveScopes: [CCScopeModel],
                        approvalToken: String) -> Observable<OfferRedeemRestResponse>
}

public class OfferRepositoryManager: OfferRepositoryProtocol {
    
    
    private let service: OfferRepository = OfferRepository()

    public func getOfferEvaluation(_ offerCode: String, customScopeNames: [String], passiveScope: [CCScopeModel]) -> Observable<OfferEvaluationRestResponse> {
        return service.getOfferEvaluation(offerCode, customScopeNames: customScopeNames, passiveScope: passiveScope)
    }
    
    public func getOfferRedeem(offerCode: String,
                               scopesNames: [String],
                               persistedScopes: [String],
                               standarAndPassiveScopes: [CCScopeModel],
                               approvalToken: String) -> Observable<OfferRedeemRestResponse> {
        
        return service.getOfferRedeem(offerCode: offerCode,
                                      scopesNames: scopesNames,
                                      persistedScopes: persistedScopes,
                                      standarAndPassiveScopes: standarAndPassiveScopes,
                                      approvalToken: approvalToken)
    }
}
