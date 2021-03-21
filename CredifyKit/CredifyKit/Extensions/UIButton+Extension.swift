//
//  UIButton+Extension.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import UIKit

extension UIButton {

    ///Sets a solid background color for the button.
    func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: controlState)

    }

}
