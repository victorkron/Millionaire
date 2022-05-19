//
//  CustomUILabel.swift
//  Millionaire
//
//  Created by Карим Руабхи on 19.05.2022.
//

import UIKit

class CustomUILabel: UILabel {
    
    private var width = 0
    private var height = 0
    let duration = 3.0
    
    
    // Radius of corners of the button
    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = (UIColor(red: 0.2, green: 0.3, blue: 0.4, alpha: 1.0))
    @IBInspectable var doAnimation: Bool = false
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
        super.draw(rect)
        self.layer.masksToBounds = true
    }
}
