//
//  CustomTextField.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 29/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    //Prevent user pasting: https://stackoverflow.com/a/29596354/10623169
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return bounds.inset(by: padding)
    }
}

class NumericTextField: CustomTextField {
    let numericKbdToolbar = UIToolbar()
    
    // MARK: Initilization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    // Sets up the input accessory view with a Done button that closes the keyboard
    func initialize() {
        self.keyboardType = UIKeyboardType.numberPad
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            numericKbdToolbar.barStyle = UIBarStyle.default
            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let callback = #selector(NumericTextField.finishedEditing)
            let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: callback)
            donebutton.tintColor = .black
            numericKbdToolbar.setItems([space, donebutton], animated: false)
            numericKbdToolbar.sizeToFit()
            self.inputAccessoryView = numericKbdToolbar
        }
    }
    
    // MARK: On Finished Editing Function
    @objc func finishedEditing() {
        self.resignFirstResponder()
    }
}

extension UITextField {
    public convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
    }
    
    public convenience init(placeholder: String? = nil, font: UIFont? = UIFont.systemFont(ofSize: 14.0), textAlignment: NSTextAlignment? = nil, textColor: UIColor = .black, tintColor: UIColor = .black, borderWidth: CGFloat = 0.0, borderColor: UIColor = .black, cornerRadius: CGFloat = 0.0, autocorrectionType: UITextAutocorrectionType? = nil, keyboardType: UIKeyboardType? = nil, returnKeyType: UIReturnKeyType? = nil, clearButtonMode: UITextField.ViewMode? = nil, contentVerticalAlignment: UIControl.ContentVerticalAlignment? = nil, isSecureTextEntry: Bool = false) {
        self.init()
        self.placeholder = placeholder
        self.font = font
        if let textAlignment = textAlignment {
            self.textAlignment = textAlignment
        }
        self.textColor = textColor
        self.tintColor = tintColor
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        if let autocorrectionType = autocorrectionType {
            self.autocorrectionType = autocorrectionType
        }
        if let keyboardType = keyboardType {
            self.keyboardType = keyboardType
        }
        if let returnKeyType = returnKeyType {
            self.returnKeyType = returnKeyType
        }
        if let clearButtonMode = clearButtonMode {
            self.clearButtonMode = clearButtonMode
        }
        if let contentVerticalAlignment = contentVerticalAlignment {
            self.contentVerticalAlignment = contentVerticalAlignment
        }
        self.isSecureTextEntry = isSecureTextEntry
    }
}
