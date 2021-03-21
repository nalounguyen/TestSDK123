//
//  UIFont+Extension.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import UIKit

extension UIFont {
    public class func abeatbyKai(ofSize size: CGFloat = 22) -> UIFont {
        #if STAGING_ALLEX
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
        #elseif RELEASE_ALLEX
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
        #else
        return UIFont(name: "AbeatbyKai", size: size)!
        #endif
    }
    public class func quicksand(ofSize size: CGFloat = 17) -> UIFont {
        return UIFont(name: "Quicksand-Regular", size: size)!
    }
    /// This is default font for application. In future, if we need to change font, just change font name.
    static func secondaryFont(style: UIFont.Style = .regular, ofSize size: CGFloat = 17) -> UIFont {
        #if STAGING_ALLEX
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
        #elseif RELEASE_ALLEX
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
        #else
        switch style {
        case .thin:
            return UIFont(name: "RobotoSlab-Thin", size: size)!
        case .regular:
            return UIFont(name: "RobotoSlab-Regular", size: size)!
        case .medium:
            return UIFont(name: "RobotoSlab-Medium", size: size)!
        case .light:
            return UIFont(name: "RobotoSlab-Light", size: size)!
        case .bold:
            return UIFont(name: "RobotoSlab-Bold", size: size)!
        case .black:
            return UIFont(name: "RobotoSlab-Black", size: size)!
        }
        #endif
    }
    
    static func primaryFont(style: UIFont.Style = .regular, ofSize size: CGFloat = 17) -> UIFont {
        #if STAGING_ALLEX
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
        #elseif RELEASE_ALLEX
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
        #else
        switch style {
        case .thin:
            return UIFont(name: "Oswald-Regular", size: size)!
        case .regular:
            return UIFont(name: "Oswald-Regular", size: size)!
        case .medium:
            return UIFont(name: "Oswald-Regular", size: size)!
        case .light:
            return UIFont(name: "Oswald-Regular", size: size)!
        case .bold:
            return UIFont(name: "Oswald-Regular", size: size)!
        case .black:
            return UIFont(name: "Oswald-Regular", size: size)!
        }
        #endif
    }
    
    enum Style {
        case thin
        case regular
        case medium
        case light
        case bold
        case black
    }
}

extension UIFont: ExtensionCompatible {}

public extension Extension where Base: UIFont {
    static var navigationFont: UIFont {
        return UIFont.primaryFont(style: .regular, ofSize: 21)
    }
    
    static var buttonFont: UIFont {
        return UIFont.primaryFont(style: .regular, ofSize: 17)
    }
    
    static var sectionFont: UIFont {
        return UIFont.primaryFont(style: .regular, ofSize: 18)
    }
}

