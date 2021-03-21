//
//  CredifyTextField.swift
//  Credify
//
//  Created by Shuichi Nagao on 2020/06/13.
//  Copyright © 2020 Credify. All rights reserved.
//

import UIKit
//import SkyFloatingLabelTextField

class CredifyTextField: SkyFloatingLabelTextField {
    override var tintColor: UIColor! {
        get {
            return UIColor.ex.primary
        }
        set {
            super.tintColor = newValue
        }
    }
    
    override var selectedTitleColor: UIColor {
        get {
            return UIColor.ex.primary
        }
        set {
            super.selectedTitleColor = newValue
        }
    }
    
    override var selectedLineColor: UIColor {
        get {
            return UIColor.ex.primary
        }
        set {
            super.selectedLineColor = newValue
        }
    }
    
    override var textColor: UIColor? {
        get {
            return UIColor.ex.primaryText
        }
        set {
            super.textColor = newValue
        }
    }
    
    override var titleColor: UIColor {
        get {
            return UIColor.ex.primaryText
        }
        set {
            super.titleColor = newValue
        }
    }
    
    override var placeholderColor: UIColor {
        get {
            return UIColor.ex.placeholderText
        }
        set {
            super.placeholderColor = newValue
        }
    }
    
    override var errorColor: UIColor {
        get {
            return UIColor.ex.error
        }
        set {
            super.errorColor = newValue
        }
    }
    
    override var lineColor: UIColor {
        get {
            return UIColor.ex.placeholderText
        }
        set {
            super.lineColor = newValue
        }
    }
    
    override var lineErrorColor: UIColor? {
        get {
            return UIColor.ex.error
        }
        set {
            super.lineErrorColor = newValue
        }
    }
}
