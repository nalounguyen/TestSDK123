//
//  CredifyGradientLabel.swift
//  Credify
//
//  Created by Nalous Nguyen on 12/9/20.
//  Copyright © 2020 Credify. All rights reserved.
//

import UIKit

@IBDesignable
class CredifyGradientLabel: GradientLabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        self.startColor = UIColor.ex.primary
        self.endColor = UIColor.ex.primaryDarker
        self.horizontalGradientMode = true
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.startColor = UIColor.ex.primary
        self.endColor = UIColor.ex.primaryDarker
        self.horizontalGradientMode = true
    }

}
