//
//  TextVIew.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/10/17.
//  Copyright © 2021 mmlab. All rights reserved.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var textStyle: UIFont.TextStyle
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.layer.borderWidth = 0.15
        textView.layer.cornerRadius = 5.0
        textView.isUserInteractionEnabled = true
        return textView
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
    
}
