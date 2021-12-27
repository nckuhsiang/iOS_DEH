//
//  TextAlert.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/12/3.
//  Copyright © 2021 mmlab. All rights reserved.
//

import Foundation
import SwiftUI
public struct TextAlert {
    public var title: String // Title of the dialog
    public var message: String // Dialog message
    public var placeholder: String = "" // Placeholder text for the TextField
    public var accept: String = "OK".localized // The left-most button label
    public var cancel: String? = "Cancel".localized // The optional cancel (right-most) button label
    public var secondaryActionTitle: String? = nil // The optional center button label
    public var keyboardType: UIKeyboardType = .default // Keyboard tzpe of the TextField
    public var action: (String?) -> Void // Triggers when either of the two buttons closes the dialog
    public var secondaryAction: (() -> Void)? = nil // Triggers when the optional center button is tapped
    public var existAccount:String = "Do you have account?".localized
}
