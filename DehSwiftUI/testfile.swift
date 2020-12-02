//
//  testfile.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/2.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI

// 1.
struct People: Identifiable{
    var id  = UUID()
    var name = String()
}

struct ContentView: View {
    // 2.
    let people: [People] = [
        People(name: "Bill"),
        People(name: "Jacob"),
        People(name: "Olivia")]
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
        
        //        UITableView.appearance().tableFooterView = UIView()
        //        UITabBar.appearance().backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        //        UITabBar.appearance().backgroundColor = .clear
        
        //        UITabBar.appearance().isOpaque = true
        //            UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(rgba: lightGreen)
        UINavigationBar.appearance().backgroundColor = UIColor(rgba: darkGreen)
    }
    var body: some View {
        
        NavigationView {
            // 3.
            TabView{
                List(people) { listedPeople in
                    NavigationLink(destination: DetailView(name: listedPeople.name)) {
                        VStack(alignment: .leading){
                            Text(listedPeople.name)
                        }
                    }
                }
            }
            .tabItem{
            Image("member_favorite")
            Text("favorite")
                .foregroundColor(.white)
            }
            .edgesIgnoringSafeArea(.top)
            // 4.
            //            .navigationBarItems(leading:
            //            HStack {
            //                Button(action: {}) {
            //                    Image(systemName: "minus.square.fill")
            //                        .font(.largeTitle)
            //                }.foregroundColor(.pink)
            //            }, trailing:
            //            HStack {
            //                Button(action: {}) {
            //                    Image(systemName: "plus.square.fill")
            //                        .font(.largeTitle)
            //                }.foregroundColor(.blue)
            //            })
            //                // 5.
            //                .navigationBarTitle(Text("Names"))
        }
    }
}
// 6.
struct DetailView: View {
    var name: String
    
    var body: some View {
        Text("current name is: \(name) ")
            // 7.
            .navigationBarTitle(Text("Current Name"), displayMode: .inline)
    }
}

struct testfile_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
