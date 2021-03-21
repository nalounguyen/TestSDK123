//
//  CreateNewAccountConfigurer.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 11/03/2021.
//

import Foundation

import Foundation
@_implementationOnly import CredifyCore

class CreateNewAccountConfigurer {
    static func configure(vc: CreateNewAccountViewController,
                          offerDetail: OfferData) {
        let pu = CoreService.shared.providerUseCase
        let cu = CoreService.shared.claimUseCase
        let p = CreateNewAccountPresenter(useCase: pu,
                                          claimUseCase: cu,
                                          offerDetail: offerDetail)
        vc.presenter = p
    }
}
