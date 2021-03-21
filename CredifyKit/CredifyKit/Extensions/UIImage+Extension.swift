//
//  UIImage+Extension.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import UIKit

extension UIImage {
    static func named(_ name: String) -> UIImage? {
        UIImage(named: name, in: Bundle(identifier: "one.credify.CredifyKit"), compatibleWith:nil)
        
        
    }
}

