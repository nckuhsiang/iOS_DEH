//
//  XOIDetail.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/2.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI

struct XOIDetail: View {
    var xoi: XOI
    var body: some View{
        VStack {
            MapView(coordinate: xoi.locationCoordinate)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            
            CircleImage(image: Image("audio_picture"))
                .offset(x: 0, y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack(){
                    Text(xoi.name)
                        .font(.title)
                    
                    Spacer()
                    
                    Image("user")
                    
                    Button(action: {
                        print("button pressed")
                    }) {
                        Image("heart")
                    }
                    
                    Button(action: {
                        print("button pressed")
                    }) {
                        Image("more")
                    }
                }
                HStack {
                    Text("Voice Commentary")
                        .foregroundColor(Color.white)
                    Spacer()
                    Image("speaker")
                }
                .frame(height: 30.0)
                .background(Color.init(UIColor(rgba:"#24c08c")))
                Text("View Numbers: " + String(xoi.viewNumbers))
                Text(xoi.detail)
            }
            .padding()
            
            
            Spacer()
            
            
        }
    }
}
struct XOIDetail_Previews:
PreviewProvider {
    static var previews: some View {
        XOIDetail(xoi:XOI(id: 0, name: "name", latitude: 0.0, longitude: 0.0, creatorCategory: "player",  xoiCategory: "poi", detail: "Testing", viewNumbers: 100))
    }
}

