//
//  String+Extension.swift
//  Credify
//
//  Created by Nalou Nguyen on 05/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
import CommonCrypto
import CredifyCryptoSwift

private class DummyClass {}

public extension String {
    /// Return a text defined in localization files depending upon a location of each user.
    public func localized(bundle: Bundle = .main, tableName: String = "Localizable", defaultValue: String = "") -> String {
        let b = Bundle(for: DummyClass.self)
        var dv = defaultValue
        if defaultValue.isEmpty {
            dv = "**\(self)**"
        }
        return NSLocalizedString(self, tableName: tableName, bundle: b, value: dv, comment: "")
    }
    
    /// Validates a name format, allowing UTF-8.
    func checkName() throws -> String {
        if self.isEmpty {
            throw CCError.validationError(message: "Empty".localized(tableName: "Validator"))
        }
        
        // let nameRegEx = "^[\\p{L}'][\\p{L}' ]{1,}$" more than 1 char
        let nameRegEx = "^[\\p{L}'][\\p{L}' ]{0,}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        let isValid = nameTest.evaluate(with: self)
        if !isValid {
            throw CCError.validationError(message: "NameFormatInvalid".localized(tableName: "Validator"))
        }
        return self
    }
    
    /// Validates an email address format.
    func checkEmail() throws -> String {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValid = emailTest.evaluate(with: self)
        if !isValid {
            throw CCError.validationError(message: "EmailFormatInvalid".localized(tableName: "Validator"))
        }
        
        return self
    }
    
    /// Validates a 12-word mnemonic.
    func checkMnemonicPhrase() throws -> String {
        if self.isEmpty {
            throw CCError.validationError(message: "Empty".localized(tableName: "Validator"))
        }
        
        if self.contains(",") {
            throw CCError.validationError(message: "MnemonicFormatInvalid".localized(tableName: "Validator"))
        }
        
        let words = self.components(separatedBy: " ")
        if words.count != 12 {
            throw CCError.validationError(message: "MnemonicCountInvalid".localized(tableName: "Validator"))
        }
        
        return self
    }
    
    /// Validates a birthday format. Not allowing the current year.
    func checkDOB() throws -> String {
        if self.isEmpty {
            return self
        }
        
        let arr = self.components(separatedBy: "/")
        if arr.count != 3 {
            throw CCError.validationError(message: "DOBFormatInvalid".localized(tableName: "Validator"))
        }
        
        let calendar = Calendar.current
        let date = Date()
        let components = calendar.dateComponents([.year], from: date)
        guard let year =  components.year else {
            throw CCError.validationError(message: "DateError".localized(tableName: "Validator"))
        }
        
        guard let yyyy = Int(arr[0]), let mm = Int(arr[1]), let dd = Int(arr[2]) else {
            throw CCError.validationError(message: "DOBFormatInvalid".localized(tableName: "Validator"))
        }
        if yyyy >= year || yyyy < 1900 {
            throw CCError.validationError(message: "InvalidYear".localized(tableName: "Validator"))
        }
        if mm > 12 || mm < 1 {
            throw CCError.validationError(message: "InvalidMonth".localized(tableName: "Validator"))
        }
        
        // TODO: Should consider Feb, Apr, Jun, Sep, Nov (not 31 days)
        // TODO: refactor to use DataFormatter
        if dd > 31 || dd < 1 {
            throw CCError.validationError(message: "InvalidDay".localized(tableName: "Validator"))
        }
        
        return self
    }
    
    /// Validates password
    func checkPassword() throws -> String {
        // NOTE: allow text and number and special characters with length >= 8
        let regex = "^[\\p{L}\\p{Nl}\\p{Nd}\\P{C}]{8,}$"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = test.evaluate(with: self)
        if !isValid {
            throw CCError.validationError(message: "InvalidPassword".localized(tableName: "Validator"))
        }
        return self
    }
    
    /// Validates string
    func checkOnlyString() throws -> String {
        if self.isEmpty {
            throw CCError.validationError(message: "Empty".localized(tableName: "Validator"))
        }
        
        let nameRegEx = "^\\p{L}{1,}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        let isValid = nameTest.evaluate(with: self)
        
        if !isValid {
            throw CCError.validationError(message: "StringFormatInvalid".localized(tableName: "Validator"))
        }
        
        return self
    }
    
    func toDate() -> Date? {
        Date.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return Date.formatter.date(from: self)
    }
    
    /// Converts self to Data
    func toData() -> Data? {
        return self.data(using: .utf8, allowLossyConversion: true)
    }
    
    /// Removes unnessary spaces
    func trim() -> String {
        return self.components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    /// Remove white spaces in self
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    /// Removes 0 if it has as a prefix
    func cutPrefixZero() -> String {
        var tmp = self
        if tmp.hasPrefix("0") {
            tmp.remove(at: tmp.startIndex)
        }
        return tmp
    }
    
    /// Generates sha256 hashed value in Base64 URL encoded format
    func sha256() -> String{
        return CryptoHelpers.sha256(message: self)
    }
    
    func isEOSAddress() -> Bool {
        var target = self
        if self.hasPrefix("eos:") {
            target = self.components(separatedBy: ":")[1]
        }
        let regEx = "[0-5a-z]{12}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        let isValid = test.evaluate(with: target)
        return isValid
    }
    
    func isETHAddress() -> Bool {
        var target = self
        if self.hasPrefix("ethereum:") {
            target = self.components(separatedBy: ":")[1]
        }
        let ethRegEx = "^(0x)?[0-9a-fA-F]{40}$"
        let ethTest = NSPredicate(format:"SELF MATCHES %@", ethRegEx)
        let isValid = ethTest.evaluate(with: target)
        return isValid
    }
    
    func isBTCAddress() -> Bool {
        var target = self
        if self.hasPrefix("bitcoin:") {
            target = self.components(separatedBy: ":")[1]
        }
        #if PRODUCTION
        let regEx = "^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        let isValid = test.evaluate(with: target)
        return isValid
        #else
        let regEx = "[a-zA-Z0-9]{25,56}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        let isValid = test.evaluate(with: target)
        return isValid
        #endif
    }
    
    func isXRPAddress() -> Bool {
        let allowed = "rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz"
        let regEx = "^r[\(allowed)]{27,35}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        let isValid = test.evaluate(with: self)
        return isValid
    }
    
    // MARK: - Private methods

    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }

    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)

        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }

        return hexString
    }
    
    // Extension with phone number format: [contry code] [4 digits] [4 digits]
    func phoneNumberFormat() -> String {
        let pattern = "#### #### ###"
        let replacmentCharacter: Character = "#"
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    func convertToMetadataDictionary() -> [String: CCMetadataType]? {
        if let data = self.data(using: .utf8) {
            return try? JSONDecoder().decode([String: CCMetadataType].self, from: data)
        }
        return nil
    }
}

