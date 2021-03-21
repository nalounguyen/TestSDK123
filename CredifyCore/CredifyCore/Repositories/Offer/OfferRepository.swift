//
//  OfferRepository.swift
//  Credify
//
//  Created by Nalou Nguyen on 09/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
import RxSwift

class OfferRepository {
    func getOffersForMe(customeScopeNames: [String], standardScope: [CCScopeModel], passiveScope: [CCScopeModel]) -> Observable<OfferListRestResponse> {
        let req = OffersForUserRequest(customeScopeNames: customeScopeNames,
                                       standardScope: standardScope,
                                       passiveScope: passiveScope)
        return RestAPIClient.send(apiRequest: req)
    }
    
    func getOfferEvaluation(_ offerCode: String,
                            customScopeNames: [String],
                            passiveScope: [CCScopeModel]) -> Observable<OfferEvaluationRestResponse> {
        let req = OfferEvaluationRequest(offerCode: offerCode,
                                         customScopeNames: customScopeNames,
                                         passiveScope: passiveScope)
        return RestAPIClient.send(apiRequest: req)
    }
    
    func getOfferRedeem(offerCode: String,
                        scopesNames: [String],
                        persistedScopes: [String],
                        standarAndPassiveScopes: [CCScopeModel],
                        approvalToken: String) -> Observable<OfferRedeemRestResponse> {
        let req = OfferRedeemRequest(offerCode: offerCode,
                                     scopesNames: scopesNames,
                                     persistedScopes: persistedScopes,
                                     standarAndPassiveScopes: standarAndPassiveScopes,
                                     approvalToken: approvalToken)
        return RestAPIClient.send(apiRequest: req)
    }
    
    func getPermissionFinscore(_ data: CCAccountProfile, provider: CCCreditScoringProvider) -> Observable<CommonResponse> {
        let req = CreditScoringRequest(data: data, provider: provider)
        return RestAPIClient.send(apiRequest: req)
    }
    
    func connectCreditScore(_ data: CCProfileModel, provider: CCCreditScoringProvider) -> Observable<ConnectFinscoreRestResponse> {
        let req = ConnectCreditScoreRequest(profile: data, provider: provider)
        return RestAPIClient.send(apiRequest: req)
    }
}
