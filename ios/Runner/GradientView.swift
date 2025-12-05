//
//  GradientView.swift
//  Runner
//
//  Created by Girish J. Chauhan on 12/11/25.
//

import UIKit

@IBDesignable
class GradientView:UIView {
    
    
    @IBInspectable var startColor: UIColor = .systemPink {
            didSet { setNeedsLayout() }
        }
    @IBInspectable var endColor: UIColor = .systemPurple {
            didSet { setNeedsLayout() }
        }

        @IBInspectable var startPointX: CGFloat = 0.0 {
            didSet { setNeedsLayout() }
        }
    @IBInspectable var startPointY: CGFloat = 0.0 {
            didSet { setNeedsLayout() }
        }

        @IBInspectable var endPointX: CGFloat = 1.0 {
            didSet { setNeedsLayout() }
        }

        @IBInspectable var endPointY: CGFloat = 1.0 {
            didSet { setNeedsLayout() }
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            setupGradient()
        }
    private func setupGradient() {
            // Remove existing gradient if reloaded
            layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            gradient.startPoint = CGPoint(x: startPointX, y: startPointY)
            gradient.endPoint = CGPoint(x: endPointX, y: endPointY)
            gradient.cornerRadius = layer.cornerRadius

            layer.insertSublayer(gradient, at: 0)
        }
}

