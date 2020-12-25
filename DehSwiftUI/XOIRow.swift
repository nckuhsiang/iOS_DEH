//
//  LandmarkRow.swift
//  Landmarks
//
//  Created by 阮盟雄 on 2020/11/17.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct XOIRow: View {
    var xoi: XOI
    @State var selection: Int? = nil
    var body: some View {
        NavigationLink(destination:  XOIDetail(xoi:xoi), tag: 1, selection: $selection){
            HStack{
                Image(xoi.xoiCategory)
                Image(xoi.creatorCategory)
                Image(xoi.mediaCategory)
                Text(xoi.name)
                    .foregroundColor(Color.white)
                Spacer()
            }
            .background(Color.init(UIColor(rgba:darkGreen)))
            
        }
    }
}

