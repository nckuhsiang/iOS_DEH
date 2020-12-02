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
//            .padding([.top, .leading, .trailing])
            //                        .frame(height: 30.0)
            //                        .offset(x:0,y:5)
            
            
            List{
                Text("Hello, World")
                Text("Hello, World")
                Text("Hello, World")
                Text("Hello, World")
                
//                .padding()
            }
//        .padding()
        }
        .tabItem{
            Image("member_favorite")
            Text("favorite")
                .foregroundColor(.white)
        }
        .background(Color.init(UIColor(rgba: lightGreen)))
    }
}

struct TabViewElement_Previews: PreviewProvider {
    static var previews: some View {
        TabViewElement(title: "page2", image1: "member_grouplist", image2: "search")
    }
}
