//
//  Structs.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import CredifyCryptoSwift
import UIKit

//MARK: - wrapper of `CredifyCryptoSwift`

public struct CommonResponse: Codable {
    public let success: Bool
    
    private enum CodingKeys: String, CodingKey {
        case success
    }
}

public struct CCPublicKeys: Codable {
    public let master: String
    public let eos: String
    
    private enum CodingKeys: String, CodingKey {
        case master
        case eos
    }
}

public struct CCAccountProfile: Codable {
    public let name: CCName?
    public let localName: CCName?
    public let emailAddress: String?
    public let phone: CCPhone?
    public let dob: String?
    public let address: CCLocation?
    public let nationality: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case localName = "local_name"
        case emailAddress = "email"
        case phone
        case dob
        case address
        case nationality
    }
    
    public init(name: CCName?, localName: CCName?, email: String?, phone: CCPhone?, dob: String?, address: CCLocation?, nationality: String?) {
        self.name = name
        self.localName = localName
        self.emailAddress = email
        self.phone = phone
        self.dob = dob
        self.address = address
        self.nationality = nationality
    }
    
    public var primaryName: CCName? {
        if let n = name, let ln = localName {
            return CCUserDefaultsUtil.isDisplayLocalName ? ln : n
        }
        if let n = name {
            return n
        }
        if let ln = localName {
            return ln
        }
        return nil
    }

    public var fieldsCount: Int {
        var count = 0
        if let n = name {
            if let m = n.middleName {
                if m.isEmpty {
                    count += 2
                } else {
                    count += 3
                }
            } else {
                count += 2
            }
        }
        if let email = emailAddress {
            if !email.isEmpty {
                count += 1
            }
        }
        if let p = phone {
            if !p.phoneNumber.isEmpty {
                count += 1
            }
        }
        if let d = dob {
            if !d.isEmpty {
                count += 1
            }
        }
        if let l = address {
            if let c = l.country {
                if !c.isEmpty {
                    count += 1
                }
            }
            if let p = l.province {
                if !p.isEmpty {
                    count += 1
                }
            }
            if let c = l.city {
                if !c.isEmpty {
                    count += 1
                }
            }
            if let a = l.addressLine {
                if !a.isEmpty {
                    count += 1
                }
            }
            if let z = l.postalCode {
                if !z.isEmpty {
                    count += 1
                }
            }
        }
        if let n = nationality {
            if !n.isEmpty {
                count += 1
            }
        }
        
        return count
    }
    
    public func data(at index: Int) -> (field: CCProfileField, value: String)? {
        if index >= fieldsCount { return nil }
        if index < 0 { return nil }
        
        var count = 0
        if let n = name {
            if !n.firstName.isEmpty {
                if index == count {
                    return (field: .firstName, value: n.firstName)
                }
                count += 1
            }
            if let m = n.middleName, !m.isEmpty {
                if index == count {
                    return (field: .middleName, value: m)
                }
                count += 1
            }
            if !n.lastName.isEmpty {
                if index == count {
                    return (field: .lastName, value: n.lastName)
                }
                count += 1
            }
        }
        if let n = localName {
            if !n.firstName.isEmpty {
                if index == count {
                    return (field: .localFirstName, value: n.firstName)
                }
                count += 1
            }
            if !n.lastName.isEmpty {
                if index == count {
                    return (field: .localLastName, value: n.lastName)
                }
                count += 1
            }
        }
        if let e = emailAddress, !e.isEmpty {
            if index == count {
                return (field: .emailAddress, value: e)
            }
            count += 1
        }
        if let p = phone {
            if index == count {
                return (field: .phone, value: p.phoneNumber)
            }
            count += 1
        }
        if let d = dob, !d.isEmpty {
            if index == count {
                return (field: .dob, value: d)
            }
            count += 1
        }
        if let l = address {
            if let c = l.country, !c.isEmpty {
                if index == count {
                    return (field: .country, value: c)
                }
                count += 1
            }
            if let p = l.province, !p.isEmpty {
                if index == count {
                    return (field: .province, value: p)
                }
                count += 1
            }
            if let c = l.city, !c.isEmpty {
                if index == count {
                    return (field: .city, value: c)
                }
                count += 1
            }
            if let a = l.addressLine, !a.isEmpty {
                if index == count {
                    return (field: .address, value: a)
                }
                count += 1
            }
            if let z = l.postalCode, !z.isEmpty {
                if index == count {
                    return (field: .zipCode, value: z)
                }
            }
        }
        if let n = nationality, !n.isEmpty {
            if index == count {
                return (field: .nationality, value: n)
            }
            count += 1
        }
        
        return nil
    }
}

public struct CCName: Codable {
    public let firstName: String
    public let lastName: String
    public let middleName: String?
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
    }
}

public struct CCPhone: Codable {
    public let phoneNumber: String
    public let countryCode: String
    
    private enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case countryCode = "country_code"
    }
    
    public var displayWithNoSpace: String {
        return "\(countryCode) \(numberWithoutZero)"
    }
    
    public var numberWithoutZero: String {
        return phoneNumber.cutPrefixZero()
    }
    
    public var displayWithSpace: String {
        return "\(countryCode) \(phoneNumber.cutPrefixZero().phoneNumberFormat())"
    }
}

public struct CCLocation: Codable {
    public let country: String? // Country Code (e.g. VN)
    public let province: String?
    public let city: String?
    public let addressLine: String?
    public let postalCode: String?
    
    private enum CodingKeys: String, CodingKey {
        case country
        case province
        case city
        case addressLine = "address_line"
        case postalCode = "postal_code"
    }
}

