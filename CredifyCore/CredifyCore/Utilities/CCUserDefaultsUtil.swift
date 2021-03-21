//
//  CCUserDefaultsUtil.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation

public struct CCUserDefaultsUtil {
    private static var userDefaults: UserDefaults!
    
    /// Initializes UserDefaults with suite name.
    public static func instantiate(suiteName: String = "") {
        if suiteName.isEmpty {
            userDefaults = UserDefaults.standard
        } else {
            userDefaults = UserDefaults(suiteName: suiteName)!
        }
    }
    
    // MARK: - Definitions
    /// Properties for edit account
    private enum DisplayKeys: String, CaseIterable {
        case localName, socialIdentityNotMatch
    }
    
    /// Properties for registration
    private enum RegistrationKeys: String, CaseIterable {
        case step, signupType, firstOnboarding
    }
    
    /// Properties after registration
    private enum ProductCacheKeys: String, CaseIterable {
        case mnemonicVerified, emailConfirmed, defaultFiat, transferringTxs, kycProcessing, kycProcessingId
    }
    
    /// Properties Recovery account
    private enum RecoveryCacheKeys: String, CaseIterable {
        case recoveryStep
        case recoveryEmail, recoveryPhoneNumber
        case recoveryPhoneCode, recoveryEmailCode
        case recoveryApplicantId, recoveryFullname, recoveryKycProcessingId
        case recoveryFacebookToken, recoveryLinkedInToken, recoveryCode
    }
    
    private enum DebugConfigKeys: String, CaseIterable {
        case rest, ws, eos
    }
    
    // MARK: - Registration Keys
    
    /// Registration step
    public static var registrationStep: String {
        set {
            userDefaults.set(newValue, forKey: RegistrationKeys.step.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RegistrationKeys.step.rawValue) ?? ""
        }
    }
    
    /// Registration type
    public static var registrationType: String {
        set {
            userDefaults.set(newValue, forKey: RegistrationKeys.signupType.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RegistrationKeys.signupType.rawValue) ?? ""
        }
    }
    
    /// Whether or not the first onboarding
    public static var firstOnboarding: Bool {
        set {
            userDefaults.set(newValue, forKey: RegistrationKeys.firstOnboarding.rawValue)
        }
        
        get {
            return userDefaults.bool(forKey: RegistrationKeys.firstOnboarding.rawValue)
        }
    }

    // MARK: - Product Cache Keys
    
    /// Mnemonic is verified or not.
    public static var mnemonicVerified: Bool {
        set {
            userDefaults.set(newValue, forKey: ProductCacheKeys.mnemonicVerified.rawValue)
        }
        
        get {
            return userDefaults.bool(forKey: ProductCacheKeys.mnemonicVerified.rawValue)
        }
    }
    
    /// Email address is confirmed or not.
    public static var emailConfirmed: Bool {
        set {
            userDefaults.set(newValue, forKey: ProductCacheKeys.emailConfirmed.rawValue)
        }
        
        get {
            return userDefaults.bool(forKey: ProductCacheKeys.emailConfirmed.rawValue)
        }
    }
    
    /// Dispaly Another Name
    public static var isDisplayLocalName: Bool {
        set {
            userDefaults.set(newValue, forKey: DisplayKeys.localName.rawValue)
        }
        
        get {
            return userDefaults.bool(forKey: DisplayKeys.localName.rawValue)
        }
    }
    
    /// Social Identities Not Match
    public static var socialIdentityNotMatch: [String] {
        set {
            let d = try? PropertyListEncoder().encode(newValue)
            userDefaults.set(d, forKey: DisplayKeys.socialIdentityNotMatch.rawValue)
        }
        
        get {
            if let d = userDefaults.value(forKey: DisplayKeys.socialIdentityNotMatch.rawValue) as? Data {
                let array = try? PropertyListDecoder().decode(Array<String>.self, from: d)
                return array ?? []
            }
            return []
        }
    }
    
    /// KYC Processing ID temporary
    public static var kycProcessingId: String {
        set {
            userDefaults.set(newValue, forKey: ProductCacheKeys.kycProcessingId.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: ProductCacheKeys.kycProcessingId.rawValue) ?? ""
        }
    }
    
    /// Default fiat
    public static var defaultFiat: String {
        set {
            userDefaults.set(newValue, forKey: ProductCacheKeys.defaultFiat.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: ProductCacheKeys.defaultFiat.rawValue) ?? "USD"
        }
    }
    
    
    // MARK: - Debug Config Keys
    
