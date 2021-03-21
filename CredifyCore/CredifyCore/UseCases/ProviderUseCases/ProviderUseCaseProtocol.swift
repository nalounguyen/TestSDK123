//
//  ClaimProviderUseCaseProtocol.swift
//  CredifyMiddlewareCore
//
//  Created by Nalou Nguyen on 12/03/2021.
//


import Foundation
import RxSwift

/// `[Used for SDK]`
public protocol ProviderUseCaseProtocol: class {
    var offersFromProviderEvent: Observable<[CCOfferData]> { get }
    var credifyIdEvent: Observable<(credifyId: String, password: String)> { get }
    var loginSuccessEvent: Observable<Void> { get }
    var errorEvent: Observable<CCError> { get }
    
    
    /// This fetches active offers for a requesting claim provider. This list is filtered with data receiver's DB.
    func getOffersFromProvider(phoneNumber: String?,
                               countryCode: String?,
                               localId: String,
                               credifyId: String?)
    
    /**
     This creates a new individual entity. This new entity has unverified status of email and phone number. This requires a hashed password (sha256 - base64 URL encoded string), encrypted private keys of both signing and encryption, public keys of both signing and encryption. This response will be a Credify ID for this API calling organization. This Credify ID will be different for each organization.
     */
    func createsIndividualEntity(profile: CCProfileModel,
                                 password: String)
    /**
     Login and fetch Encrypted Keys
     */
//    func loginWithPassword(entityId: String,
//                           password: String)
    
    func loginWithPassword(mode: CCLoginMode,
                           password: String)
    
    func getCredifyIdFromProvider(userExternalInfo: CCUserExternalModel,
                                  password: String)
}
