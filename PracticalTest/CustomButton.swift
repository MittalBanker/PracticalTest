//
//  String+Extra.swift
//  PracticalTest
//
//  Created by Mittal Banker on 30/09/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable public class CustomButton: UIButton {

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 2.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }
}
