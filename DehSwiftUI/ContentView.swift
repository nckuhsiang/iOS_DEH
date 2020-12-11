//
//  ContentView.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/1.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    init(){
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }
//        let request = AF.request("https://swapi.dev/api/films")
//            // 2
//            request.responseJSON { (data) in
//              print(data)
//            }
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        //list底下的背景色
        UITableView.appearance().backgroundColor = UIColor(rgba:darkGreen)
        
//        UITableViewCell.appearance().backgroundColor = .green
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
    
    @State var selection: Int? = nil
    var body: some View {
        NavigationView {
            
            VStack(spacing: 0){
                TabView{
                    TabViewElement(title: "page2", image1: "member_grouplist", image2: "search",tabItemImage: "member_favorite",tabItemName: "favorite")
                    TabViewElement(title: "page3", image1: "member_grouplist", image2: "search",tabItemImage:"member_searched",tabItemName: "nearby")
                    TabViewElement(title: "page4", image1: "member_grouplist", image2: "search",tabItemImage:"member_group",tabItemName:"group")
                    TabViewElement(title: "page5", image1: "member_grouplist", image2: "search",tabItemImage:"member_interests",tabItemName:"mine")
                }
            }
            .navigationBarTitle(Text("HI, " + nameText), displayMode: .inline)
            .navigationBarItems(leading: NavigationLink(destination: Setting(), tag: 1, selection: $selection) {
                Button(action: {
                    print("setting tapped")
                    self.selection = 1
                }) {
                    Image("member_setting")
                }
            }
            
            ,trailing: NavigationLink(destination: Map(), tag: 2, selection: $selection) {
                Button(action: {
                    print("map tapped")
                    self.selection = 2
                }) {
                    Image("member_back")
                }
            })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SettingStorage())
    }
}
