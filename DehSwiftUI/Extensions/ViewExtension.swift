//
//  ViewExtension.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/15.
//  Copyright © 2020 mmlab. All rights reserved.
//https://github.com/George-J-E/HidingViews

import Foundation
import SwiftUI
//to hide view without error
extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
extension String {
    func hidden(_ shouldHide: Bool) ->String{
        switch shouldHide {
        case true: return ""
        case false: return self
        }
    }
}
