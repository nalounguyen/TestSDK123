//
//  InitialOfferFlowConfigurer.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 12/03/2021.
//

import Foundation
@_implementationOnly import CredifyCore

class InitialOfferFlowConfigurer {
    static func configure(vc: InitialOfferFlowViewController,
                          offerDetail: OfferData) {
        let pu = CoreService.shared.providerUseCase
        let p = InitialOfferFlowPresenter(providerUseCase: pu,
                                          offerDetail: offerDetail)
        vc.presenter = p
    }
}


