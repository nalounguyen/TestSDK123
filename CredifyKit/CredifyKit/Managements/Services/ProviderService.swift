//
//  ProviderService.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@_implementationOnly import CredifyCore

protocol ProviderServiceProtocol {
    var offersFromProviderEvent: Observable<[OfferData]> { get }
    var errorEvent: Observable<Error> { get }
    
    
    
    
    
    
    func getOffers(phoneNumber: String?,
                   countryCode: String?,
                   localId: String,
                   credifyId: String?)
    
    func createsIndividualEntity(profile: ProfileModel,
                                 password: String)
    
}

class ProviderService: ProviderServiceProtocol {
    private var service = ProviderUseCaseManager()
    
    
    lazy var offersFromProviderEvent: Observable<[OfferData]> = {
        return service.offersFromProviderEvent.map {
            return $0.map {
                return OfferData(from: $0)
            }
        }
    }()
    
    lazy var errorEvent: Observable<Error> = {
        return service.errorEvent
            .map { coreErr in
                return CustomError(core: coreErr)
            }
    }()
    
    
    public func getOffers(phoneNumber: String?,
                          countryCode: String?,
                          localId: String,
                          credifyId: String?) {
        
        service.getOffersFromProvider(phoneNumber: phoneNumber,
                                      countryCode: countryCode,
                                      localId: localId,
                                      credifyId: credifyId)
        
    }
    
    func createsIndividualEntity(profile: ProfileModel,
                                 password: String) {
        
        service.createsIndividualEntity(profile: profile.ccModel,
                                        password: password)
    }
}
