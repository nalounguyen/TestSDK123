//
//  Encodable+Extension.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
