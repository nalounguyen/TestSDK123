//
//  CCProfileModel.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import CredifyCryptoSwift

public class CCNameModel: Codable {
    public let firstName: String?
    public let lastName: String?
    public let middleName: String?
    public let verified: Bool
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
        case verified
    }
    
    public init(_ input: CCName?) {
        self.firstName = input?.firstName
        self.lastName = input?.lastName
        self.middleName = input?.middleName
        self.verified = false
    }
    
    public init(firstName: String? = nil, lastName: String? = nil, middleName: String? = nil, verified: Bool = false) {
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = middleName
        self.verified = verified
    }
    
    /**
     * Only merge the `verified` flag and some raw data field
     */
    public func mergeWithHash(_ model: CCNameModel?) -> CCNameModel {
        guard let model = model else { return self }
        
        return CCNameModel(firstName: firstName,
                         lastName: lastName,
                         middleName: middleName,
                         verified: model.verified)
    }
    
    /**
     * Merge raw model to the current model
     */
    public func mergeWithRaw(_ model: CCNameModel?) -> CCNameModel {
        guard let model = model else { return self }
        
        return CCNameModel(firstName: model.firstName,
                         lastName: model.lastName,
                         middleName: model.middleName,
                         verified: model.verified)
    }
    
    public func clone() -> CCNameModel {
        return CCNameModel(firstName: firstName,
                         lastName: lastName,
                         middleName: middleName,
                         verified: verified)
    }
    
    /**
     * Decrypted to raw model with encryption key
     */
    public func decrypted(encryption: Encryption) -> CCNameModel {
        var firstNameDecrypted = self.firstName
        var lastNameDecrypted = self.lastName
        var middleNameDecrypted = self.middleName
        
        if let firstName = self.firstName, !firstName.isEmpty {
            firstNameDecrypted = try? encryption.decrypt(base64UrlCipher: firstName)
        }
        
        if let lastName = self.lastName, !lastName.isEmpty {
            lastNameDecrypted = try? encryption.decrypt(base64UrlCipher: lastName)
        }
        
        if let middleName = self.middleName, !middleName.isEmpty {
            middleNameDecrypted = try? encryption.decrypt(base64UrlCipher: middleName)
        }
        
        return CCNameModel(firstName: firstNameDecrypted,
                         lastName: lastNameDecrypted,
                         middleName: middleNameDecrypted,
                         verified: self.verified)
    }
}

public struct CCLocationModel: Codable {
    public let country: String? // Country Code (e.g. VNM)
    public let province: String?
    public let city: String?
    public var addressLine: String?
    public let postalCode: String?
    public var verified: Bool?

    private enum CodingKeys: String, CodingKey {
        case country
        case province
        case city
        case addressLine = "address_line"
        case postalCode = "postal_code"
        case verified
    }
    
    public init(country: String?, province: String?, city: String?, addressLine: String?, postalCode: String?, verified: Bool?) {
        self.country = country
        self.province = province
        self.city = city
        self.addressLine = addressLine
        self.postalCode = postalCode
        self.verified = verified
    }
    
    public init?(_ input: CCLocation?) {
        if let value = input {
            self.country = value.country
            self.province = value.province
            self.city = value.city
            self.addressLine = value.addressLine
            self.postalCode = value.postalCode
            self.verified = nil
        }else {
            return nil
        }
    }
    
//    public init?(_ input: LocationRLM?) {
//        if let value = input {
//            self.country = value.country
//            self.province = value.province
//            self.city = value.city
//            self.addressLine = value.addressLine
//            self.postalCode = value.postalCode
//            self.verified = value.isVerified
//        }else { return nil}
//    }
    
    /**
     * Only merge the `verified` flag and some raw data field
     */
    public func mergeWithHash(_ model: CCLocationModel?) -> CCLocationModel {
        guard let model = model else { return self }
        
        return CCLocationModel(country: country,
                             province: province,
                             city: city,
                             addressLine: addressLine,
                             postalCode: postalCode,
                             verified: model.verified)
    }
    
