//
//  InitialOfferFlowPresenter.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 12/03/2021.
//

import Foundation
import RxSwift
import RxCocoa
@_implementationOnly import CredifyCore

protocol InitialOfferFlowPresenterProtocol {
    /// All required scope for offer
//    var requiredScopesEvent: Driver<[(scope: ScopeModel, isSelected: Bool)]> { get }
//    /// Offer Information
    var offerInfo: OfferData { get }
//    var profileInfo: ProfileModel { get }
//    var offerEvaluationEvent: Driver<OfferBenefitHeaderView.OfferMode> { get }
//    var directToResultPageEvent: Driver<URL> { get }
//    var goToSuccessScreenEvent: Driver<OfferRedeem> { get }
//    
//    func evaluateOffer(index: Int)
//    func getOfferRedeem()
}

class InitialOfferFlowPresenter: InitialOfferFlowPresenterProtocol {
    private let bag = DisposeBag()
    private let providerUseCase: ProviderUseCaseProtocol
    private let offerDetail: OfferData
//    private let profile: ProfileModel
    
    init(providerUseCase: ProviderUseCaseProtocol, offerDetail: OfferData) {
        self.providerUseCase = providerUseCase
        self.offerDetail = offerDetail
//        self.profile = profile
    }
    
    var offerInfo: OfferData {
        return offerDetail
    }
    
//    var profileInfo: ProfileModel {
//        return profile
//    }
    
}
