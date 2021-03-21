//
//  UITextField+fixCaretPosition.swift
//  Credify
//
//  Created by ShuichiNagao on 2019/10/29.
//  Copyright © 2019 Credify. All rights reserved.
//

// ref: https://github.com/Skyscanner/SkyFloatingLabelTextField/blob/master/Sources/UITextField%2BfixCaretPosition.swift

import UIKit

extension UITextField {
    /// Moves the caret to the correct position by removing the trailing whitespace
    func fixCaretPosition() {
        // Moving the caret to the correct position by removing the trailing whitespace
        // http://stackoverflow.com/questions/14220187/uitextfield-has-trailing-whitespace-after-securetextentry-toggle
        let beginning = beginningOfDocument
        selectedTextRange = textRange(from: beginning, to: beginning)
        let end = endOfDocument
        selectedTextRange = textRange(from: end, to: end)
    }
}
