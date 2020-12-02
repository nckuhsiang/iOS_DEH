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
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
        UITableView.appearance().backgroundColor = UIColor(rgba:darkGreen)
        UITableViewCell.appearance().backgroundColor = .clear
        //解決tab bar半透明的問題
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(rgba: lightGreen)
        
        UINavigationBar.appearance().backgroundColor = UIColor(rgba: darkGreen)
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
//                    VStack{
//
//                        HStack{
//                            Text("page1")
//                                .foregroundColor(Color.white)
//                            Spacer()
//                            Button(action: {
//                                print("User icon pressed...")
//                            }){
//                                Image("member_grouplist")
//                            }
//                            Button(action: {
//                                print("User icon pressed...")
//                            }){
//                                Image("search")
//                            }
//                        }
//                        .padding([.top, .leading, .trailing])
////                        .frame(height: 30.0)
////                        .offset(x:0,y:5)
//
//
//                        List{
//                            Text("Hello, World")
//                        }
//                    }
//                    .tabItem{
//                        Image("member_favorite")
//                        Text("favorite")
//                            .foregroundColor(.white)
//                    }
//                    .background(Color.init(UIColor(rgba: lightGreen)))
                    TabViewElement(title: "page1", image1: "member_grouplist", image2: "search")
                    TabViewElement(title: "page1", image1: "member_grouplist", image2: "search")
                    TabViewElement(title: "page1", image1: "member_grouplist", image2: "search")
                    TabViewElement(title: "page1", image1: "member_grouplist", image2: "search")
//                    VStack{
//                        HStack{
//                            Text("page2")
//                                .foregroundColor(Color.white)
//                            Spacer()
//                            Button(action: {
//                                print("User icon pressed...")
//                            }){
//                                Image("member_grouplist")
//                            }
//                            Button(action: {
//                                print("User icon pressed...")
//                            }){
//                                Image("search")
//                            }
//                        }
//                        .padding([.top, .leading, .trailing])
////                        .frame(height: 29.0)
////                        .offset(x:0,y:5)
//
//                        List{
//                            Text("Hello, World")
//                        }
//                    }
//                    .tabItem{
//                        Image("map_locate")
//                        Text("nearby")
//                            .foregroundColor(.white)
//                    }
//                    .background(Color.init(UIColor(rgba: lightGreen)))
//
//                    VStack{
//
//                        HStack{
//                            Text("page3")
//                                .foregroundColor(Color.white)
//                            Spacer()
//                            Button(action: {
//                                print("User icon pressed...")
//                            }){
//                                Image("member_grouplist")
//                            }
//                            Button(action: {
//                                print("User icon pressed...")
//                            }){
//                                Image("search")
//                            }
//                        }
//                        .padding([.top, .leading, .trailing])
//                        .frame(height: 29.998)
////                        .offset(x:0,y:5)
//
//
//                        List{
//                            Text("Hello, World")
//                        }
//                    }
//                    .tabItem{
//                        Image("member_group")
//                        Text("group")
//                            .foregroundColor(.white)
//                    }
//                    .background(Color.init(UIColor(rgba: lightGreen)))
//
//                    VStack{
//
//                        HStack{
//                            Text("page4")
//                                .foregroundColor(Color.white)
//                            Spacer()
//                            Button(action: {
//                                print("User icon pressed...")
//                            }){
//                                Image("member_grouplist")
//                            }
//                            Button(action: {
//                                print("User icon pressed...")
//                            }){
//                                Image("search")
//                            }
//                        }
//                        .padding([.top, .leading, .trailing])
//                        .frame(height: 29.997)
////                        .offset(x:0,y:5)
//                        List{
//                            Text("Hello, World")
//                        }
//                    }
//                    .tabItem{
//                        Image("member_interests")
//                        Text("mine")
//                            .foregroundColor(.white)
//                    }
//                    .background(Color.init(UIColor(rgba: lightGreen)))
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