public struct CCTransferCacheItem: Codable {
    public let asset: CCAsset
    public let to: String
    public let hash: String
}

public struct CCAsset: Codable {
    public let amount: String
    public let symbol: String
    public let decimals: Int
    
    public func getAmount() -> Decimal {
        if let a = Decimal(string: amount) {
            let formattedAmount = a / pow(10, decimals)
            return formattedAmount
        }
        return 0
    }
}

/// A structure to map a identity response from API. This belongs to `AccountResponse`
public struct CCIdentityResponse: Codable {
    /// Identity category (e.g. DID, KYC, Oauth)
    public let category: CCIdentityCategory
    /// Identity source
    public let source: CCIdentitySource
    /// Profile information. This depends on each platform, like Some are using different names on each platform.
    public let profile: CCAccountProfile
    
    private enum CodingKeys: String, CodingKey {
        case category
        case source
        case profile
    }
}





/// Profile object for OpenID Connect
public struct CCOIDCProfile {
    public let name: CCName?
    public let dob: String?
}


public struct CCHistoryDetail: Codable {
    public let identityType: CCIdentitySource?
    public let changes: [String]?
    public let asset: CCAsset?
    public let from: String?
    public let to: String?
    public let client: CCClient?
    public let offer: CCOfferHistory?
    public let approval: CCOfferApproval?
    
    private enum CodingKeys: String, CodingKey {
        case identityType = "identity_type"
        case changes = "changes"
        case asset = "asset"
        case from = "from"
        case to = "to"
        case client = "client"
        case offer = "offer"
        case approval = "approval"
    }
}



public struct CCOfferHistory: Codable {
    public let code: String
    public let campaign: CCOfferCampaign
    
    public init(code: String, campaign: CCOfferCampaign) {
        self.code = code
        self.campaign = campaign
    }
    
    private enum CodingKeys: String, CodingKey {
        case code
        case campaign
    }
    public var name: String {
        return campaign.name ?? ""
    }
}

public struct CCOfferCampaign: Codable {
    public let id: String?
    public let consumer: CCOfferConsumer?
    public let name: String?
    public let description: String?
    public let isPublished: Bool?
    public let startAt: String? //Offer starting date
    public let endAt: String?
    public let extraSteps: Bool?
    public let levels: [String]?
    public let thumbnailUrl: String?
    
    public init(id: String?,
                consumer: CCOfferConsumer?,
                name: String?,
                description: String?,
                isPublished: Bool?,
                startAt: String?,
                endAt: String?,
                extraSteps: Bool?,
                levels: [String]?,
                thumbnailUrl: String?) {
        
        self.id = id
        self.consumer = consumer
        self.name = name
        self.description = description
        self.isPublished = isPublished
        self.startAt = startAt
        self.endAt = endAt
        self.extraSteps = extraSteps
        self.levels = levels
        self.thumbnailUrl = thumbnailUrl
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case consumer
        case name
        case description
        case isPublished = "published"
        case startAt = "start_date"
        case endAt = "end_date"
        case extraSteps = "extra_steps"
        case levels
        case thumbnailUrl = "thumbnail_url"
    }
}

public struct CCOfferConsumer: Codable {
    public let id: String
    public let name: String
    public let description: String?
    public let logoUrlStr: String
    public let appUrlStr: String
    public let scopes: [String]?
    
    public init(id: String,
                name: String,
                description: String?,
                logoUrlStr: String,
                appUrlStr: String,
                scopes: [String]?) {
        
        self.id = id
        self.name = name
        self.description = description
        self.logoUrlStr = logoUrlStr
        self.appUrlStr = appUrlStr
        self.scopes = scopes
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case logoUrlStr = "logo_url"
        case appUrlStr = "app_url"
        case scopes
    }
}

public struct CCClient: Codable {
    public let name: String
    public let logoUri: String
    public let scopes: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case logoUri = "logo_url"
        case scopes
    }
}



public struct CCProvider: Codable {
    public let id: String
    public let name: String
    public let logoUri: String
    public let uri: String
    public let scopes: [CCScopeDefinition]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoUri = "logo_url"
        case uri = "app_url"
        case scopes
    }
}

public struct CCScopeData: Equatable {
    public let id: String
    public let name: String
    public let displayName: String
    public let key: String // Decrypted key
    public let claims: [CCClaimValue]
    public let providerLogoUrl: String
    
    public var isCustom: Bool {
        return !["openid", "profile", "phone", "email", "address", "blockchain_id"].contains(name)
    }
    
    public var localizedDisplayName: String {
        let tn = "Structs"
        return name.localized(tableName: tn, defaultValue: displayName)
    }
    
    public static func ==(lhs: CCScopeData, rhs: CCScopeData) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
    }
}

public struct CCScopeDefinition: Codable {
    public let id: String
    public let name: String
    public let displayName: String
    public let description: String
    public let claims: [CCClaimDefinition]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case displayName = "display_name"
        case description
        case claims
    }
}

public struct CCClaimValue {
    public let id: String
    public let name: String
    public let displayName: String
    public let value: Any?
}

public struct CCClaimDefinition: Codable {
    public let id: String
    public let scopeId: String
    public let mainClaimId: String
    public let name: String
    public let displayName: String
    public let description: String
    public let valueType: CCValueType
    public let isActive: Bool?
    public let maxValue: Float?
    public let minValue: Float?
    public let nested: [CCClaimDefinition]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case scopeId = "scope_id"
        case mainClaimId = "main_claim_id"
        case name
        case displayName = "display_name"
        case description
        case valueType = "value_type"
        case isActive = "is_active"
        case maxValue = "max_value"
        case minValue = "min_value"
        case nested
    }
}

