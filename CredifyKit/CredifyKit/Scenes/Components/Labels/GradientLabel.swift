//
//  GradientLabel.swift
//  Credify
//
//  Created by Nguyen Nam Long on 9/28/20.
//  Copyright © 2020 Credify. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientLabel: UILabel {
    @IBInspectable var startColor:   UIColor = UIColor.ex.black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = UIColor.ex.white { didSet { updateColors() }}
    @IBInspectable var horizontalGradientMode: Bool = false { didSet { updateGradient() }}

    private var gradientColors: [CGColor] = []

    
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        self.textColor = drawGradientColor(in: rect, colors: gradientColors)
    }

    private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        if horizontalGradientMode {
            context?.drawLinearGradient(gradient,
                                        start: CGPoint.zero,
                                        end: CGPoint(x: size.width, y: 0),
                                        options: [])
        }else {
            context?.drawLinearGradient(gradient,
                                        start: CGPoint(x: size.width, y: 0),
                                        end: CGPoint(x: size.width, y: size.height),
                                        options: [])
        }
        
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
    
    
    func updateColors() {
        self.gradientColors    = [startColor.cgColor, endColor.cgColor]
        self.updateGradient()
    }
    
    func updateGradient() {
        self.textColor = self.drawGradientColor(in: self.bounds, colors: gradientColors)
    }
}