    /**
     * Merge raw model to the current model
     */
    public func mergeWithRaw(_ model: CCLocationModel?) -> CCLocationModel {
        guard let model = model else { return self }
        
        return CCLocationModel(country: model.country,
                             province: model.province,
                             city: model.city,
                             addressLine: model.addressLine,
                             postalCode: model.postalCode,
                             verified: model.verified)
    }
    
    public func clone() -> CCLocationModel {
        return CCLocationModel(country: country,
                             province: province,
                             city: city,
                             addressLine: addressLine,
                             postalCode: postalCode,
                             verified: verified)
    }
    
    /**
     * Decrypted to raw model with encryption key
     */
    public func decrypted(encryption: Encryption) -> CCLocationModel {
        var countryDecrypted = self.country
        var provinceDecrypted = self.province
        var cityDecrypted = self.city
        var addressLineDecrypted = self.addressLine
        var postalCodeDecrypted = self.postalCode
        
        if let country = self.country, !country.isEmpty {
            countryDecrypted = try? encryption.decrypt(base64UrlCipher: country)
        }
        
        if let province = self.province, !province.isEmpty {
            provinceDecrypted = try? encryption.decrypt(base64UrlCipher: province)
        }
        
        if let city = self.city, !city.isEmpty {
            cityDecrypted = try? encryption.decrypt(base64UrlCipher: city)
        }
        
        if let addressLine = self.addressLine, !addressLine.isEmpty {
            addressLineDecrypted = try? encryption.decrypt(base64UrlCipher: addressLine)
        }
        
        if let postalCode = self.postalCode, !postalCode.isEmpty {
            postalCodeDecrypted = try? encryption.decrypt(base64UrlCipher: postalCode)
        }
        
        return CCLocationModel(country: countryDecrypted,
                             province: provinceDecrypted,
                             city: cityDecrypted,
                             addressLine: addressLineDecrypted,
                             postalCode: postalCodeDecrypted,
                             verified: verified)
    }
}

public struct CCPhoneModel: Codable {
    public var phoneNumber: String
    public let countryCode: String
    public var verified: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case countryCode = "country_code"
        case verified
    }
    
    public init?(_ input: CCPhone?) {
        if let phone = input {
            self.phoneNumber = phone.phoneNumber
            self.countryCode = phone.countryCode
            self.verified = false
        }else {
            return nil
        }
    }
    
//    public init(_ input: PhoneRLM) {
//        self.phoneNumber = input.phoneNumber
//        self.countryCode = input.countryCode
//        self.verified = input.isVerified
//    }
    
    public init(phoneNumber: String, countryCode: String, verified: Bool?) {
        self.phoneNumber = phoneNumber
        self.countryCode = countryCode
        self.verified = verified
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
    
    /**
     * Only merge the `verified` flag and some raw data field
     */
    public func mergeWithHash(_ model: CCPhoneModel?) -> CCPhoneModel {
        guard let model = model else { return self }
        
        return CCPhoneModel(phoneNumber: phoneNumber,
                          countryCode: countryCode,
                          verified: model.verified)
    }
    
    /**
     * Merge raw model to the current model
     */
    public func mergeWithRaw(_ model: CCPhoneModel?) -> CCPhoneModel {
        guard let model = model else { return self }

        
        return CCPhoneModel(phoneNumber: model.phoneNumber,
                          countryCode: model.countryCode,
                          verified: model.verified)
    }
    
    public func clone() -> CCPhoneModel {
        return CCPhoneModel(phoneNumber: phoneNumber,
                          countryCode: countryCode,
                          verified: verified)
    }
    
    /**
     * Decrypted to raw model with encryption key
     */
    public func decrypted(encryption: Encryption) -> CCPhoneModel {
        return CCPhoneModel(phoneNumber: (try? encryption.decrypt(base64UrlCipher: self.phoneNumber)) ?? "",
                          countryCode: (try? encryption.decrypt(base64UrlCipher: self.countryCode)) ?? "",
                          verified: verified)
    }
}

public struct CCEmailModel: Codable {
    public var emailAddress: String
    public var verified: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case emailAddress = "email"
        case verified
    }
    
    public init(_ input: String) {
        self.emailAddress = input
        self.verified = false
    }
    
