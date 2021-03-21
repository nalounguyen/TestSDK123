//
//  String+Extension.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation
import CommonCrypto
import CredifyCryptoSwift

private class DummyClass {}

extension String {
    /// Return a text defined in localization files depending upon a location of each user.
    func localized(bundle: Bundle = .main, tableName: String = "Localizable", defaultValue: String = "") -> String {
        let b = Bundle(for: DummyClass.self)
        var dv = defaultValue
        if defaultValue.isEmpty {
            dv = "**\(self)**"
        }
        return NSLocalizedString(self, tableName: tableName, bundle: b, value: dv, comment: "")
    }
    
    func toDate() -> Date? {
        Date.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return Date.formatter.date(from: self)
    }
    
    /// Generates sha256 hashed value
    public func sha256() -> String{
        return CryptoHelpers.sha256(message: self)
    }
    
    /// Validates password
    func checkPassword() throws -> String {
        // NOTE: allow text and number and special characters with length >= 8
        let regex = "^[\\p{L}\\p{Nl}\\p{Nd}\\P{C}]{8,}$"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = test.evaluate(with: self)
        if !isValid {
            throw CustomError.validationError(message: "InvalidPassword".localized(bundle: Bundle.CredifyKit, tableName: "Validator"))
        }
        return self
    }
}


