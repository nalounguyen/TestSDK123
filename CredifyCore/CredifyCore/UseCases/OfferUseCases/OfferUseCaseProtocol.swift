//
//  OfferUseCaseProtocol.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift

public protocol OfferUseCaseProtocol: class {
    
    var offerRedeemEvent: Observable<CCOfferRedeem> { get }
    var offerEvaluationEvent: Observable<Int> { get }
    
    var requiredScopeEvent: Observable<[CCScopeData]> { get }
    var errorEvent: Observable<CCError> { get }
    
    /// This calculate what level of the specified offer is to be unlocked. `offerEvaluationEvent` is triggered.
    func getOfferEvaluation(offerCode: String, selectedScopes: [CCScopeModel])
    /// submit data which user want to share to get offer redeem. `offerRedeemEvent` is triggered.
    func getOfferRedeem(entityId: String, offerInfo: CCOfferData, listScope: [CCScopeModel])
}
