//
//  Array+Extension.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}

extension Array where Element: Encodable {
    func asArrayDictionary() throws -> [[String: Any]] {
        var data: [[String: Any]] = []

        for element in self {
            data.append(try element.asDictionary())
        }
        return data
    }
}