    public static var debugRest: String? {
        set {
            userDefaults.set(newValue, forKey: DebugConfigKeys.rest.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: DebugConfigKeys.rest.rawValue)
        }
    }
    
    public static var debugWS: String? {
        set {
            userDefaults.set(newValue, forKey: DebugConfigKeys.ws.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: DebugConfigKeys.ws.rawValue)
        }
    }
    
    public static var debugEos: String? {
        set {
            userDefaults.set(newValue, forKey: DebugConfigKeys.eos.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: DebugConfigKeys.eos.rawValue)
        }
    }
    
    // MARK: - Other Manipulations
    
    /// Removes all data stored in UserDefaults
    public static func removeAll() {
        RegistrationKeys.allCases.forEach {
            userDefaults.set(nil, forKey: $0.rawValue)
        }
        ProductCacheKeys.allCases.forEach {
            userDefaults.set(nil, forKey: $0.rawValue)
        }
//        DebugConfigKeys.allCases.forEach {
//            userDefaults.set(nil, forKey: $0.rawValue)
//        }
    }
    
    public static func removeValueForKey(string : String) {
        userDefaults.set(nil, forKey: string)
    }

    // MARK: - Recovery Keys for Recover Account Without Mnemonic flow
    
    /// Recovery step
    public static var recoveryStep: String {
        set {
            userDefaults.set(newValue, forKey: RecoveryCacheKeys.recoveryStep.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RecoveryCacheKeys.recoveryStep.rawValue) ?? ""
        }
    }
    
    /// A email code a user verifies in a  Recovery Account Without Mnemonic flow.
    public static var recoveryEmailCode: String {
        set {
            userDefaults.set(newValue, forKey: RecoveryCacheKeys.recoveryEmailCode.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RecoveryCacheKeys.recoveryEmailCode.rawValue) ?? ""
        }
    }
    
    /// A phone code a user verifies in a  Recover Account Without Mnemonic flow.
    public static var recoveryPhoneCode: String {
        set {
            userDefaults.set(newValue, forKey: RecoveryCacheKeys.recoveryPhoneCode.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RecoveryCacheKeys.recoveryPhoneCode.rawValue) ?? ""
        }
    }
    
    public static var recoveryApplicantId: String {
        set {
            userDefaults.set(newValue, forKey: RecoveryCacheKeys.recoveryApplicantId.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RecoveryCacheKeys.recoveryApplicantId.rawValue) ?? ""
        }
    }
    
    /// A phone number a user verifies in a  Recover Account Without Mnemonic flow.
    public static var recoveryPhoneNumber: String {
        set {
            userDefaults.set(newValue, forKey: RecoveryCacheKeys.recoveryPhoneNumber.rawValue)
        }
        
        get {
            // e.g. +84-12345678 (separator: `-`)
            return userDefaults.string(forKey: RecoveryCacheKeys.recoveryPhoneNumber.rawValue) ?? ""
        }
    }
    
    
    /// A faceBook token a user verifies in a recovery process.
    public static var recoveryFacebookToken: String {
        set {
            userDefaults.set(newValue, forKey: RecoveryCacheKeys.recoveryFacebookToken.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RecoveryCacheKeys.recoveryFacebookToken.rawValue) ?? ""
        }
    }
    
    /// A LinkedIn token a user verifies in a recovery process.
    public static var recoveryLinkedInToken: String {
        set {
            userDefaults.set(newValue, forKey: RecoveryCacheKeys.recoveryLinkedInToken.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RecoveryCacheKeys.recoveryLinkedInToken.rawValue) ?? ""
        }
    }
    
    /// A email a user verifies in recovery process.
    public static var recoveryEmail: String {
        set {
            userDefaults.set(newValue, forKey: RecoveryCacheKeys.recoveryEmail.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RecoveryCacheKeys.recoveryEmail.rawValue) ?? ""
        }
    }
    
    
    static var recoveryCode: String {
        set {
            userDefaults.set(newValue, forKey: RecoveryCacheKeys.recoveryCode.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RecoveryCacheKeys.recoveryCode.rawValue) ?? ""
        }
    }
    
    static var recoveryKycProcessingId: String {
        set {
            userDefaults.set(newValue, forKey: RecoveryCacheKeys.recoveryKycProcessingId.rawValue)
        }
        
        get {
            return userDefaults.string(forKey: RecoveryCacheKeys.recoveryKycProcessingId.rawValue) ?? ""
        }
    }
    
    static func removeRecoveryCacheKeys() {
        RecoveryCacheKeys.allCases.forEach {
            userDefaults.set(nil, forKey: $0.rawValue)
        }
    }
}

