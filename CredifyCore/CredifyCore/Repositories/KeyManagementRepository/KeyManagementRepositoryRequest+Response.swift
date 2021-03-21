//
//  KeyManagementRepositoryRequest+Response.swift
//  Credify
//
//  Created by Nalou Nguyen on 05/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation


//MARK: - ClaimRepository Request API

/// Fetch an encrypted private keys.
struct GetEncryptedPrivateKeyRequest: RestAPIRequest {
    var method: RestAPIMethod = .get
    var path = "v1/entity/key"
    var parameters: [String: String] = [:]
    var body: [String: Any] = [:]
    
    init() {}
}

struct SignatureForPII: RestAPIRequest {
    var method: RestAPIMethod = .post
    var path = "v1/entity/signature"
    var parameters: [String: String] = [:]
    var body: [String: Any] = [:]
    
    init(signature: String, identityId: String, identityHash: String) {
        body = [
            "signature": signature,
            "identity_id": identityId,
            "identity_hash": identityHash
        ]
    }
}



//MARK: - ClaimRepository Api Response


public struct GetEncryptedKeysResponse: Codable {
    public let success: Bool
    public let data: EncryptedKeys
    
    private enum CodingKeys: String, CodingKey {
        case success
        case data
    }
    
    public struct EncryptedKeys: Codable {
        public let signingSecret: String
        public let encryptionSecret: String
        public let signingPublic: String
        public let encryptionPublic: String
        
        private enum CodingKeys: String, CodingKey {
            case signingSecret = "signing_secret"
            case encryptionSecret = "encryption_secret"
            case signingPublic = "signing_public_key"
            case encryptionPublic = "encryption_public_key"
        }
    }
}

public struct CCKeyPair: Codable {
    public let pubKey: String
    public let privKey: String
    private enum CodingKeys: String, CodingKey {
        case pubKey
        case privKey
    }
}

public struct CCKeyPairs {
    public let master: CCKeyPair
    public let eos: CCKeyPair
    
    public func toKeys() -> CCPublicKeys {
        return CCPublicKeys(master: master.pubKey, eos: eos.pubKey)
    }
}

struct EncryptedSecretRes: Codable {
    struct Key: Codable {
        let secret: String
        
        private enum CodingKeys: String, CodingKey {
            case secret
        }
    }
    let data: Key
    let success: Bool
}
