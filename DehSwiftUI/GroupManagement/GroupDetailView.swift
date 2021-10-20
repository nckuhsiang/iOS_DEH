//
//  GroupDetailView.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/10/17.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI

struct GroupDetailView: View {
    
    @State var state:Bool
    @State var group:Group
    @State private var textStyle = UIFont.TextStyle.body
    @EnvironmentObject var settingStorage:SettingStorage
    
    init(_ group:Group,_ state:Bool) {
        self.group = group
        self.state = true
        
    }
    var body: some View {
        TabView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Group name：")
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .padding(.leading)
                        .padding(.top)
                                    
                    TextField("", text: $group.name)
                        .textFieldStyle(.roundedBorder)
                        .padding(.trailing)
                        .padding(.top)
                        .disabled(state)
                        .onAppear {setting()}
                        
                }
                Text("Group information：")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .textFieldStyle(.roundedBorder)
                    .padding(.top)
                    .padding(.leading)
                TextView(text: $group.info, textStyle: $textStyle)
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .disabled(state)
                    .onAppear {setting()}
                ZStack {
                    Button {
                    } label: {
                        Text(isCreater() ? "Create":"Edit")
                            .frame(minWidth:50, minHeight: 30)
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .padding(.horizontal)
                            .foregroundColor(.black)
                            .background(Color.orange)
                            .disabled(state)
                            .hidden(state)
                            .onAppear {setting()}
                    }
                    .padding()
                }
                
            }
                .tabItem {
                    Image("file")
                    Text("Group info")
                }
            Text("test")
                .tabItem {
                    Image("groupmember")
                    Text("Group member")
                }
        
        }
    }
}
extension GroupDetailView {
    func isLeader() -> Bool{
        if(settingStorage.userID == String(group.leaderId)) {return true}
        else {return false}
    }
    func isCreater() -> Bool {
        if(group.id == -1) {return true}
        else {return false}
    }
    func setting() {
        if(isLeader() || isCreater()){
            self.state = false
        }
    }
    
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(Group(id: -1, name: "", leaderId: -1, info: ""),true)
    }
}


