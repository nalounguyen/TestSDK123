//
//  Extension.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation

public struct Extension<Base> {
    let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
}

public protocol ExtensionCompatible {
    associatedtype Compatible
    static var ex: Extension<Compatible>.Type { get }
    var ex: Extension<Compatible> { get }
}

public extension ExtensionCompatible {
    static var ex: Extension<Self>.Type {
        return Extension<Self>.self
    }
    
    var ex: Extension<Self> {
        return Extension(self)
    }
}

extension Bundle {
    static var CredifyKit: Bundle {
        return Bundle(identifier: "one.credify.CredifyKit") ?? .main
    }
}
