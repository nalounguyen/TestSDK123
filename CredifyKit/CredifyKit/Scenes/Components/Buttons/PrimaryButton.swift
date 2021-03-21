//
//  PrimaryButton.swift
//  Credify
//
//  Created by Shuichi Nagao on 2020/06/13.
//  Copyright © 2020 Credify. All rights reserved.
//

import UIKit

class PrimaryButton: CredifyButton {
    override var startColor: UIColor {
        get {
            return UIColor.ex.primary
        }
        set {
            super.startColor = newValue
        }
    }
    
    override var endColor: UIColor {
        get {
            return UIColor.ex.primaryDarker
        }
        set {
            super.endColor = newValue
        }
    }
    
    override var cornerRadius: Double {
        get {
            return 24
        }
        set {
            super.cornerRadius = newValue
        }
    }
    
    override var horizontalMode: Bool {
        get {
            return true
        }
        set {
            super.horizontalMode = newValue
        }
    }
}
