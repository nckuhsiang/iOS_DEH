//
//  TabViewElement.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/2.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI

struct TabViewElement: View {
    var title: String
    var image1: String
    var image2: String
    var tabItemImage: String
    var tabItemName: String
    var body: some View {

        VStack{
            
            HStack{
                Text(title)
                    .foregroundColor(Color.white)
                Spacer()
                Button(action: {
                    print("User icon pressed...")
                }){
                    Image(image1)
                }
                Button(action: {
                    print("User icon pressed...")
                }){
                    Image(image2)
                }
            }
            .padding([.top, .leading, .trailing])
            List{
                ForEach(testxoi){xoi in
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
    }
}
