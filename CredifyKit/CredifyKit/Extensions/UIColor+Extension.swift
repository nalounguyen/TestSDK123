//
//  UIColor+Extension.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import UIKit

extension UIColor {
    static func named(_ name: String) -> UIColor? {
        
        return UIColor(named: name, in: Bundle(identifier: "one.credify.CredifyKit"), compatibleWith: nil)
    }
}

extension UIColor: ExtensionCompatible {}

public extension Extension where Base: UIColor {
    static var backgroundDark: UIColor {
        return UIColor.named("BackgroundDark")!
    }
    
    static var backgroundLight: UIColor {
        return UIColor.named("BackroundLight")!
    }
    
    static var primary: UIColor {
        return UIColor.named("Primary")!
    }
    
    static var primaryDarker: UIColor {
        return UIColor.named("Primary Darker")!
    }
    
    static var secondary: UIColor {
        return UIColor.named("Secondary")!
    }
    
    static var secondaryDarker: UIColor {
        return UIColor.named("Secondary Darker")!
    }
    
    static var text: UIColor {
        return UIColor.named("Text")!
    }
    
    static var error: UIColor {
        return UIColor.named("Error")!
    }
    
    static var primaryText: UIColor {
        return UIColor.named("Primary Text")!
    }
    
    static var secondaryText: UIColor {
        return UIColor.named("Secondary Text")!
    }
    
    static var placeholderText: UIColor {
        return UIColor.named("Placeholder Text")!
    }
    
    static var buttonText: UIColor {
        return UIColor.named("Button Text")!
    }
    
    static var grayText: UIColor {
        return UIColor.named("Text Gray")!
    }
    
    static var black: UIColor {
        return UIColor.named("Black")!
    }
    
    static var blue: UIColor {
        return UIColor.named("Blue")!
    }
    
    static var boundaryBlack: UIColor {
        return UIColor.named("BoundaryBlack")!
    }
    
    static var boundaryWhite: UIColor {
        return UIColor(named: "BoundaryWhite")!
    }
    
    static var darkRed: UIColor {
        return UIColor.named("DarkRed")!
    }
    
    static var gray: UIColor {
        return UIColor.named("Gray")!
    }
    
    static var green: UIColor {
        return UIColor.named("Green")!
    }
    
    static var lightBlue: UIColor {
        return UIColor.named("LightBlue")!
    }
    
    static var lightGreen: UIColor {
        return UIColor.named("LightGreen")!
    }
    
    static var lightYellow: UIColor {
        return UIColor.named("LightYellow")!
    }
    
    static var loadingBackground: UIColor {
        return UIColor.named("LoadingBackground")!
    }
    
    static var orange: UIColor {
        return UIColor.named("Orange")!
    }
    
    static var purple: UIColor {
        return UIColor.named("Purple")!
    }
    
    static var red: UIColor {
        return UIColor.named("Red")!
    }
    
    static var white: UIColor {
        return UIColor.named("White")!
    }
    
    static var lightGray: UIColor {
        return UIColor.named("LightGray")!
    }
    
    static var borderLightGray: UIColor {
        return UIColor.named("borderLightGay")!
    }
    
    static var largeTitleNavPrimary: UIColor {
        return UIColor.named("Primary Large Title Nav")!
    }
}

