//
//  OfferManager.swift
//  Credify
//
//  Created by Nalou Nguyen on 09/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
@_implementationOnly import CredifyCore



/// Manager offer flow
public class OfferManager {
    public static let shared = OfferManager()
    private let bag = DisposeBag()
    private var providerService: ProviderService
    var inputUser: UserExternalModel?
    var redeemSuccessEventSubject = PublishSubject<Bool>()
    
    private init() {
        CCUserDefaultsUtil.instantiate()
        providerService = ProviderService()
        CredifyKitSDK.shared.validInitialSDK()
        bind()
    }
    
    
    public var redeemSuccessEvent: Driver<Bool> {
        return redeemSuccessEventSubject.asDriver(onErrorDriveWith: Driver.empty())
    }
    
    
    //MARK: public properties
    
    public var offersFromProviderEvent: Driver<[OfferData]> {
        return self.providerService.offersFromProviderEvent.asDriver(onErrorDriveWith: Driver.empty())
    }
    
//    public var userRedeemOfferSuccess: Driver<Void>
    
    public var error: Driver<Error> {
        return self.providerService.errorEvent.asDriver(onErrorDriveWith: Driver.empty())
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: public functions
    /// Get list offer from consumers. Result is trigged in `offersFromProviderEvent`
    public func getOffersConsumer(phoneNumber: String?,
                                  countryCode: String?,
                                  localId: String,
                                  credifyId: String?) {
        
        self.providerService.getOffers(phoneNumber: phoneNumber,
                                       countryCode: countryCode,
                                       localId: localId,
                                       credifyId: credifyId)
        
    }
    
    public func startRedemptionFlow(from: UIViewController, offer: OfferData, inputUser: UserExternalModel) {
        self.inputUser = inputUser
        let vc = InitialOfferFlowViewController.instantiate(offer: offer)
//        vc.modalPresentationStyle = .fullScreen
        
        from.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: private func
    
    func bind() {
    }
}
