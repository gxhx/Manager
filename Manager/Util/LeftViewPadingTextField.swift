//
//  LSTextField.swift
//  Manager
//
//  Created by sue on 2020/6/6.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import UIKit

class LeftViewPadingTextField: UITextField {

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var leftRect = super.leftViewRect(forBounds: bounds)
        leftRect.origin.x += 12;
        return leftRect;
    }

}
