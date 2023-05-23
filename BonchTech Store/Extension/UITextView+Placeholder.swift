//
//  UITextView+Placeholder.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 21.04.2023.
//

import UIKit

extension UITextView {
    var placeholder: String? {
        get {
            return self.value(forKey: "placeholderLabel.text") as? String
        }
        set {
            if let placeholderLabel = self.value(forKey: "placeholderLabel") as? UILabel {
                placeholderLabel.text = newValue
            } else {
                let placeholderLabel = UILabel()
                placeholderLabel.text = newValue
                placeholderLabel.font = self.font
                placeholderLabel.sizeToFit()
                self.addSubview(placeholderLabel)
                placeholderLabel.frame.origin = CGPoint(x: 5, y: self.font!.pointSize / 2)
                placeholderLabel.textColor = UIColor.lightGray
                placeholderLabel.isHidden = !self.text.isEmpty
                self.setValue(placeholderLabel, forKey: "placeholderLabel")
            }
        }
    }
}


