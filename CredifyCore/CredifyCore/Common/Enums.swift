//
//  Enums.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation



public enum CCEnvironmentType {
    case DEV, SIT, UAT, SANDBOX, PRODUCTION
}


public enum CCIdentityCategory: String, Codable {
    case kyc = "KYC"
    case did = "DID"
    case oauth = "OAUTH"
}

public enum CCIdentitySource: String, Codable {
    case credify = "CREDIFY_INDIVIDUAL"
    case facebook = "FACEBOOK"
    case linkedin = "LINKEDIN"
    case line = "LINE"
    case passport = "PASSPORT"
    case drivingLicense = "DRIVING_LICENCE"
    case nationID = "NATIONAL_IDENTITY_CARD"
    case taxID = "TAX_IDENTITY"
    case bioResidence = "BIOMETRIC_RESIDENCE_PERMIT"
    case voterID = "VOTER_IDENTITY"
    /// This is bug in backend after recovery account without mnemonic when call API `v1/entity/individual`. We will remove after backend fix it
    case all = "ALL"
    
    var name: String {
        #if STAGING_ALLEX
        let name = "ALLEX"
        #elseif RELEASE_ALLEX
        let name = "ALLEX"
        #else
        let name = "Credify"
        #endif
        switch self {
        case .credify:
            return String(format: self.rawValue.localized(tableName: "Enums"), name)
        default:
            return self.rawValue.localized(tableName: "Enums")
        }
    }
}

public enum CCChainType: String, Codable {
    case btc = "BTC"
    case eth = "ETH"
    case eos = "EOS"
    case xrp = "XRP"
}

public enum CCEventType: String {
    // MARK: - Notification
    
    /// Propagates a notification from the server side
    case notification
    
    // MARK: -
    case unknown
}

public enum CCProfileField: String, Codable {
    case firstName, lastName, middleName, emailAddress, phone, dob, country, province, city, address, zipCode, localFirstName, localLastName, nationality
    
    public var displayName: String {
        switch self {
        case .firstName:
            return "FirstName".localized()
        case .lastName:
            return "LastName".localized()
        case .middleName:
            return "MiddleName".localized()
        case .localFirstName:
            return "AnotherFirstName".localized()
        case .localLastName:
            return "AnotherLastName".localized()
        case .emailAddress:
            return "EmailAddress".localized()
        case .phone:
            return "PhoneNumber".localized()
        case .dob:
            return "DOB".localized()
        case .nationality:
            return "Nationality".localized()
        case .country:
            return "ResidenceCountry".localized()
        case .province:
            return "Province".localized()
        case .city:
            return "City".localized()
        case .address:
            return "Address".localized()
        case .zipCode:
            return "ZipCode".localized()
        }
    }
}

public enum CCHistoryType: String, Codable {
    /// Attaching information (this is handled by frontend)
    case attachingIdentity = "IDENTITY_ATTACHING"
    /// Transfering information (this is handled by frontend)
    case transferring = "ASSET_TRANSFERRING"
    case auth = "APPLICATION_CONNECTED_HISTORY"
    case deauth = "APPLICATION_DISCONNECTED_HISTORY"
    case attachIdentity = "IDENTITY_ATTACHED_HISTORY"
    case detachIdentity = "IDENTITY_DETACHED_HISTORY"
    case receiveAsset = "ASSET_RECEIVE_HISTORY"
    case transferAsset = "ASSET_TRANSFER_HISTORY"
    case approveClaim = "APPROVE_CLAIM" // deprecated
    case rejectClaim = "REJECT_CLAIM" // deprecated
    case updateClaim = "CLAIMS_UPDATED_HISTORY"
    case createStake = "CREATE_STAKE" // deprecated
    case updateStake = "UPDATE_STAKE" // deprecated
    case cancelStake = "CANCEL_STAKE" // deprecated
    case reward = "REWARD" // deprecated
    case penalty = "PENALTY" // deprecated
    case offerRedeem = "REDEEM_OFFER_HISTORY"
}

public enum CCConfirmationStatus: String, Codable {
    case notConfirmed = "NOT_CONFIRMED", confirmed = "CONFIRMED", completed = "COMPLETED"
}

public enum CCValueType: String, Codable {
    case float = "Float"
    case int = "Integer"
    case double = "Double"
    case string = "Text"
    case bool = "Boolean"
    case object = "Object"
    case any = "Any"
}

//MARK: Metadata for dynamic type
public enum CCMetadataType: Codable {
    case int(Int)
    case double(Double)
    case string(String)
    case bool(Bool)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .int(container.decode(Int.self))
        } catch DecodingError.typeMismatch {
            
            do {
                self = try .double(container.decode(Double.self))
            } catch DecodingError.typeMismatch {
                
                do {
                    self = try .string(container.decode(String.self))
                } catch DecodingError.typeMismatch {
                    
                    do {
                        self = try .bool(container.decode(Bool.self))
                    } catch DecodingError.typeMismatch {
                        throw DecodingError.typeMismatch(CCMetadataType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
                    }
                }
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let int):
            try container.encode(int)
        case .double(let double):
            try container.encode(double)
        case .string(let string):
            try container.encode(string)
        case .bool(let bool):
            try container.encode(bool)
        }
    }
    
    public func toString() -> String {
        switch self {
        case .int(let value):
            return "\(value)"
        case .double(let value):
            return "\(value)"
        case .string(let value):
            return "\(value)"
        case .bool(let value):
            return "\(value)"
        }
    }
    
    public var orignalValue: Any {
        switch self {
        case .int(let value):
            return value
        case .double(let value):
            return value
        case .string(let value):
            return value
        case .bool(let value):
            return value
        }
    }
}

public enum CCCreditScoringProvider: String {
    case finscore = "FINSCORE"
}
