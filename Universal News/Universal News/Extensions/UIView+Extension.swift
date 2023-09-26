//
//  UIView+Extension.swift
//  UN
//
//  Created by deniz on 10.09.2023.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {return cornerRadius}
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