//    public init(_ input: EmailRLM) {
//        self.emailAddress = input.emailAddress
//        self.verified = input.isVerified
//    }
    
    public init(emailAddress: String, verified: Bool?) {
        self.emailAddress = emailAddress
        self.verified = verified
    }
    
    /**
     * Only merge the `verified` flag and some raw data field
     */
    public func mergeWithHash(_ model: CCEmailModel?) -> CCEmailModel {
        guard let model = model else { return self }
        
        return CCEmailModel(emailAddress: emailAddress,
                          verified: model.verified)
    }
    
    /**
     * Merge raw model to the current model
     */
    public func mergeWithRaw(_ model: CCEmailModel?) -> CCEmailModel {
        guard let model = model else { return self }

        return CCEmailModel(emailAddress: model.emailAddress,
                          verified: model.verified)
    }
    
    public func clone() -> CCEmailModel {
        return CCEmailModel(emailAddress: emailAddress,
                          verified: verified)
    }
    
    /**
     * Decrypted to raw model with encryption key
     */
    public func decrypted(encryption: Encryption) -> CCEmailModel {
        return CCEmailModel(emailAddress: (try? encryption.decrypt(base64UrlCipher: self.emailAddress)) ?? "",
                          verified: verified)
    }
}

public struct CCDOBModel: Codable {
    public let date: String?
    public var verified: Bool?
    
    public init?(_ input: String?) {
        if let date = input {
            self.date = date
            self.verified = false
        }else {
            return nil
        }
    }
    
//    public init?(_ input: DOBRLM?) {
//        if let value = input {
//            self.date = value.date
//            self.verified = value.isVerified
//        }else { return nil }
//    }
    
    public init(date: String?, verified: Bool?) {
        self.date = date
        self.verified = verified
    }
    
    /**
     * Only merge the `verified` flag and some raw data field
     */
    public func mergeWithHash(_ model: CCDOBModel?) -> CCDOBModel {
        guard let model = model else { return self }
        
        return CCDOBModel(date: date,
                        verified: model.verified)
    }
    
    /**
     * Merge raw model to the current model
     */
    public func mergeWithRaw(_ model: CCDOBModel?) -> CCDOBModel {
        guard let model = model else { return self }

        return CCDOBModel(date: model.date,
                        verified: model.verified)
    }
    
    public func clone() -> CCDOBModel {
        return CCDOBModel(date: date,
                        verified: verified)
    }
    
    /**
     * Decrypted to raw model with encryption key
     */
    public func decrypted(encryption: Encryption) -> CCDOBModel {
        var dateDecrypted = self.date
        
        if let date = self.date, !date.isEmpty {
            dateDecrypted = try? encryption.decrypt(base64UrlCipher: self.date ?? "")
        }
        return CCDOBModel(date: dateDecrypted,
                        verified: verified)
    }
}

public struct CCNationalityModel: Codable {
    public let country: String?
    public var verified: Bool?
    
    public init?(_ input: String?) {
        if let country = input {
            self.country = country
            self.verified = nil
        }else {
            return nil
        }
    }
    
//    public init?(_ input: NationalityRLM?) {
//        if let item = input {
//            self.country = item.country
//            self.verified = item.isVerified
//        }else {
//            return nil
//        }
//    }
    
    public init(country: String?, verified: Bool?) {
        self.country = country
        self.verified = verified
    }
    
    /**
     Only merge the `verified` flag and some raw data field
     */
    public func mergeWithHash(_ model: CCNationalityModel?) -> CCNationalityModel {
        guard let model = model else { return self }
        
        return CCNationalityModel(country: country,
                                verified: model.verified)
    }
    
    /**
     * Merge raw model to the current model
     */
    public func mergeWithRaw(_ model: CCNationalityModel?) -> CCNationalityModel {
        guard let model = model else { return self }

        return CCNationalityModel(country: model.country,
                                verified: model.verified)
    }
    
    public func clone() -> CCNationalityModel {
        return CCNationalityModel(country: country,
                                verified: verified)
    }
    
    /**
     * Decrypted to raw model with encryption key
     */
    public func decrypted(encryption: Encryption) -> CCNationalityModel {
        return CCNationalityModel(country: try? encryption.decrypt(base64UrlCipher: self.country ?? ""),
                                verified: verified)
    }
}

