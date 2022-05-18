//
//  CustomUILabel.swift
//  Millionaire
//
//  Created by Карим Руабхи on 19.05.2022.
//

import UIKit

class CustomUILabel: UILabel {
    
    // Radius of corners of the button
    @IBInspectable var cornerRadius: CGFloat = 10
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }

}
