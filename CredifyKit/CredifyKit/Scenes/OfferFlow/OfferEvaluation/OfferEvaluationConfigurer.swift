//
//  OfferEvaluationConfigurer.swift
//  Credify
//
//  Created by Nalou Nguyen on 11/12/2020.
//  Copyright © 2020 Credify. All rights reserved.
//

import Foundation
@_implementationOnly import CredifyCore

class OfferEvaluationConfigurer {
    static func configure(vc: OfferEvaluationViewController,
                          offerDetail: OfferData,
                          allScopeValues: [ScopeModel]) {
        let ou = CoreService.shared.offerUseCase
        let p = OfferEvaluationPresenter(useCase: ou, offerDetail: offerDetail, allScopeValues: allScopeValues)
        vc.presenter = p
    }
}