public struct CCGIIDModel: Codable {
    public let id: String
    public let country: String
    public let expireDate: String
    public let issueDate: String
    public let verified: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case country
        case expireDate
        case issueDate
        case verified
    }
    
//    public init?(_ input: GIIDRLM?) {
//        if let item = input {
//            self.id = item.id
//            self.country = item.country
//            self.expireDate = item.expireDate
//            self.issueDate = item.issueDate
//            self.verified = item.isVerified
//        }else {
//            return nil
//        }
//    }
    
    public init(id: String, country: String, expireDate: String, issueDate: String, verified: Bool) {
        self.id = id
        self.country = country
        self.expireDate = expireDate
        self.issueDate = issueDate
        self.verified = verified
    }
    
    /**
     Only merge the `verified` flag and some raw data field
     */
    public func mergeWithHash(_ model: CCGIIDModel?) -> CCGIIDModel {
        guard let model = model else { return self }
        
        return CCGIIDModel(id: id,
                         country: country,
                         expireDate: expireDate,
                         issueDate: issueDate,
                         verified: model.verified)
    }
    
    /**
     * Merge raw model to the current model
     */
    public func mergeWithRaw(_ model: CCGIIDModel?) -> CCGIIDModel {
        guard let model = model else { return self }

        return CCGIIDModel(id: model.id,
                         country: model.country,
                         expireDate: model.expireDate,
                         issueDate: model.issueDate,
                         verified: model.verified)
    }
    
    public func clone() -> CCGIIDModel {
        return CCGIIDModel(id: id,
                         country: country,
                         expireDate: expireDate,
                         issueDate: issueDate,
                         verified: verified)
    }
    
    /**
     * Decrypted to raw model with encryption key
     */
    public func decrypted(encryption: Encryption) -> CCGIIDModel {
        return CCGIIDModel(id: (try? encryption.decrypt(base64UrlCipher: self.id)) ?? "",
                         country: (try? encryption.decrypt(base64UrlCipher: self.country)) ?? "",
                         expireDate: (try? encryption.decrypt(base64UrlCipher: self.expireDate)) ?? "",
                         issueDate: (try? encryption.decrypt(base64UrlCipher: self.issueDate)) ?? "",
                         verified: verified)
    }
}

public struct CCProfileModel: Codable {
    public var name: CCNameModel?
    public let localName: CCNameModel?
    public var emails: [CCEmailModel]?
    public var phones: [CCPhoneModel]?
    public let dob: CCDOBModel?
    public let address: CCLocationModel?
    public let nationality: CCNationalityModel?
    public let giid: CCGIIDModel?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case localName = "local_name"
        case emails = "emails"
        case phones
        case dob
        case address
        case nationality
        case giid
    }
    public init(name: CCNameModel? = nil,
         localName: CCNameModel? = nil,
         emails: [CCEmailModel]? = nil,
         phones: [CCPhoneModel]? = nil,
         dob: CCDOBModel? = nil,
         address: CCLocationModel? = nil,
         nationality: CCNationalityModel? = nil,
         giid: CCGIIDModel? = nil) {
        
        self.name = name
        self.localName = localName
        self.emails = emails
        self.phones = phones
        self.dob = dob
        self.address = address
        self.nationality = nationality
        self.giid = giid
    }
    
