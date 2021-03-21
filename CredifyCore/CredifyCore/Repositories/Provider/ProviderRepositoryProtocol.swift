//
//  ClaimProviderRepositoryProtocol.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 12/03/2021.
//

import Foundation
import RxSwift
import RxCocoa
import CredifyCryptoSwift

public enum CCLoginMode {
    case withEntityId(id: String)
    case withPhone(phone: CCPhoneModel)
    case withCredifyId(id: String)
}

public protocol ProviderRepositoryProtocol: class {
    
    /// This fetches active offers for a requesting claim provider. This list is filtered with data receiver's DB.
    func getOffersFromProvider(phoneNumber: String?,
                               countryCode: String?,
                               localId: String,
                               credifyId: String?) -> Observable<OfferListRestResponse>
    
    /**
     This creates a new individual entity. This new entity has unverified status of email and phone number. This requires a hashed password (sha256 - base64 URL encoded string), encrypted private keys of both signing and encryption, public keys of both signing and encryption. This response will be a Credify ID for this API calling organization. This Credify ID will be different for each organization.
     */
    func createsIndividualEntity(profile: CCProfileModel,
                                 signingPublicKey: String,
                                 signingSecret: String,
                                 encryptionPublicKey: String,
                                 encryptionSecret: String,
                                 password: String) -> Observable<CreatesIndividualEntityResponse>
    
    
    func retrieveAccessToken(mode: CCLoginMode,
                             password: String) -> Observable<AccessTokenRestResponse>
    
    
    func getCredifyIdFromProvider(userExternalInfo: CCUserExternalModel,
                                  signingPublicKey: String,
                                  signingSecret: String,
                                  encryptionPublicKey: String,
                                  encryptionSecret: String,
                                  password: String) -> Observable<GetCredifyIdFromProviderResponse>
}


public class ProviderRepositoryManager: ProviderRepositoryProtocol {
    private let service: ProviderRepository = ProviderRepository()
    
    public func getOffersFromProvider(phoneNumber: String?, countryCode: String?, localId: String, credifyId: String?) -> Observable<OfferListRestResponse> {
        return service.getOffersFromProvider(phoneNumber: phoneNumber, countryCode: countryCode, localId: localId, credifyId: credifyId)
    }
    
    public func createsIndividualEntity(profile: CCProfileModel,
                                        signingPublicKey: String,
                                        signingSecret: String,
                                        encryptionPublicKey: String,
                                        encryptionSecret: String,
                                        password: String) -> Observable<CreatesIndividualEntityResponse> {
        
        return service.createsIndividualEntity(profile: profile,
                                               signingPublicKey: signingPublicKey,
                                               signingSecret: signingSecret,
                                               encryptionPublicKey: encryptionPublicKey,
                                               encryptionSecret: encryptionSecret,
                                               password: password)
        
    }
    
    public func retrieveAccessToken(mode: CCLoginMode,
                                    password: String) -> Observable<AccessTokenRestResponse> {
        return service.retrieveAccessToken(mode: mode,
                                           password: password)
    }
    
    public func getCredifyIdFromProvider(userExternalInfo: CCUserExternalModel,
                                         signingPublicKey: String,
                                         signingSecret: String,
                                         encryptionPublicKey: String,
                                         encryptionSecret: String,
                                         password: String) -> Observable<GetCredifyIdFromProviderResponse> {
        return service.getCredifyIdFromProvider(userExternalInfo: userExternalInfo,
                                                signingPublicKey: signingPublicKey,
                                                signingSecret: signingSecret,
                                                encryptionPublicKey: encryptionPublicKey,
                                                encryptionSecret: encryptionSecret,
                                                password: password)
    }
    
}
