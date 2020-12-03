//
//  ContentView.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/1.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    init(){
//        if #available(iOS 14.0, *) {
//            // iOS 14 doesn't have extra separators below the list by default.
//        } else {
//            // To remove only extra separators below the list:
//            UITableView.appearance().tableFooterView = UIView()
//        }
//        
//        // To remove all separators including the actual ones:
//        UITableView.appearance().separatorStyle = .none
//        
//        UITableView.appearance().backgroundColor = UIColor(rgba:darkGreen)
//        UITableViewCell.appearance().backgroundColor = .clear
//        //解決tab bar半透明的問題
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().isTranslucent = true
//        UITabBar.appearance().backgroundColor = UIColor(rgba: lightGreen)
//        
//        UINavigationBar.appearance().backgroundColor = UIColor(rgba: darkGreen)
    }
    //帶有State 的變數可以動態變更ＵＩ上的值
    @State var nameText = "Guest"
    @State var searchTitle = "title"
    //若使用classModel的值則必須使用observation pattern
    //https://stackoverflow.com/questions/60744017/how-do-i-update-a-text-label-in-swiftui
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                HStack{
                    Button(action: {
                        print("User icon pressed...")
                    }){
                        Image("member_setting")
                    }
                    Spacer()
                    Text("HI, " + nameText)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                    Spacer()
                    Button(action: {
                        print("User icon pressed...")
                    }){
                        Image("member_back")
                    }
                }
                .padding()
                .background(Color.init(UIColor(rgba: darkGreen)))
                TabView{
                    TabViewElement(title: "page2", image1: "member_grouplist", image2: "search")
                    TabViewElement(title: "page3", image1: "member_grouplist", image2: "search")
                    TabViewElement(title: "page4", image1: "member_grouplist", image2: "search")
//                    VStack{
//                        HStack{
//                            Text("123")
//                        }
//                    List{
//                        Text("123")
//                    }
//                        Text("123")
//                    }
//                    .tabItem{
//                        Image("member_favorite")
//                        Text("favorite")
//                            .foregroundColor(.white)
//                    }
//                    VStack{
//                        HStack{
//                            Text("123")
//                        }
//                    List{
//                        Text("123")
//                    }
//                        Text("12")
//                    }
//                    .tabItem{
//                        Image("member_favorite")
//                        Text("favorite")
//                            .foregroundColor(.white)
//                    }
                }
                .navigationBarItems(leading:
                    Image("heart"))
            }
            
        }
            
            
            
            //            .navigationBarTitle("Welcome")
            
            //        .navigationBarItems(trailing:
            //            Button(action: {
            //                print("User icon pressed...")
            //            }){
            //                Image("heart")
            //                    .resizable()
            //                    .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
            //            }
            //            .frame(width: 30, height: 30)
            //            //                        .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
            //
            //            //                        .background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
            //
            //        )
            //        .navigationBarTitle("Welcome")
            
            
            
            .edgesIgnoringSafeArea(.top)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
