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
        UITableView.appearance().backgroundColor = UIColor(rgba:"#24c08c")
        UITableViewCell.appearance().backgroundColor = .clear
        
//        UITableView.appearance().tableFooterView = UIView()
        UITabBar.appearance().backgroundColor = UIColor(rgba:"#24c08c")
//            UITabBar.appearance().isTranslucent = false
    }
    var body: some View {
        VStack{
            NavigationView {
                Text("123")
                    //                .navigationBarTitle("Welcome")
                    .navigationBarItems(trailing:
                        Button(action: {
                            print("User icon pressed...")
                        }){
                            Image("member_back")
                            .resizable()
                                .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                        }
                        .frame(width: 30, height: 30)
//                        .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
    
//                        .background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                        
                )
                
            }
            .edgesIgnoringSafeArea(.top)
//            .background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                .padding()
            TabView{
                List{
                    Text("Hello, World")
                }
                    .tabItem{
                        Image("member_favorite")
                }
                       
                List{
                    Text("Hello, World!")
                }
                    .tabItem{
                        Image("map_locate")
                }
                List{
                    Text("Hello, World!")
                }
                    .tabItem{
                        Image("member_group")
                }
                List{
                    Text("Hello, World!")
                }
                    .tabItem{
                        Image("member_interests")
                }
            }
        
        

        }

    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
