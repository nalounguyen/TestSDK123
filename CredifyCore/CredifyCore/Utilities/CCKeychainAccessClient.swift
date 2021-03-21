//
//  CCKeychainAccessClient.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import KeychainAccess

public enum CCSecretFields: String {
    // NOTE: if you add a new value, please add it to `removeAll`
    // NOTE: you have to check `KeyManagementRepository.hasSession` as well.
    case pincode, mnemonic, account, publicKeys, accessToken, latestPincodeAuthentication, recoveryMnemonic
    case encryptionKey /// Signing key: Curve25519, PEM - X.509 and PKCS #8.
    case signingKey    /// Encryption key: RSA 4096 bits, PEM - X.509 and PKCS #8.
    case password       /// Use for encrypted `encryptionKey` and `signingKey`
}

struct CCKeychainAccessClient {
    private static var SERVICE_NAME = "\(CoreService.shared.environment?.ENVIRONMENT_NAME ?? "").one.credify.secrets"
    private static let keychain = Keychain(service: SERVICE_NAME).accessibility(.afterFirstUnlock)

    static func setup(suiteName: String = "") {
        if suiteName.isEmpty {
            SERVICE_NAME = "\(CoreService.shared.environment?.ENVIRONMENT_NAME ?? "").one.credify.secrets"
        } else {
            SERVICE_NAME = "\(suiteName).\(CoreService.shared.environment?.ENVIRONMENT_NAME ?? "").one.credify.secrets"
        }
    }
    
    
    /// Saves string value
    static func save(field: CCSecretFields, value: String) {
        let res = try? keychain.set(value, key: field.rawValue)
        if res == nil {
            print("[\(#file)]===[\(#function)]=== Failed to save value into Keychain")
        }
    }
    
    /// Saves data
    static func save(field: CCSecretFields, value: Data) throws {
        try keychain.set(value, key: field.rawValue)
    }
    
    /// Removes a value from Keychain
    static func remove(field: CCSecretFields) {
        keychain[field.rawValue] = nil
    }
    
    /// Removes all information in KeyChain
    static func removeAll() {
        keychain[CCSecretFields.pincode.rawValue] = nil
        keychain[CCSecretFields.mnemonic.rawValue] = nil
        keychain[CCSecretFields.account.rawValue] = nil
        keychain[CCSecretFields.publicKeys.rawValue] = nil
        keychain[CCSecretFields.accessToken.rawValue] = nil
        keychain[CCSecretFields.latestPincodeAuthentication.rawValue] = nil
        keychain[CCSecretFields.recoveryMnemonic.rawValue] = nil
        keychain[CCSecretFields.encryptionKey.rawValue] = nil
        keychain[CCSecretFields.signingKey.rawValue] = nil
        keychain[CCSecretFields.password.rawValue] = nil
    }
    
    /// Retrieves string value from Keychain
    static func get(field: CCSecretFields) -> String? {
        return try? keychain.get(field.rawValue)
    }
    
    /// Retrieves data value from Keychain
    static func getData(field: CCSecretFields) -> Data? {
        return try? keychain.getData(field.rawValue)
    }
}
