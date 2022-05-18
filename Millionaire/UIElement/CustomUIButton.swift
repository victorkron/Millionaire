//
//  CustomUIButton.swift
//  Millionaire
//
//  Created by Карим Руабхи on 19.05.2022.
//

import UIKit

/*@IBDesignable*/ class CustomUIButton: UIButton {
    
    var id: Int = -1
    var didTap: Bool = false
    private let border = CAShapeLayer()
    
    // Allows developer to edit what colors are shown in each state
    @IBInspectable var borderColor: UIColor = UIColor.purple
    
    // Width of Dashed/Solid Border
    @IBInspectable var borderWidth: CGFloat = 0
    // Radius of corners of the button
    @IBInspectable var cornerRadius: CGFloat = 10
    
    // The text that's shown in each state
    @IBInspectable var selectedText: String = "Selected"
    @IBInspectable var deselectedText: String = "Deselected"
    
    // The color of text shown in each state
    @IBInspectable var textColor: UIColor = UIColor.lightGray
    @IBInspectable var layerBackgroundColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    
    // Sets the Active/Inactive State
    @IBInspectable var active: Bool = false

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        border.lineWidth = borderWidth
        border.frame = self.bounds
        border.fillColor = layerBackgroundColor.cgColor
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        
        self.layer.addSublayer(border)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.tintColor = textColor
    }

}
