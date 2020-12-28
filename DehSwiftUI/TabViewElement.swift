//
//  TabViewElement.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/2.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI
import Combine

struct TabViewElement: View {
    var title: String
    var image1: String
    var image2: String
    var tabItemImage: String
    var tabItemName: String
    @EnvironmentObject var settingStorage:SettingStorage
//    let xoiHandler = XOIHandler()
    var body: some View {
        
        VStack{
            
            HStack{
                Text(title)
                    .foregroundColor(Color.white)
                Spacer()
                Button(action: {
                    print("User icon pressed...")
                }){
                    Image(image1).hidden(image1=="Empty")
                }
                .disabled(image1=="Empty")
                
                Button(action: {
                    print("User icon pressed...")
//                    self.settingStorage.XOIs[tabItemName]?.append(testxoi[0])
                    XOIHandler(x: settingStorage).getPOI()
                }){
                        Image(image2).hidden(image2=="Empty")
                }
                .disabled(image2=="Empty")
            }
            .padding([.top, .leading, .trailing])
            List{
                ForEach(self.settingStorage.XOIs[tabItemName] ?? []){xoi in
                    XOIRow(xoi:xoi)
                        .padding(.horizontal)
                }
                .listRowBackground(Color.init(UIColor(rgba: darkGreen)))
            }
        }
        .background(Color.init(UIColor(rgba: lightGreen)))
        .tabItem{
            Image(tabItemImage)
            Text(tabItemName)
                .foregroundColor(.white)
        }
    }
}

struct TabViewElement_Previews: PreviewProvider {
    static var previews: some View {
        TabViewElement(title: "page2", image1: "member_grouplist", image2: "search",tabItemImage: "member_favorite",tabItemName: "favorite")
            .environmentObject(SettingStorage())
    }
}

