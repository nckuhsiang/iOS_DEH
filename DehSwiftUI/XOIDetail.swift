//
//  XOIDetail.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/2.
//  Copyright © 2020 mmlab. All rights reserved.
// MARK:- Mastery swiftui chapter 19 for multiple image

import SwiftUI
struct XOIDetail: View {
    var xoi: XOI
    //only for favorite used
    @EnvironmentObject var settingStorage:SettingStorage
    @State var isFavorite = false
    var body: some View{
        
        VStack {
            ZStack{
                Image("audio_picture")
            }
            
            VStack(alignment: .leading) {
                HStack(){
                    Text(xoi.name)
                        .font(.title)
                    
                    Spacer()
                    
                    Image(xoi.creatorCategory)
                    
                    Button(action: {
                        print("favorite pressed")
                        // if exist then remove or not exist then add
                        if let index = settingStorage.XOIs["favorite"]?.firstIndex(of: xoi){
                            settingStorage.XOIs["favorite"]?.remove(at: index)
                            isFavorite = false
                        }
                        else{
                            settingStorage.XOIs["favorite"]?.append(xoi)
                        }
                        
                    }) {
                        Image("heart")
                        
                    }
                    
                    Button(action: {
                        print("more pressed")
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
        XOIDetail(xoi:testxoi[0])
            .environmentObject(SettingStorage())
    }
}

