//
//  ProviderRepository.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class ProviderRepository {
    func getOffersFromProvider(phoneNumber: String?,
                               countryCode: String?,
                               localId: String,
                               credifyId: String?) -> Observable<OfferListRestResponse> {
        let req = GetOffersFromProviderRequest(phoneNumber: phoneNumber,
                                               countryCode: countryCode,
                                               localId: localId,
                                               credifyId: credifyId)
        return RestAPIClient.send(apiRequest: req)
    }
    
    func createsIndividualEntity(profile: CCProfileModel,
                                 signingPublicKey: String,
                                 signingSecret: String,
                                 encryptionPublicKey: String,
                                 encryptionSecret: String,
                                 password: String) -> Observable<CreatesIndividualEntityResponse> {
        let req = CreatesIndividualEntityRequest(profile: profile,
                                                 signingPublicKey: signingPublicKey,
                                                 signingSecret: signingSecret,
                                                 encryptionPublicKey: encryptionPublicKey,
                                                 encryptionSecret: encryptionSecret,
                                                 password: password)
        return RestAPIClient.send(apiRequest: req)
    }
    
    
    func retrieveAccessToken(mode: CCLoginMode,
                             password: String) -> Observable<AccessTokenRestResponse> {
        let req = GetAccessTokenRequest(mode: mode,
                                        password: password)
        return RestAPIClient.send(apiRequest: req)
    }
    
    func getCredifyIdFromProvider(userExternalInfo: CCUserExternalModel,
                                  signingPublicKey: String,
                                  signingSecret: String,
                                  encryptionPublicKey: String,
                                  encryptionSecret: String,
                                  password: String) -> Observable<GetCredifyIdFromProviderResponse> {
        
        let req = GetCredifyIdFromProviderRequest(userExternalInfo: userExternalInfo,
                                                  signingPublicKey: signingPublicKey,
                                                  signingSecret: signingSecret,
                                                  encryptionPublicKey: encryptionPublicKey,
                                                  encryptionSecret: encryptionSecret,
                                                  password: password)
        return RestAPIClient.send(apiRequest: req)
    }
}




