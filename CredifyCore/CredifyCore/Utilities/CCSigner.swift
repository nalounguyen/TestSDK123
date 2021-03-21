//
//  CCSigner.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift
import CredifyCryptoSwift

public struct CCSigner {
    private static let bag = DisposeBag()
    
    /// Access to an access token generated in an account creation process.
    public static func accessToken() -> String? {
        return CCKeychainAccessClient.get(field: .accessToken)
    }
    
    /// Get pincode
    public static func accessPincode() -> String? {
        return CCKeychainAccessClient.get(field: .pincode)
    }
    
    public static func password() -> String? {
        return CCKeychainAccessClient.get(field: .password)
    }
    
    /// Generate a signature for Loging with signature.
    public static func sign() -> String? {
        var signingKeyPair: Signing?
        guard let keyPairData = CCKeychainAccessClient.getData(field: .signingKey) else { return nil }
        guard let keyPair = try? JSONDecoder().decode(CCKeyPair.self, from: keyPairData) else { return nil }
        guard !keyPair.privKey.isEmpty, !keyPair.pubKey.isEmpty else { return nil }

        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .default).sync {
            do {
                signingKeyPair = try Signing(privateKey: keyPair.privKey, publicKey: keyPair.pubKey, password: nil)
                semaphore.signal()
            } catch {
                signingKeyPair = nil
                semaphore.signal()
            }
        }
        semaphore.wait()
        if let key = signingKeyPair {
            return key.generateLoginToken()
        }
        return nil
    }
}