//    public init(_ input: ProfileRLM) {
//        if let name = input.name {
//            self.name = NameModel(firstName: name.firstName,
//                                  lastName: name.lastName,
//                                  middleName: name.middleName,
//                                  verified: name.verified)
//        }else { self.name = nil }
//
//        if let localName = input.localName {
//            self.localName = NameModel(firstName: localName.firstName,
//                                  lastName: localName.lastName,
//                                  middleName: localName.middleName,
//                                  verified: localName.verified)
//        }else { self.localName = nil }
//
//        self.emails = input.emails.map({ EmailModel($0) })
//        self.phones = input.phones.map({ PhoneModel($0) })
//        self.dob = DOBModel(input.dob)
//        self.address = LocationModel(input.address)
//        self.nationality = NationalityModel(input.nationality)
//        self.giid = GIIDModel(input.giid)
//    }
    
    public init(_ input: CCAccountProfile) {
        self.name = CCNameModel(input.name)
        self.localName = CCNameModel(input.localName)
        
        var emails = [CCEmailModel]()
        if let email = input.emailAddress {
            emails.append(CCEmailModel(email))
        }
        self.emails = emails
        
        var phones = [CCPhoneModel]()
        if let phone = input.phone,
           let model = CCPhoneModel(phone) {
            phones.append(model)
        }
        self.phones = phones
        
        self.dob = CCDOBModel(input.dob)
        
        self.address = CCLocationModel(input.address)
        
        self.nationality = CCNationalityModel(input.nationality)
        self.giid = nil
        
    }
    
    /**
     * Only merge the `verified` flag and some raw data field
     */
    public func mergeWithHash(model: CCProfileModel?) -> CCProfileModel {
        guard let model = model else {
            return self
        }
        
        let mergePhones = phones?.map { p -> CCPhoneModel in
            p.mergeWithHash(model.phones?.filter({ $0.phoneNumber == p.phoneNumber }).first)
        }
        
        let mergeEmails = emails?.map { m -> CCEmailModel in
            m.mergeWithHash(model.emails?.filter({ $0.emailAddress == m.emailAddress }).first)
        }
        
        return CCProfileModel(name: name?.mergeWithHash(model.name),
                            localName: localName?.mergeWithHash(model.localName),
                            emails: mergeEmails,
                            phones: mergePhones,
                            dob: dob?.mergeWithHash(model.dob),
                            address: address?.mergeWithHash(model.address),
                            nationality: nationality?.mergeWithHash(model.nationality),
                            giid: giid?.mergeWithHash(model.giid))
    }
    
    /**
     * Merge raw model to the current model
     */
    public func mergeWithRaw(model: CCProfileModel?) -> CCProfileModel {
        guard let model = model else {
            return self
        }
        
        let mergePhones = phones?.map { p -> CCPhoneModel in
            p.mergeWithRaw(model.phones?.filter({ $0.phoneNumber == p.phoneNumber }).first)
        }
        
        let mergeEmails = emails?.map { m -> CCEmailModel in
            m.mergeWithRaw(model.emails?.filter({ $0.emailAddress == m.emailAddress }).first)
        }
        
        
        return CCProfileModel(name: name?.mergeWithRaw(model.name),
                            localName: localName?.mergeWithRaw(model.localName),
                            emails: mergeEmails,
                            phones: mergePhones,
                            dob: dob?.mergeWithRaw(model.dob),
                            address: address?.mergeWithRaw(model.address),
                            nationality: nationality?.mergeWithRaw(model.nationality),
                            giid: giid?.mergeWithRaw(model.giid))
        
    }
    
    public func clone() -> CCProfileModel {
        
        let clonePhones = phones?.map { p -> CCPhoneModel in
            return p.clone()
        }
        
        let cloneEmails = emails?.map { m -> CCEmailModel in
            return m.clone()
        }
        
        return CCProfileModel(name: name?.clone(),
                            localName: localName?.clone(),
                            emails: cloneEmails,
                            phones: clonePhones,
                            dob: dob?.clone(),
                            address: address?.clone(),
                            nationality: nationality?.clone(),
                            giid: giid?.clone())
    }
    
    /**
     * Decrypted to raw model with encryption key
     */
    public func decrypted(encryption: Encryption) -> CCProfileModel {
        let decryptedPhones = phones?.map { p -> CCPhoneModel in
            return p.decrypted(encryption: encryption)
        }
        
        let decryptedEmails = emails?.map { m -> CCEmailModel in
            return m.decrypted(encryption: encryption)
        }
        
        return CCProfileModel(name: name?.decrypted(encryption: encryption),
                            localName: localName?.decrypted(encryption: encryption),
                            emails: decryptedEmails,
                            phones: decryptedPhones,
                            dob: dob?.decrypted(encryption: encryption),
                            address: address?.decrypted(encryption: encryption),
                            nationality: nationality?.decrypted(encryption: encryption),
                            giid: giid?.decrypted(encryption: encryption))
    }
}
